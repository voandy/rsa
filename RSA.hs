module RSA
( generateKeys
, modExp
, crackKey
) where

import Data.Bits
import Math.NumberTheory.Powers.Squares

-- naive primality test by trial division
isPrime :: (Integral a) => a -> Bool
isPrime n
    | n <= 1 = False
    | n <= 3 = True
    | (mod n 2 == 0) || (mod n 3 == 0) = False
    | any ((==0).rem n) [5,11..floor.sqrt.fromIntegral $ n + 1] = False
    | any ((==0).rem n) [7,13..floor.sqrt.fromIntegral $ n + 1] = False
    | otherwise = True

-- returns the first prime greater than the seed n
nextPrime :: (Integral a) => a -> a
nextPrime n = if mod n 2 == 0 then nextPrime' (n + 1) else nextPrime' n
    where nextPrime' m = if isPrime m then m else nextPrime (n + 2)

-- finds the greatest common divisor of m and n using the Euclidean algorithm
euclidGCD :: (Integral a) => a -> a -> a
euclidGCD a b = if b == 0 then a else euclidGCD b (mod a b)

-- extended Euclidean algorithm 
-- https://rosettacode.org/wiki/Modular_inverse
extendedGCD :: (Integral a) => a -> a -> (a, a, a)
extendedGCD a 0 = (1, 0, a)
extendedGCD a b = let (q, r) = a `quotRem` b
                      (s, t, g) = extendedGCD b r 
                  in (t, s - q * t, g)

-- modular inverse, assumes a and m are coprime
modInv :: (Integral a) => a -> a -> a
modInv a m = let (i, _, _) = extendedGCD a m in mkPos i
    where mkPos x = if x < 0 then x + m else x

-- increments e until it is coprime with phi
coPrime :: (Integral a) => a -> a -> a
coPrime e phi = if euclidGCD e phi == 1 then e 
                else coPrime (nextPrime (e + 1)) phi

-- takes 3 seed values and returns a public/private key pair and their modulus n
generateKeys :: (Integral a) => a -> a -> a -> (a, a, a)
generateKeys min_p min_q min_e = (d, e, n)
    where d = modInv e phi
          e = coPrime (nextPrime min_e) phi
          n = p * q
          p = nextPrime min_p 
          q = nextPrime min_q
          phi = (p - 1) * (q - 1)

-- This is prohibitively slow with larger numbers as Haskell tries to evaluate
-- b ^ e before calculating the remainder. We need to use a more efficient
-- method of modular exponentiation (see modExp).
encrypt :: (Integral a) => a -> a -> a -> a
encrypt msg key n = (mod (msg^key) n)

-- same as encrypt by much more efficient
-- encrypts/decrypts message b using public/private exponent e and modulus n
-- https://gist.github.com/trevordixon/6788535
modExp :: Integer -> Integer -> Integer -> Integer
modExp b 0 n = 1
modExp b e n = t * modExp ((b * b) `mod` n) (shiftR e 1) n `mod` n
           where t = if testBit e 0 then b `mod` n else 1

-- given a public exponent e and modulus n, returns the private key d
crackKey :: (Integral a) => a -> a -> a
crackKey e n = d
    where d = modInv e phi
          (p, q) = rhoFactor n
          phi = (p - 1) * (q - 1)

-- finds the prime factors p and q of a public modulus n using Fermat's 
-- factorisation method
fermatFactor :: (Integral a) => a -> (a, a)
fermatFactor n = ((a - b), (a + b))
    where a = fermatA init n
          init = ceiling.sqrt.fromIntegral $ n
          b = floor.sqrt.fromIntegral $ a^2 - n

fermatA :: (Integral a) => a -> a -> a
fermatA a n = if isSquare' (a^2 - n) then a else fermatA (a + 1) n

-- finds the prime factors p and q of n using rho factorisation
rhoFactor :: (Integral a) => a -> (a, a)
rhoFactor n = (g, div n g)
    where g = gcd n (a2 - a1)
          (a1, a2) = rhoA (g' a0) (g' (g' a0)) n
          g' x = mod (x^2 + 10) n
          c = 1
          a0 = 10

rhoA :: (Integral a) => a -> a -> a -> (a, a)
rhoA a1 a2 n = if gcd n (a2 - a1) /= 1 then (a1, a2) 
               else rhoA (g' a1) (g' (g' a2)) n
               where g' x = mod (x^2 + 10) n

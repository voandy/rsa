import System.Random
import Data.Maybe

-- naive primality test by trial division
isPrime :: Integer -> Bool
isPrime n
    | n <= 1 = False
    | n <= 3 = True
    | (mod n 2 == 0) || (mod n 3 == 0) = False
    | any ((==0).rem n) [5,11..floor.sqrt.fromIntegral $ n + 1] = False
    | any ((==0).rem n) [7,13..floor.sqrt.fromIntegral $ n + 1] = False
    | otherwise = True

-- returns the first prime greater than a seed m
nextPrime :: Integer -> Integer
nextPrime n = if mod n 2 == 0 then nextPrime' (n + 1) else nextPrime' n
    where nextPrime' m = if isPrime m then m else nextPrime (n + 2)

-- finds the greatest common divisor of m and n using the Euclidean algorithm
euclidGCD :: Integer -> Integer -> Integer
euclidGCD m n = if n == 0 then m else euclidGCD n (mod m n)

-- extended Euclidean algorithm https://rosettacode.org/wiki/Modular_inverse#Haskell
extendedGCD :: Integer -> Integer -> (Integer, Integer, Integer)
extendedGCD a 0 = (1, 0, a)
extendedGCD a b = let (q, r) = a `quotRem` b
                      (s, t, g) = extendedGCD b r in (t, s - q * t, g)

-- modular inverse https://rosettacode.org/wiki/Modular_inverse#Haskell
modInv :: Integer -> Integer -> Maybe Integer
modInv a m = let (i, _, g) = extendedGCD a m in if g == 1 then Just (mkPos i) else Nothing
    where mkPos x = if x < 0 then x + m else x

-- takes 3 seed values and returns a public/private key pair and their modulus
generateKeys :: Integer -> Integer -> Integer -> (Integer, Integer, Integer)
generateKeys min_p min_q min_e = (d, e, n)
    where
        p = nextPrime min_p
        q = nextPrime min_q
        n = p * q
        phi = (p - 1) * (q - 1)
        e = gcdFinder (nextPrime min_e) phi
        d = fromJust (modInv e phi)

gcdFinder :: Integer -> Integer -> Integer
gcdFinder e phi = if euclidGCD e phi == 1 then e else gcdFinder (nextPrime (e + 1)) phi

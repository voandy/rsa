module RSA
( generateKeys
, coPrime
) where

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
                      (s, t, g) = extendedGCD b r in (t, s - q * t, g)

-- modular inverse, assumes a and m are coprime
modInv :: (Integral a) => a -> a -> a
modInv a m = let (i, _, _) = extendedGCD a m in mkPos i
    where mkPos x = if x < 0 then x + m else x

-- increments e until it is coprime with phi
coPrime :: (Integral a) => a -> a -> a
coPrime e phi = if euclidGCD e phi == 1 then e else coPrime (nextPrime (e + 1)) phi

-- takes 3 seed values and returns a public/private key pair and their modulus
generateKeys :: (Integral a) => a -> a -> a -> (a, a, a)
generateKeys min_p min_q min_e = (d, e, n)
    where p = nextPrime min_p 
          q = nextPrime min_q
          phi = (p - 1) * (q - 1)
          n = p * q
          e = coPrime (nextPrime min_e) phi
          d = modInv e phi

-- strConvert :: (Integral a) => String -> [a]

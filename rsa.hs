import System.Random

-- naive primality test by trial division
isPrime :: Integer -> Bool
isPrime n
    | n <= 1 = False
    | n <= 3 = True
    | (mod n 2 == 0) || (mod n 3 == 0) = False
    | any ((==0).rem n) [5,11..floor.sqrt.fromIntegral $ n + 1] = False
    | any ((==0).rem n) [7,13..floor.sqrt.fromIntegral $ n + 1] = False
    | otherwise = True

-- returns the first prime greater than seed
nextPrime :: Integer -> Integer
nextPrime n = if mod n 2 == 0 then nextPrime' (n + 1) else nextPrime' (n + 2)
    where nextPrime' m = if isPrime m then m else nextPrime (n + 2)

-- finds the greatest common divisor of m and n using the Euclidean algorithm
euclidGCD :: Integer -> Integer -> Integer
euclidGCD m n = if n == 0 then m else euclidGCD n (mod m n)

-- extended Euclidean algorithm
-- wikibooks https://tinyurl.com/ybtrevtz
extendedGCD :: Integer -> Integer -> (Integer, Integer, Integer)
extendedGCD 0 b = (b, 0, 1)
extendedGCD a b = let (g, s, t) = extendedGCD (b `mod` a) a
    in (g, t - (b `div` a) * s, s)

-- takes 3 seed values and returns a public/private key pair and their modulus
generateKeys :: Integer -> Integer -> Integer -> (Integer, Integer, Integer)
generateKeys min_p min_q min_e = (d, e, n)
    where
        p = nextPrime min_p
        q = nextPrime min_q
        e = nextPrime min_e
        n = p * q
        phi = (p - 1) * (q - 1)


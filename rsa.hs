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
nextPrime n = nextPrime' (n + 1)
    where nextPrime' m = if isPrime m then m else nextPrime (n + 1)

-- finds the greatest common divisor of m and n using the Euclidean algorithm
gcd:: Integer -> Integer -> Integer
gcd m n = if n == 0 then m else gcd n (mod m n)
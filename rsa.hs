-- naive primality test by trial division
isPrime :: Integer -> Bool
isPrime n
    | n <= 1 = False
    | n <= 3 = True
    | (mod n 2 == 0) || (mod n 3 == 0) = False
    |    all ((>0).rem n) [5,11..floor.sqrt.fromIntegral $ n + 1]
      && all ((>0).rem n) [7,13..floor.sqrt.fromIntegral $ n + 1] = True
    | otherwise = False

-- returns the first prime greater than seed
brutePrime :: Integer -> Integer
brutePrime seed
brutePrime <= 2 = seed
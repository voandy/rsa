import RSA
import System.IO

main = do
    putStr "Enter public modulus n: \n"
    arg <- getLine
    let n = read arg

    putStr "Enter public exponent e: \n"
    arg <- getLine
    let e = read arg

    let d = crackKey e n

    putStr "The cracked private is: \n"
    putStr $ (show d) ++ "\n"
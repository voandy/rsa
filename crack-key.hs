import RSA
import System.IO

main = do
    handle <- openFile "id_rsa.pub" ReadMode

    arg <- hGetLine handle
    let e = read arg
    arg <- hGetLine handle
    let n = read arg
    hClose handle

    let d = crackKey e n

    putStr "The cracked private is: \n"
    putStr $ (show d) ++ "\n"
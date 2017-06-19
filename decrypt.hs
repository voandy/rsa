import RSA
import System.IO

main = do
    handle <- openFile "id_rsa" ReadMode

    arg <- hGetLine handle
    let d = read arg

    arg <- hGetLine handle
    let m = read arg

    hClose handle

    putStr "Enter message to decrypt: \n"
    arg <- getLine
    let b = read arg

    let c = modExp b d m
    putStr "The decrypted message is: \n"
    putStr $ (show c) ++ "\n"
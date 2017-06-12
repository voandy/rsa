import RSA
import System.IO
import Data.Char
import System.Random

-- generates random integer between 10^11 and 10^12
randInt :: IO Integer
randInt = randomRIO (10^11, 10^12)

-- generate a public/private key pair and outputs them to files
main = do
    min_p <-randInt
    min_q <-randInt
    min_e <-randInt
    (private, public, modulus) <- return (generateKeys min_p min_q min_e)
    
    writeFile "id_rsa" (show private ++ "\n" ++ show modulus)
    writeFile "id_rsa.pub" (show public ++ "\n" ++ show modulus)

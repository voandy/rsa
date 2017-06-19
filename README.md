# RSA Key Pair Generator and Encrypter/Decrypter

A very basic (and massively insecure) implementation of the RSA cryptosystem I wrote to wet my feet in Haskell. This code was written recreationally and it goes without saying it should not be used for real-world cryptography under any circumstances.

### Cracking the Cryptosystem

To prove how easy it is to crack an RSA cryptosystem using such small keys, I've started work on a function to obtain the private get given the public key and modulus. All we have to do is factorise m into its prime components p and q and we will be able to to re-calculate d using the same process by which it was originally generated.
# RSA Key Pair Generator and Encrypter/Decrypter

A very basic (and massively insecure) implementation of the RSA cryptosystem I wrote to wet my feet in Haskell. This code was written recreationally and it goes without saying it should not be used for real-world cryptography under any circumstances.

### Cracking the Cryptosystem

To prove how easy it is to crack an RSA cryptosystem using such small keys (11 decimal digits or 36-bit), I also wrote a function to obtain the private key given the public exponent and modulus. All we have to do is factorise n into its prime components p and q and we will be able to to recalculate d using the same process by which it was originally generated.
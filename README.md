# RSA Key Pair Generator and Encrypter/Decrypter

A very basic (and massively insecure) implementation of the RSA cryptosystem I wrote to wet my feet in Haskell. This code was written recreationally and for learning purposes so it goes without saying it should not be used for real-world cryptography under any circumstances.

## Cracking the Cryptosystem

To prove how easy it is to crack an RSA cryptosystem using such small keys (11 decimal digits or 36-bits), I also wrote a function crackKey to obtain the private key given the public exponent and modulus. All we have to do is factorise n into its prime components p and q and we will be able to to recalculate d using the same process by which it was originally generated.

#### Fermat Factorisation

My first attempt used Fermat's factorisation method but it turns out our keys are fairly safe against this since p and q by construction are unlikely to share many leading bits.

https://en.wikipedia.org/wiki/Fermat%27s_factorization_method

#### Pollard's rho algorithm

The rho method of factorisation is much more efficient taking roughly only 3 seconds on average to factorise our 36-bit public modulus on my i5 laptop. The rho algorithm takes on average sqrt(p) operations to find p. This is roughly 10^5 operations in the case of our keys so very doable on any modern computer. 

In the case of a 2048-bit key (the current industry standard) it would take, by my rough calculations, 10^154 operations so it's fair to say that they are safe against rho factorisation even on the most powerful supercomputers.

http://facthacks.cr.yp.to/rho.html

https://en.wikipedia.org/wiki/Pollard%27s_rho_algorithm

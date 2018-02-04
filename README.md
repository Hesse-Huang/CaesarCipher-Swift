#CaesarCipher-Swift  

##Introduction

My assignment is implemented with Swift the programming language by Apple. 

You may download the source code [here](https://github.com/Hesse-Huang/CaesarCipher-Swift).



## Usage

1. You may need to [download Swift](https://swift.org/download/) before running the program;
2. Run the following commands:


```sh
$ git clone https://github.com/Hesse-Huang/CaesarCipher-Swift.git
$ cd CaesarCipher-Swift/CaesarCipher-Swift
$ swift main.swift plaintext.txt
```

3. Run `$ open .`  to see the output files.



## Encryption process

After reading the file as a string, we first lowercase it, and then convert it into a C string, which actually is an Array of 8-bit integer. For each of 8-bit integer, we only process the one limited in range 97~122 (both of bounds included) with the following steps: 

**minus 97, plus KEY, mod 26, plus 97**

Finally, we convert the processed integers back to C string, and export it into "ciphertext.txt".



## Decryption process

Similarly, for the decryption process, we first read the cipher text, and then process those integers by the following steps:

**minus 97, minus KEY, plus 26 if negative, mod 26, plus 97**

And exporting the converted string into "decrypted_plaintext.txt".



## Snapshots 

![屏幕快照 2018-02-04 下午5.24.45](/Users/Hesse/Desktop/屏幕快照 2018-02-04 下午5.24.45.png)
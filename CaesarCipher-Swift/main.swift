//
//  main.swift
//  CaesarCipher-Swift
//
//  Created by Hesse Huang on 2018/2/4.
//  Copyright © 2018年 Hesse. All rights reserved.
//

import Foundation

let args = CommandLine.arguments

guard args.count >= 2 else {
    print("Error: Please specify an input file only as the plain text to be encrypted.")
    exit(0)
}

var k: Int8 = 3

if args[1] == "-k" {
    guard args.count >= 4, let key = Int8(args[2]), key > 0 && k < 26 else {
        print("Error: -k is given without a valid number as key")
        exit(0)
    }
    k = key
}

let fileManager = FileManager.`default`
let plainTextPath = args[args.count - 1]
let cipherTextPath = fileManager.currentDirectoryPath + "/ciphertext.txt"
let decryptedPlainTextPath = fileManager.currentDirectoryPath + "/decrypted_plaintext.txt"


/// Try to read the content of file at the given path
///
/// - Parameter path: The location of file
/// - Returns: The content of file as a string; `nil` if problems occur when trying to read it.
func tryToReadContents(atPath path: String) -> String? {
    guard let file = FileHandle(forReadingAtPath: path) else {
        print("Error: Cannot read file at path: \(path)")
        return nil
    }
    defer {
        file.closeFile()
    }
    
    let data = file.readDataToEndOfFile()
    guard let str = String(bytes: data, encoding: .utf8) else {
        print("Error: Unable to convert a string from some data")
        return nil
    }
    return str
}


/// Try to write a string into a newly created file at the given path
///
/// - Parameters:
///   - contents: The contents to be written
///   - path: The location of a file that is newly created
func tryToWrite(contents: String, atPath path: String) {
    guard let data = contents.data(using: .utf8) else {
        print("Error: Unable to convert data from cipher text")
        return
    }
    fileManager.createFile(atPath: path, contents: data, attributes: nil)
}


/// Encrypt the plain text into Caesar cipher with the specified key
///
/// - Parameters:
///   - key: The key to used when encryption
///   - plainText: The plain text to be encrypted
/// - Returns: Encrypted cipher text
func encryptToCaesarCipher(key: Int8, plainText: String) -> String {
    let plaintext = plainText.trimmingCharacters(in: .newlines)
    var cstr: [CChar] = plaintext.utf8CString.map {
        // lowercased letters
        if $0 >= 97 && $0 <= 122 {
            return ($0 - 97 + key) % 26 + 97
        }
        // uppercased letters
        else if $0 >= 65 && $0 <= 90 {
            return ($0 - 65 + key) % 26 + 65
        }
        // others
        else {
            return $0
        }
    }
    return String(cString: &cstr)
}



/// Decrypt the cipher text from Caesar cipher with the specified key
///
/// - Parameters:
///   - key: The key to used when encryption
///   - cipherText: The cipher text to be decrypted
/// - Returns: Decrypted plain text
func decryptFromCaesarCipher(key: Int8, cipherText: String) -> String {
    var cstr: [CChar] = cipherText.utf8CString.map {
        // lowercased letters
        if $0 >= 97 && $0 <= 122 {
            var i = $0 - 97 - key
            if i < 0 { i += 26 }
            return i % 26 + 97
        }
        // uppercased letters
        else if $0 >= 65 && $0 <= 90 {
            var i = $0 - 65 - key
            if i < 0 { i += 26 }
            return i % 26 + 65
        }
        // others
        else {
            return $0
        }
    }
    return String(cString: &cstr)
}


// Encrypting the plain text
if let plainText = tryToReadContents(atPath: plainTextPath) {
    let cipherText = encryptToCaesarCipher(key: k, plainText: plainText)
    tryToWrite(contents: cipherText, atPath: cipherTextPath)
    print("Output file: " + cipherTextPath)
}

// Decrypting the cipher text
if let cipherText = tryToReadContents(atPath: cipherTextPath) {
    let decryptedPlainText = decryptFromCaesarCipher(key: k, cipherText: cipherText)
    tryToWrite(contents: decryptedPlainText, atPath: decryptedPlainTextPath)
    print("Output file: " + decryptedPlainTextPath)
}





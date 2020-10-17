//
//  Utilities.swift
//  ChatApplication
//
//  Created by Swiftaholic on 4/27/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import Foundation

func uint8ArrayToString (arr: Array <UInt8>) -> String {
    var resultString: String = ""
    for element in arr {
        resultString += "\(element),"
    }
    
    return resultString
}

func stringToUInt8Array (str: String) -> Array <UInt8> {
    var resultArray: Array <UInt8> = []
    var number: UInt8 = 0
    
    for character in str {
        if character == "," {
            resultArray.append(number)
            number = 0
            continue
        }
        
        number = (number << 3) + (number << 1) + UInt8(String(character))!
    }
    
    return resultArray
}

func generateSalt() -> String {
    var salt: String = ""
    for _ in 0..<Constants.CryptoData.SaltLength {
        let randomNumber = Int.random(in: 0...61)
        
        if randomNumber >= 0 && randomNumber <= 25 {
            salt.append(Character(UnicodeScalar(randomNumber + 65)!))
        } else if randomNumber >= 26 && randomNumber <= 51 {
            salt.append(Character(UnicodeScalar(randomNumber + 71)!))
        } else {
            salt.append("\(randomNumber - 52)")
        }
    }
    
    return salt
}

func generateMessageKey() -> String {
    var messageKey: String = ""
    for _ in 0..<Constants.Message.Key.Length {
        let randomNumber = Int.random(in: 0...61)
        
        if randomNumber >= 0 && randomNumber <= 25 {
            messageKey.append(Character(UnicodeScalar(randomNumber + 65)!))
        } else if randomNumber >= 26 && randomNumber <= 51 {
            messageKey.append(Character(UnicodeScalar(randomNumber + 71)!))
        } else {
            messageKey.append("\(randomNumber - 52)")
        }
    }
    
    return messageKey
}

extension String {
    func toUInt8() -> Array <UInt8> {
        return stringToUInt8Array(str: self)
    }
}

extension Array where Element == UInt8 {
    func toString() -> String {
        return uint8ArrayToString(arr: self)
    }
}

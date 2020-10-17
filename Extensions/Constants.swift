//
//  Constants.swift
//  ChatApplication
//
//  Created by Swiftaholic on 4/25/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import Foundation

struct Constants {
    struct Priority {
        static let High = 1000
        static let Medium = 750
        static let Low = 250
        static let None = 1
    }
    
    struct CryptoData {
        static let SaltLength = 20
        static let IterationCount = 10000
        static let KeyLength = 32
    }
    
    struct DefaultImageURL {
        static let Avatar: String = "https://i.stack.imgur.com/l60Hf.png"
        static let CoverPhoto: String = "https://i.stack.imgur.com/l60Hf.png"
    }
    
    struct DefaultUserInfo {
        static let Biography: String = "Empty. Update your biography!"
    }
    
    struct Requirements {
        struct Username {
            static let minLength = 4
            static let maxLength = 16
        }
        
        struct Password {
            static let minLength = 4
            static let maxLength = 32
        }
    }
    
    struct Message {
        struct Recipient {
            static let DefaultForGroup = "noneRecipient"
        }
        
        struct MessageType {
            static let Personal = "personal"
            static let Group = "group"
        }
        
        struct Key {
            static let Length = 30
        }
    }
}

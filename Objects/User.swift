//
//  User.swift
//  ChatApplication
//
//  Created by Swiftaholic on 4/20/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import Foundation
import CryptoSwift

final class User {
    private var username: String
    private var password: String
    private var salt: String
    private var iterationCount: Int
    
    init(username: String, password: String, salt: String, iterationCount: Int) {
        self.username = username
        self.password = password
        self.salt = salt
        self.iterationCount = iterationCount
    }
    
    func getUsername() -> String {
        return self.username
    }
    
    func setUsername(username: String) {
        self.username = username
    }
    
    func getPassword() -> String {
        return self.password
    }
    
    func setPassword(password: String) {
        self.password = password
    }
    
    func getSalt() -> String {
        return self.salt
    }
    
    func setSalt(salt: String) {
        self.salt = salt
    }
    
    func getIterationCount() -> Int {
        return self.iterationCount
    }
    
    func setIterationCount(iterationCount: Int) {
        self.iterationCount = iterationCount
    }
}

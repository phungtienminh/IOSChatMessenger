//
//  UserDB.swift
//  ChatApplication
//
//  Created by Swiftaholic on 4/20/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import Foundation
import SQLite3

final class UserDB {
    static let sharedInstance = UserDB()
    
    private init(){
        db = openDatabase()
    }

    let dbPath: String = "UserDB.sqlite"
    var db: OpaquePointer?

    func closeDatabase() {
        sqlite3_close(db)
    }
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        } else {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS User(username TEXT PRIMARY KEY, password TEXT, salt TEXT, iterationCount INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("table created.")
            } else {
                print("table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(username: String, password: String, salt: String, iterationCount: Int) {
        let allData = read(username: username)
        if allData.count > 0 { return }
        
        let insertStatementString = "INSERT INTO User(username, password, salt, iterationCount) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (salt as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, Int32(iterationCount))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [User] {
        let queryStatementString = "SELECT * FROM User;"
        var queryStatement: OpaquePointer? = nil
        var resultData: [User] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let username = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let salt = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let iterationCount = sqlite3_column_int(queryStatement, 3)
                resultData.append(User(username: username, password: password, salt: salt, iterationCount: Int(iterationCount)))
                
                print("Query Result:")
                print("\(username) | \(password) | \(salt) | \(iterationCount)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        return resultData
    }
    
    func read(username: String) -> [User] {
        let queryStatementString = "SELECT * FROM User WHERE username = ?;"
        var queryStatement: OpaquePointer? = nil
        var resultData: [User] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (username as NSString).utf8String, -1, nil)
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let username = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let salt = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let iterationCount = sqlite3_column_int(queryStatement, 3)
                resultData.append(User(username: username, password: password, salt: salt, iterationCount: Int(iterationCount)))
                
                print("Query Result 2:")
                print("\(username) | \(password) | \(salt) | \(iterationCount)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        return resultData
    }
    
    func deleteByUsername(username: String) {
        let deleteStatementString = "DELETE FROM User WHERE username = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (username as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    func updatePassword(username: String, password: String) {
        let updateStatementString = "UPDATE User SET password = ? WHERE username = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 2, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 1, (password as NSString).utf8String, -1, nil)
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement is not prepared")
        }
        
        sqlite3_finalize(updateStatement)
    }
    
    func updateIterationCount(username: String, iterationCount: Int) {
        let updateStatementString = "UPDATE User SET iterationCount = ? WHERE username = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 2, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 1, Int32(iterationCount))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            }
            else {
                print("Could not update row.")
            }
        }
        else {
            print("UPDATE statement is not prepared")
        }
        sqlite3_finalize(updateStatement)
    }
}

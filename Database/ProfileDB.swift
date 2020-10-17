//
//  ProfileDB.swift
//  ChatApplication
//
//  Created by Swiftaholic on 4/20/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import Foundation
import SQLite3

final class ProfileDB {
    static let sharedInstance = ProfileDB()
    
    private init(){
        db = openDatabase()
    }

    let dbPath: String = "ProfileDB.sqlite"
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
        let createTableString = "CREATE TABLE IF NOT EXISTS Profile(username TEXT PRIMARY KEY, coverPhotoUrl TEXT, avatarUrl TEXT, displayName TEXT, biography TEXT);"
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
    
    
    func insert(username: String, coverPhotoUrl: String, avatarUrl: String, displayName: String, biography: String) {
        let allData = read(username: username)
        if allData.count > 0 { return }
        
        let insertStatementString = "INSERT INTO Profile(username, coverPhotoUrl, avatarUrl, displayName, biography) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (coverPhotoUrl as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (avatarUrl as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (displayName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (biography as NSString).utf8String, -1, nil)
            
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
    
    func read() -> [Profile] {
        let queryStatementString = "SELECT * FROM Profile;"
        var queryStatement: OpaquePointer? = nil
        var resultData: [Profile] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let username = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let coverPhotoUrl = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let avatarUrl = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let displayName = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let biography = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                
                resultData.append(Profile(username: username, coverPhotoUrl: coverPhotoUrl, avatarUrl: avatarUrl, displayName: displayName, biography: biography))
                //print("Query Result:")
                //print("\(id) | \(answer) | \(best)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return resultData
    }
    
    func read(username: String) -> [Profile] {
        let queryStatementString = "SELECT * FROM Profile WHERE username = ?;"
        var queryStatement: OpaquePointer? = nil
        var resultData: [Profile] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (username as NSString).utf8String, -1, nil)
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let username = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let coverPhotoUrl = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let avatarUrl = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let displayName = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let biography = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                
                resultData.append(Profile(username: username, coverPhotoUrl: coverPhotoUrl, avatarUrl: avatarUrl, displayName: displayName, biography: biography))
                //print("Query Result 2:")
                //print("\(id) | \(answer) | \(best)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        return resultData
    }
    
    func deleteByUsername(username: String) {
        let deleteStatementString = "DELETE FROM Profile WHERE username = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (username as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            }
            else {
                print("Could not delete row.")
            }
        }
        else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func update(username: String, coverPhotoUrl: String) {
        let updateStatementString = "UPDATE Profile SET coverPhotoUrl = ? WHERE username = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (coverPhotoUrl as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (username as NSString).utf8String, -1, nil)
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
    
    func update(username: String, avatarUrl: String) {
        let updateStatementString = "UPDATE Profile SET avatarUrl = ? WHERE username = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (avatarUrl as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (username as NSString).utf8String, -1, nil)
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
    
    func update(username: String, displayName: String) {
        let updateStatementString = "UPDATE Profile SET displayName = ? WHERE username = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (displayName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (username as NSString).utf8String, -1, nil)
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
    
    func update(username: String, biography: String) {
        let updateStatementString = "UPDATE Profile SET biography = ? WHERE username = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (biography as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (username as NSString).utf8String, -1, nil)
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

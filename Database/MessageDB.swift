//
//  MessageDB.swift
//  ChatApplication
//
//  Created by Swiftaholic on 5/5/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import Foundation
import SQLite3

final class MessageDB {
    static let sharedInstance = MessageDB()
    
    private init(){
        db = openDatabase()
    }

    let dbPath: String = "MessageDB.sqlite"
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
        let createTableString = "CREATE TABLE IF NOT EXISTS Message(messageKey TEXT PRIMARY KEY, messageSender TEXT, recipient TEXT, content TEXT, messageDate TEXT, messageType TEXT);"
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
    
    
    func insert(messageKey: String, messageSender: String, recipient: String, content: String, messageDate: String, messageType: String) {
        let allData = read(messageKey: messageKey)
        if allData.count > 0 { return }
        
        let insertStatementString = "INSERT INTO Message(messageKey, messageSender, recipient, content, messageDate, messageType) VALUES (?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (messageKey as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (messageSender as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (recipient as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (content as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (messageDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (messageType as NSString).utf8String, -1, nil)
            
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
    
    func read() -> [Message] {
        let queryStatementString = "SELECT * FROM Message;"
        var queryStatement: OpaquePointer? = nil
        var resultData: [Message] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let messageKey = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let messageSender = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let recipient = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let content = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let messageDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let messageType = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                resultData.append(Message(messageKey: messageKey, messageSender: messageSender, recipient: recipient, content: content, messageDate: messageDate, messageType: messageType))
                
                //print("Query Result:")
                //print("\(username) | \(password) | \(salt) | \(iterationCount)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        return resultData
    }
    
    func read(messageKey: String) -> [Message] {
        let queryStatementString = "SELECT * FROM Message WHERE messageKey = ?;"
        var queryStatement: OpaquePointer? = nil
        var resultData: [Message] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (messageKey as NSString).utf8String, -1, nil)
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let messageKey = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let messageSender = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let recipient = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let content = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let messageDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let messageType = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                resultData.append(Message(messageKey: messageKey, messageSender: messageSender, recipient: recipient, content: content, messageDate: messageDate, messageType: messageType))
                
                //print("Query Result 2:")
                //print("\(username) | \(password) | \(salt) | \(iterationCount)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        return resultData
    }
    
    func read(messageType: String) -> [Message] {
        let queryStatementString = "SELECT * FROM Message WHERE messageType = ?;"
        var queryStatement: OpaquePointer? = nil
        var resultData: [Message] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (messageType as NSString).utf8String, -1, nil)
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let messageKey = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let messageSender = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let recipient = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let content = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let messageDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let messageType = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                resultData.append(Message(messageKey: messageKey, messageSender: messageSender, recipient: recipient, content: content, messageDate: messageDate, messageType: messageType))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        return resultData
    }
    
    func deleteByUsername(messageKey: String) {
        let deleteStatementString = "DELETE FROM Message WHERE messageKey = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (messageKey as NSString).utf8String, -1, nil)
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
}

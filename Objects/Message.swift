//
//  Message.swift
//  ChatApplication
//
//  Created by Swiftaholic on 5/5/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import Foundation

final class Message {
    private var messageKey: String
    private var messageSender: String
    private var recipient: String
    private var content: String
    private var messageDate: String
    private var messageType: String
    
    init(messageKey: String, messageSender: String, recipient: String, content: String, messageDate: String, messageType: String) {
        self.messageKey = messageKey
        self.messageSender = messageSender
        self.recipient = recipient
        self.content = content
        self.messageDate = messageDate
        self.messageType = messageType
    }
    
    func getMessageKey() -> String {
        return self.messageKey
    }
    
    func setMessageKey(messageKey: String) {
        self.messageKey = messageKey
    }
    
    func getMessageSender() -> String {
        return self.messageSender
    }
    
    func setMessageSender(messageSender: String) {
        self.messageSender = messageSender
    }
    
    func getRecipient() -> String {
        return self.recipient
    }
    
    func setRecipient(recipient: String) {
        self.recipient = recipient
    }
    
    func getContent() -> String {
        return self.content
    }
    
    func setContent(content: String) {
        self.content = content
    }
    
    func getMessageDate() -> String {
        return self.messageDate
    }
    
    func setDate(messageDate: String) {
        self.messageDate = messageDate
    }
    
    func getMessageType() -> String {
        return self.messageType
    }
    
    func setMessageType(messageType: String) {
        self.messageType = messageType
    }
}

extension Message {
    func toSocketData() -> Dictionary<String, Any> {
        var resultJSON: Dictionary<String, Any> = [:]
        resultJSON["messageKey"] = self.getMessageKey()
        resultJSON["messageSender"] = self.getMessageSender()
        resultJSON["recipient"] = self.getRecipient()
        resultJSON["content"] = self.getContent()
        resultJSON["messageDate"] = self.getMessageDate()
        resultJSON["messageType"] = self.getMessageType()
        return resultJSON
    }
}

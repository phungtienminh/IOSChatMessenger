//
//  SocketIOManager.swift
//  ChatApplication
//
//  Created by Swiftaholic on 4/15/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import Foundation
import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    let manager = SocketManager(socketURL: URL(string: "http://192.168.100.8:3000")!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    let eventChat = "chat_message"
    let eventLogin = "login"
    let eventLogout = "logout"
    let eventUserList = "userList"
    override init() {
        super.init()
        socket = manager.defaultSocket
        listenMess(completion: nil)
        listenConnectedUsers(completion: nil)
    }
    
    func connect() {
        manager.connect()
    }
    
    func login(userName: String) {
        socket.emit(eventLogin, userName)
    }
     
    func logout() {
        socket.emit(eventLogout, "")
    }
    
    func sendMess(mess: String) {
        socket.emit(eventChat, mess)
    }
    
    func sendMess(mess: Message) {
        socket.emit(eventChat, mess.toSocketData())
    }
    
    func disconnect() {
        manager.disconnect()
    }
    
    func listenMess(completion: ((_ mess: Any?) -> Void)?) {
        socket.on(eventChat) {(data, ack) in
            completion?(data.first)
            //print("VIT: \(data.first ?? "")")
        }
    }
    
    func listenConnectedUsers(completion: ((_ userList: Array<Dictionary<String, Any>>?) -> Void)?) {
        socket.on(eventUserList) {(data, ack) in
            if let users = data.first as? Array<Dictionary<String, Any>> {
                completion?(users)
            }
            print("\(data.first ?? "")")
        }
    }
}

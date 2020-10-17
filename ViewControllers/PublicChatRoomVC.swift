//
//  PublicChatRoomVC.swift
//  ChatApplication
//
//  Created by Swiftaholic on 4/30/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class PublicChatRoomVC: UIViewController {
    @IBOutlet weak var txtOnlineUsers: UILabel!
    @IBOutlet weak var tblMessages: UITableView!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    
    var groupMessages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.hidesBackButton = true
        
        //Register nib for tableview
        self.tblMessages.register(UINib.init(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        self.tblMessages.delegate = self
        self.tblMessages.dataSource = self
        self.tblMessages.tableFooterView = UIView()
        
        //Listen for event chat from socketio
        listenChat()
        // Do any additional setup after loading the view.
    }
    
    func listenChat() {
        SocketIOManager.sharedInstance.listenMess { (mess) in
            self.tblMessages.reloadData()
            self.tblMessages.scrollToBottom()
        }
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        //Check if there exists a message to send
        guard let message = txtMessage.text, message.count > 0 else { return }
        
        //Generate message key
        let messageKey = generateMessageKey()
        
        //Current date
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd HH:mm"
        let formattedDate = format.string(from: date)
        
        //Insert to database
        MessageDB.sharedInstance.insert(messageKey: messageKey, messageSender: currentConnectedUsername, recipient: Constants.Message.Recipient.DefaultForGroup, content: message, messageDate: formattedDate, messageType: Constants.Message.MessageType.Group)
        
        //Send mess via socketio
        let messageForm = Message(messageKey: messageKey, messageSender: currentConnectedUsername, recipient: Constants.Message.Recipient.DefaultForGroup, content: message, messageDate: formattedDate, messageType: Constants.Message.MessageType.Group)
        SocketIOManager.sharedInstance.sendMess(mess: messageForm)
        
        //Clear text
        txtMessage.text = ""
    }
    
    @IBAction func logout(_ sender: UIButton) {
        let alert: UIAlertController = UIAlertController(title: "Logging out", message: "We are logging you out. Please wait for a few seconds...", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            //Dismiss alert
            alert.dismiss(animated: false, completion: nil)
            
            //Logout user
            currentConnectedUsername = ""
            SocketIOManager.sharedInstance.logout()
            
            //Back to previous scene
            self.navigationController?.popViewController(animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PublicChatRoomVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groupMessages = MessageDB.sharedInstance.read(messageType: Constants.Message.MessageType.Group)
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell {
            let message = groupMessages[indexPath.row]
            print(indexPath.row, message.getMessageSender(), currentConnectedUsername)
            let user = ProfileDB.sharedInstance.read(username: message.getMessageSender())
            
            if user.count > 0 {
                //load avatar image
                cell.imgAvatar.loadCustomPoster(posterPath: user.first!.getAvatarUrl())
            }
            
            //Assign value to each of cell properties.
            cell.lblName.text = message.getMessageSender()
            cell.lblDate.text = message.getMessageDate()
            cell.lblMessage.text = message.getContent()
            
            //Adjust border radius
            cell.imgAvatar.layer.cornerRadius = cell.imgAvatar.frame.size.width / 2
            cell.lblMessage.layer.masksToBounds = true
            cell.lblMessage.layer.cornerRadius = 5
            
            //If current message owner is this client, adjust layout constraints
            if message.getMessageSender() == currentConnectedUsername {
                //Avatar
                cell.leadingImgConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Constants.Priority.None))
                
                //Name
                cell.leadingNameConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Constants.Priority.None))
                cell.lblName.textAlignment = .right
                
                //Message
                cell.leadingMessageConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Constants.Priority.None))
                cell.trailingMessageConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Constants.Priority.None))
                cell.lblMessage.textAlignment = .right
                cell.lblMessage.backgroundColor = UIColor(red: 40/255, green: 181/255, blue: 77/255, alpha: 1.0)
                
                //Date
                cell.leadingDateConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Constants.Priority.None))
                cell.trailingDateConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Constants.Priority.None))
                cell.lblDate.textAlignment = .right
            } else {
                //Avatar
                cell.leadingImgConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Constants.Priority.High))
                
                //Name
                cell.leadingNameConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Constants.Priority.High))
                cell.lblName.textAlignment = .natural
                
                //Message
                cell.leadingMessageConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Constants.Priority.High))
                cell.trailingMessageConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Constants.Priority.High))
                cell.lblMessage.textAlignment = .natural
                cell.lblMessage.backgroundColor = .opaqueSeparator
                
                //Date
                cell.leadingDateConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Constants.Priority.High))
                cell.trailingDateConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Constants.Priority.High))
                cell.lblDate.textAlignment = .natural
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension PublicChatRoomVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension UITableView {
    func scrollToBottom() {
        let nrows = self.numberOfRows(inSection: 0)
        if nrows > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: nrows - 1, section: 0)
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}

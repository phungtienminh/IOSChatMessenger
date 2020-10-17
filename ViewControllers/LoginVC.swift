//
//  LoginVC.swift
//  ChatApplication
//
//  Created by Swiftaholic on 4/26/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit
import CryptoSwift

var currentConnectedUsername: String = ""

class LoginVC: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblIncorrect: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.layer.cornerRadius = 20
        btnSignup.layer.cornerRadius = 20
        txtUsername.delegate = self
        txtPassword.delegate = self
        txtUsername.tag = 0
        txtPassword.tag = 1
        txtPassword.autocorrectionType = .no
        
        //Add tap gesture to dismiss the keyboard whenever user touches outside textfields
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func login(_ sender: UIButton) {
        //Close all keyboards.
        view.endEditing(true)
        
        //Check for minimum length and maximum length requirements.
        guard let username = txtUsername.text else { return }
        guard let password = txtPassword.text else { return }
        
        //Check if exists such an user with username.
        let data = UserDB.sharedInstance.read(username: username)
        if data.count == 0 {
            lblIncorrect.isHidden = false
            return
        }
        
        var successfulLogin: Bool = false
        var alert: UIAlertController = UIAlertController()
        
        //Create alert
        alert = UIAlertController(title: "Logging in", message: "We are logging you in. Please wait for a few seconds...", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.global(qos: .background).async {
            do {
                //Create hashed password from input password and check if it matches password of username in database.
                let realPassword: Array <UInt8> = Array(password.utf8)
                let salt: Array <UInt8> = Array(data.first!.getSalt().utf8)
                let iterationCount = data.first!.getIterationCount()
                let hashedPassword = try PKCS5.PBKDF2(password: realPassword, salt: salt, iterations: iterationCount, keyLength: Constants.CryptoData.KeyLength, variant: .sha256).calculate()
                
                if hashedPassword == data.first!.getPassword().toUInt8() {
                    //Successful login.
                    successfulLogin = true
                } else {
                    //Unsuccessful login.
                    successfulLogin = false
                }
            } catch {
                print("Cannot create an encrypted key.")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                alert.dismiss(animated: false, completion: nil)
                if successfulLogin {
                    //Login successfully.
                    self.lblIncorrect.isHidden = true
                    
                    //Login SocketIO
                    SocketIOManager.sharedInstance.login(userName: username)
                    currentConnectedUsername = username
                    
                    //Clear txtUsername and txtPassword content
                    self.txtUsername.text = ""
                    self.txtPassword.text = ""
                        
                    //Dismiss alert and move to main chat room
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let messengerVC = storyboard.instantiateViewController(withIdentifier: "MessengerTabBarVC")
                    self.navigationController?.pushViewController(messengerVC, animated: true)
                } else {
                    //Unsuccessful login.
                    self.lblIncorrect.isHidden = false
                }
            }
        }
        
        /*
        alert.dismiss(animated: false, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if successfulLogin {
                //Login successfully.
                self.lblIncorrect.isHidden = true
                
                //Login SocketIO
                SocketIOManager.sharedInstance.login(userName: username)
                currentConnectedUsername = username
                
                //Clear txtUsername and txtPassword content
                self.txtUsername.text = ""
                self.txtPassword.text = ""
                    
                //Dismiss alert and move to main chat room
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let messengerVC = storyboard.instantiateViewController(withIdentifier: "MessengerTabBarVC")
                self.navigationController?.pushViewController(messengerVC, animated: true)
            } else {
                //Unsuccessful login.
                self.lblIncorrect.isHidden = false
            }
        }
        */
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        //Clear txtUsername, txtPassword content and hide lblIncorrect
        DispatchQueue.main.async {
            self.txtUsername.text = ""
            self.txtPassword.text = ""
            self.lblIncorrect.isHidden = true
        }
        
        //Go to RegisterVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterVC")
        self.navigationController?.pushViewController(registerVC, animated: true)
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

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let contentText = textField.text, contentText.count > 0 else { return false }
        
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) as? UITextField {
            textField.resignFirstResponder()
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

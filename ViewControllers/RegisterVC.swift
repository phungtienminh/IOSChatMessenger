//
//  RegisterVC.swift
//  ChatApplication
//
//  Created by Swiftaholic on 4/27/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit
import CryptoSwift

class RegisterVC: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmedPassword: UITextField!
    @IBOutlet weak var txtDisplayName: UITextField!
    @IBOutlet weak var lblExistAccount: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        //Clear all textfield content.
        txtUsername.text = ""
        txtPassword.text = ""
        txtConfirmedPassword.text = ""
        txtDisplayName.text = ""
        lblExistAccount.isHidden = true
        
        //Configure autocorrect for passwords.
        txtPassword.autocorrectionType = .no
        txtConfirmedPassword.autocorrectionType = .no
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.hidesBackButton = true
        btnRegister.layer.cornerRadius = 20
        
        //Set delegate
        txtUsername.delegate = self
        txtPassword.delegate = self
        txtConfirmedPassword.delegate = self
        txtDisplayName.delegate = self
        
        //Set tag
        txtUsername.tag = 0
        txtPassword.tag = 1
        txtConfirmedPassword.tag = 2
        txtDisplayName.tag = 3
        
        //Add tap gesture to dismiss the keyboard whenever user touches outside textfields
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func register(_ sender: UIButton) {
        /* Criteria:
         - Username should have between 4 and 16 characters.
         - Password should have between 4 and 32 characters.
         - Display name should have between 4 and 16 characters.
         - Confirmed password should match password.
         */
        
        //Close all currently active keyboards.
        view.endEditing(true)
        guard let username = txtUsername.text,
                             username.count >= Constants.Requirements.Username.minLength,
                             username.count <= Constants.Requirements.Username.maxLength else {
            lblExistAccount.text = "Username should have between 4 and 16 characters."
            lblExistAccount.isHidden = false
            return
        }
        guard let password = txtPassword.text,
                             password.count >= Constants.Requirements.Password.minLength,
                             password.count <= Constants.Requirements.Password.maxLength else {
            lblExistAccount.text = "Password should have between 4 and 32 characters."
            lblExistAccount.isHidden = false
            return
        }
        guard let confirmedPassword = txtConfirmedPassword.text, confirmedPassword == password else {
            lblExistAccount.text = "Confirmed password did not match."
            lblExistAccount.isHidden = false
            return
        }
        guard let displayName = txtDisplayName.text,
                                displayName.count >= Constants.Requirements.Username.minLength,
                                displayName.count <= Constants.Requirements.Username.maxLength else {
            lblExistAccount.text = "Display name should have between 4 and 16 characters."
            lblExistAccount.isHidden = false
            return
        }
        
        //Username already exists
        let data = UserDB.sharedInstance.read(username: username)
        if data.count > 0 {
            lblExistAccount.text = "Username already exists."
            lblExistAccount.isHidden = false
            return
        }
        
        //Ok => Hide label
        lblExistAccount.isHidden = true
        
        //Insert user to database. Have to use another DispatchQueue to avoid a deadlock.
        var alert: UIAlertController = UIAlertController()
        alert = UIAlertController(title: "Signing Up", message: "We are creating your account. Please wait...", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    
        DispatchQueue.global(qos: .background).async {
            //Insert to profile database
            ProfileDB.sharedInstance.insert(username: username, coverPhotoUrl: Constants.DefaultImageURL.CoverPhoto, avatarUrl: Constants.DefaultImageURL.Avatar, displayName: displayName, biography: Constants.DefaultUserInfo.Biography)
            
            //Hash password and insert to user database
            do {
                let salt = generateSalt()
                let utf8Password: Array <UInt8> = Array(password.utf8)
                let utf8Salt: Array <UInt8> = Array(salt.utf8)
                let iterationCount = Constants.CryptoData.IterationCount
                let hashedPassword = try PKCS5.PBKDF2(password: utf8Password, salt: utf8Salt, iterations: iterationCount, keyLength: Constants.CryptoData.KeyLength, variant: .sha256).calculate().toString()
                
                UserDB.sharedInstance.insert(username: username, password: hashedPassword, salt: salt, iterationCount: iterationCount)
            } catch {
                print("Could not create encrypted key.")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                alert.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
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

extension RegisterVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let contentText = textField.text, contentText.count > 0 else { return false }
        
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

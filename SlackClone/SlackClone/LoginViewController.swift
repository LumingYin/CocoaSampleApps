//
//  ViewController.swift
//  SlackClone
//
//  Created by Bright on 7/2/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa
import Parse

class LoginViewController: NSViewController {
    
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let username = UserDefaults.standard.string(forKey: "username") {
            if let password = UserDefaults.standard.string(forKey: "password") {
                emailTextField.stringValue = username
                passwordTextField.stringValue = password
            }
        }
    }

    @IBAction func createAccountClicked(_ sender: NSButton) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.moveToCreateAccount()
        }
    }
    
    @IBAction func loginClicked(_ sender: NSButton) {
        PFUser.logInWithUsername(inBackground: emailTextField.stringValue, password: passwordTextField.stringValue) { (user: PFUser?, error: Error?) in
            if error == nil {
                print("You logged in")
                UserDefaults.standard.set(self.emailTextField.stringValue, forKey: "username")
                UserDefaults.standard.set(self.passwordTextField.stringValue, forKey: "password")
                UserDefaults.standard.synchronize()
                if let mainWC = self.view.window?.windowController as? MainWindowController {
                    mainWC.moveToChat()
                }
            } else {
                print("error logging in \(String(describing: error))")
            }
        }
    }
    

}


//
//  MainWindowController.swift
//  SlackClone
//
//  Created by Bright on 7/2/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    var loginVC: LoginViewController?
    var createAccountVC: CreateAccountViewController?
    var splitVC: MainSplitViewController?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        loginVC = contentViewController as? LoginViewController
    }
    
    func moveToCreateAccount() {
        if createAccountVC == nil {
            createAccountVC = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "createAccountVC")) as? CreateAccountViewController
        }
        window?.contentView = createAccountVC?.view
    }
    
    func moveToLogin() {
        window?.contentView = loginVC?.view
    }
    
    func moveToChat() {
        if splitVC == nil {
            splitVC = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "splitVC")) as? MainSplitViewController
        }
        window?.contentView = splitVC?.view
    }
}

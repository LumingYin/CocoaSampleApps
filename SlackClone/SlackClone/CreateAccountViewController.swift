//
//  CreateAccountViewController.swift
//  SlackClone
//
//  Created by Bright on 7/2/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa
import Parse

class CreateAccountViewController: NSViewController {

    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    
    @IBOutlet weak var profilePicImageView: NSImageView!
    var profilePicFile: PFFile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profilePicFile = PFFile(data: self.jpegDataFrom(image: image))
        self.profilePicFile?.saveInBackground()
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.moveToLogin()
        }
    }
    
    @IBAction func chooseImageClicked(_ sender: NSButton) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.canCreateDirectories = true
        openPanel.begin { (result: NSApplication.ModalResponse) in
            if result.rawValue == NSFileHandlingPanelOKButton {
                if let imageURL = openPanel.urls.first {
                    if let image = NSImage(contentsOf: imageURL) {
                        self.profilePicImageView.image = image
                        self.profilePicFile = PFFile(data: self.jpegDataFrom(image: image))
                        self.profilePicFile?.saveInBackground()
                    }
                }
            }
        }
    }
    
    
    func jpegDataFrom(image:NSImage) -> Data {
        let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
        return jpegData
    }
    
    @IBAction func createAccountClicked(_ sender: NSButton) {
        PFUser.logOut()
        let user = PFUser()
        user.email = emailTextField.stringValue
        user.password = passwordTextField.stringValue
        user.username = emailTextField.stringValue
        user["name"] = nameTextField.stringValue
        if profilePicFile != nil {
            user["profilePic"] = profilePicFile
        }
        
        user.signUpInBackground { (success, error) in
            if success {
                print("Made a user")
                if let mainWC = self.view.window?.windowController as? MainWindowController {
                    mainWC.moveToChat()
                }
            } else {
                print("Failed when creating user. \(String(describing: error))")
            }
        }
    }
    
}


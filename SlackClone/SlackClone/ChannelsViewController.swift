//
//  ChannelsViewController.swift
//  SlackClone
//
//  Created by Bright on 7/2/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa
import Parse

class ChannelsViewController: NSViewController {

    @IBOutlet weak var profilePicImageView: NSImageView!
    @IBOutlet weak var nameLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        if let user = PFUser.current() {
            if let name = user["name"] as? String {
                nameLabel.stringValue = name
            }
            if let imageFile = user["profilePic"] as? PFFile {
                imageFile.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if error == nil {
                        if data != nil {
                            let image = NSImage(data: data!)
                            self.profilePicImageView.image = image
                        }
                    } else {
                        print("error downloding image\(error)")
                    }
                })
            }
        }
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        PFUser.logOut()
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.moveToLogin()
        }
    }
}

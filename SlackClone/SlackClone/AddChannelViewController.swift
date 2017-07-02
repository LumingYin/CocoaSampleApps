//
//  AddChannelViewController.swift
//  SlackClone
//
//  Created by Bright on 7/2/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa
import Parse

class AddChannelViewController: NSViewController {
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var descriptionTextField: NSTextField!
    weak var delegate: ChannelsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addChannelClicked(_ sender: NSButton) {
        let channel = PFObject(className: "Channel")
        channel["title"] = titleTextField.stringValue
        channel["descriptionForChannel"] = descriptionTextField.stringValue
        channel.saveInBackground { (success, error) in
            if (success) {
                print("channel saved")
                self.delegate?.getChannels()
                self.delegate?.tableView.reloadData()
                self.view.window?.close()
            } else {
                print("eror creating channel\(String(describing: error))")
            }
        }
    }
}

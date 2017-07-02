//
//  ChatViewController.swift
//  SlackClone
//
//  Created by Bright on 7/2/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa
import Parse

class ChatViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var channelDescription: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var messageTextField: NSTextField!
    var channel: PFObject?
    var chats: [PFObject] = []
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        messageTextField.delegate = self
    }
    
    override func viewWillAppear() {
        clearChat()
    }
    
    func clearChat() {
        timer?.invalidate()
        channel = nil
        chats = []
        tableView.reloadData()
        titleLabel.stringValue = ""
        channelDescription.stringValue = ""
        messageTextField.placeholderString = ""
    }
    
    func updateWithChannel(channel: PFObject) {
        self.channel = channel
        if let title = channel["title"] as? String {
            titleLabel.stringValue = "#\(title)"
            messageTextField.placeholderString = "Message #\(title)"
        }
        if let description = channel["descriptionForChannel"] as? String {
            channelDescription.stringValue = description
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            print("getting chats")
            self.getChats()
        }
    }
    
    func getChats() {
        let query = PFQuery(className: "Chat")
        query.includeKey("user")
        query.whereKey("channel", equalTo: channel!)
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackground { (chats: [PFObject]?, error) in
            if (error == nil) {
                if chats != nil {
                    if chats?.count != self.chats.count {
                        self.chats = chats!
                        self.tableView.reloadData()
                        self.tableView.scrollRowToVisible(self.chats.count - 1)
                    }
                }
//                print("chats: \(String(describing: chats))")
            } else {
//                print("failed to get chats\(String(describing: error))")
            }
        }
    }
    
    @IBAction func sendClicked(_ sender: Any) {
        if messageTextField?.stringValue == nil || messageTextField?.stringValue == "" {
            return
        }
        let chat = PFObject(className: "Chat")
        chat["message"] = messageTextField?.stringValue
        chat["user"] = PFUser.current()
        chat["channel"] = channel
        chat.saveInBackground { (success: Bool, error: Error?) in
            if success {
                print("message sent")
                self.messageTextField.stringValue = ""
                self.getChats()
            } else {
                print("could not send message\(String(describing: error))")
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "chatCell"), owner:nil) as? ChatCell {
            let chat = chats[row]
            if let message = chat["message"] as? String {
                cell.messageLabel?.stringValue = message
                
                if let user = chat["user"] as? PFUser {
                    if let name = user["name"] as? String {
                        cell.nameLabel?.stringValue = name
                    }
                    if let imageFile = user["profilePic"] as? PFFile {
                        imageFile.getDataInBackground(block: { (data: Data?, error: Error?) in
                            if error == nil {
                                if data != nil {
                                    let image = NSImage(data: data!)
                                    cell.profilePicImageView?.image = image
                                }
                            } else {
                                print("error downloding image\(error)")
                            }
                        })
                    }
                }
                
                if let date = chat.createdAt {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm, MMM d"
                    cell.timeLabel.stringValue = formatter.string(from: date)
                }
                
            }
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline(_:)) {
            sendClicked(self)
        }
        return false
    }
}

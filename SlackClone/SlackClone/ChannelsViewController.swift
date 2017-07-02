//
//  ChannelsViewController.swift
//  SlackClone
//
//  Created by Bright on 7/2/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa
import Parse

class ChannelsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var profilePicImageView: NSImageView!
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    var channels: [PFObject] = [] //of channels, we can subclass PFObject arrays to enforce what it is
    var addChannelWC: NSWindowController?
    var chatVC: ChatViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getChannels()
        tableView.dataSource = self
        tableView.delegate = self
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
    
    @IBAction func addClicked(_ sender: NSButton) {
        addChannelWC = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "addChannelWC")) as? NSWindowController
        if let addChannelVC = addChannelWC?.contentViewController as? AddChannelViewController {
            addChannelVC.delegate = self
        }
        addChannelWC?.showWindow(nil)
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        chatVC?.clearChat()
        PFUser.logOut()
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.moveToLogin()
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let channel = channels[row]
        
        if let title = channel["title"] as? String {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "channelCell"), owner: nil) as? NSTableCellView {
                
                cell.textField?.stringValue = "#\(title)"
                return cell
            }
        }
        return nil
    }
    
    func getChannels() {
        let query = PFQuery(className: "Channel")
        query.order(byAscending: "title")
        query.findObjectsInBackground { (channels: [PFObject]?, error: Error?) in
            if channels != nil {
                print("channels are: \(String(describing: channels))")
                self.channels = channels!
                self.tableView.reloadData()
            }
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow < 0 {
            return
        } else {
            let channel = channels[tableView.selectedRow]
            chatVC?.updateWithChannel(channel: channel)
        }
        
        print("selected channel changed \(notification)")
    }
}

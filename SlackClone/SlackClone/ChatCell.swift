//
//  ChatCell.swift
//  SlackClone
//
//  Created by Bright on 7/2/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa

class ChatCell: NSTableCellView {

    @IBOutlet weak var messageLabel: NSTextField!
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var profilePicImageView: NSImageView!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
}

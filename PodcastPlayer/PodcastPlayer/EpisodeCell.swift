//
//  EpisodeCell.swift
//  PodcastPlayer
//
//  Created by Bright on 7/1/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa
import WebKit

class EpisodeCell: NSTableCellView {

    @IBOutlet weak var descriptionWebView: WKWebView!
    @IBOutlet weak var pubDateLabel: NSTextField!
    @IBOutlet weak var titleLabel: NSTextField!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}

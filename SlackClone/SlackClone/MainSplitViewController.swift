//
//  MainSplitViewController.swift
//  SlackClone
//
//  Created by Bright on 7/2/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        if let channelsVC = splitViewItems[0].viewController as? ChannelsViewController {
            if let chatVC = splitViewItems[1].viewController as? ChatViewController {
                channelsVC.chatVC = chatVC
            }
        }
        
        if var frame = view.window?.frame {
            frame.size = CGSize(width: 1000, height: 600)
            view.window?.setFrame(frame, display: true, animate: true)
        }
    }
    
}

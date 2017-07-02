//
//  AppDelegate.swift
//  SlackClone
//
//  Created by Bright on 7/2/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa
import Parse

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let configuration = ParseClientConfiguration { (configThing: ParseMutableClientConfiguration) in
            configThing.applicationId = "workcommunicateapp"
            configThing.server = "https://workcommunicate.herokuapp.com/parse"
        }
        Parse.initialize(with: configuration)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}


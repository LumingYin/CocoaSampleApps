//
//  AppDelegate.swift
//  MovieReviewmacOS
//
//  Created by Bright on 7/2/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func application(_ application: NSApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]) -> Void) -> Bool {
        if let userDic = userActivity.userInfo {
            print(userDic)
        }
        
        if let window = NSApplication.shared.windows.first {
            window.contentViewController?.restoreUserActivityState(userActivity)
        }
        
        return true
    }

}


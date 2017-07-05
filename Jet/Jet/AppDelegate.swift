//
//  AppDelegate.swift
//  Jet
//
//  Created by Bright on 7/2/17.
//  Copyright © 2017 Bright. All rights reserved.
//


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    @IBAction func resetScoreClicked(_ sender: Any) {
        print("reset high score triggered")
        UserDefaults.standard.set(0, forKey: "highScore")
        UserDefaults.standard.synchronize()
        if let vc = NSApplication.shared.windows.first?.contentViewController as? ViewController {
            if let scene = vc.skView.scene as? GameScene {
                scene.updateHighScore()
            }
        }
        
    }
    
}

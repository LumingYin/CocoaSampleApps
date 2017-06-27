//
//  AppDelegate.swift
//  LinkIt
//
//  Created by Bright on 6/26/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var item : NSStatusItem? = nil

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // Action on menu itself
        // Will be disabled
        item?.image = NSImage(named: NSImage.Name(rawValue: "link"))
//        item?.title = "Link It!"
        item?.action = #selector(AppDelegate.linkIt)
        
        let menu = NSMenu()
        // keyEquivalent only works when menu is active, not very useful
        // capitalized letter is Shift+Command+Letter
        // non-capitalized letter is Command+Letter
        menu.addItem(NSMenuItem(title: "Link It!", action: #selector(linkIt), keyEquivalent: "L"))
        menu.addItem(NSMenuItem(title: "Print Pasteboard", action: #selector(printPasteboard), keyEquivalent: "q"))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        
        item?.menu = menu
    }
    
    

    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    @objc func linkIt() {
        if let items = NSPasteboard.general.pasteboardItems {
            for item in items {
                for type in item.types {
                    if type.rawValue == "public.utf8-plain-text" {
                        if let url = item.string(forType: type) {
                            
                            var actualURL = ""
                            
                            if url.hasPrefix("http://") || url.hasPrefix("https://") {
                                actualURL = url
                            } else {
                                actualURL = "http://" + url
                            }
                            
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString("<a href=\"\(actualURL)\">\(url)</a>", forType: NSPasteboard.PasteboardType.init(rawValue: "public.html"))
                            
                            NSPasteboard.general.setString(url, forType: NSPasteboard.PasteboardType.init(rawValue: "public.utf8-plain-text"))
                        }
                    }
                }
            }
        }
    }
    
//    PasteboardType(_rawValue: public.utf8-plain-text) is the most reliable way to grab content out of clipboard
//    Luming.ga
    
    @objc func printPasteboard() {
        if let items = NSPasteboard.general.pasteboardItems {
            for item in items {
                for type in item.types {
                    print("Type: \(type)")
                    print("String: \(String(describing: item.string(forType: type)))")
                }
            }
        }
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
    

}


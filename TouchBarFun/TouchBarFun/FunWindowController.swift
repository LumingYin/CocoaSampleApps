//
//  FunWindowController.swift
//  TouchBarFun
//
//  Created by Bright on 7/1/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa

@available(OSX 10.12.2, *)
class FunWindowController: NSWindowController {
    @IBOutlet weak var colorPicker: NSColorPickerTouchBarItem!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        colorPicker.isEnabled = true
        colorPicker.target = self
        colorPicker.action = #selector(colorPicked)
    }

    @IBAction func buttonTapped(_ sender: NSButton) {
        print("Hello world!")
    }
    
    @objc func colorPicked() {
        print(colorPicker.color)
        self.contentViewController?.view.layer?.backgroundColor = colorPicker.color.cgColor
    }
}

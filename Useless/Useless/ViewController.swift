//
//  ViewController.swift
//  Useless
//
//  Created by Bright on 6/30/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var buttonA: NSButton!
    @IBOutlet weak var buttonB: NSButton!
    
    
    @IBOutlet weak var aClicked: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func aClicked(_ sender: Any) {
        buttonA.isEnabled = false
        buttonB.isEnabled = true
    }
    
    @IBAction func bClicked(_ sender: Any) {
        buttonA.isEnabled = true
        buttonB.isEnabled = false
    }
}


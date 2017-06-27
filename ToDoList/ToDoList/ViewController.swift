//
//  ViewController.swift
//  ToDoList
//
//  Created by Bright on 6/26/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var importantCheckbox: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!
    
    var toDoItems : [ToDoItem] = []
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getToDoItems()
    }
    
    // MARK: -
    func getToDoItems() {
        // get the todoItems from CoreData
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            do {
                toDoItems = try context.fetch(ToDoItem.fetchRequest())
                // set them to the class property
                print(toDoItems.count)
            } catch {}
        }
        tableView.reloadData()
        // Update the table
    }
    
    @IBAction func addClicked(_ sender: NSButton) {
        if textField.stringValue != "" {
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let toDoItem = ToDoItem(context: context)
                toDoItem.name = textField.stringValue
                if importantCheckbox.state == .off {
                    toDoItem.important = false
                } else {
                    toDoItem.important = true
                }
                
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                
                textField.stringValue = ""
                importantCheckbox.state = .off
                
                getToDoItems()
            }
        }
    }
    
    @IBAction func deleteClicked(_ sender: NSButton) {
        
        let toDoItem = toDoItems[tableView.selectedRow]
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            context.delete(toDoItem)
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            getToDoItems()
        }
        deleteButton.isHidden = true
    }
    
    // MARK: - TableView Stuff
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "ImportantColumn") {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ImportantCell"), owner: self) as? NSTableCellView {
                let toDoItem = toDoItems[row]
                if toDoItem.important {
                    cell.textField?.stringValue = "❗️"
                } else {
                    cell.textField?.stringValue = ""
                }
                return cell
            }
        } else {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "todoItems"), owner: self) as? NSTableCellView {
                let toDoItem = toDoItems[row]
                cell.textField?.stringValue = toDoItem.name!
                return cell
            }
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteButton.isHidden = false
    }
    
}


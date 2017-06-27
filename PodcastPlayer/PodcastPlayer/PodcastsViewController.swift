//
//  PodcastsViewController.swift
//  PodcastPlayer
//
//  Created by Bright on 6/26/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa

class PodcastsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var podcastURLTextField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    var podcasts : [Podcast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        podcastURLTextField.stringValue = "http://www.espn.com/espnradio/podcast/feeds/itunes/podCast?id=2406595"
        getPodcasts()
    }
    
    func getPodcasts() {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchy.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            do {
                podcasts = try context.fetch(fetchy)
                print(podcasts)
            } catch let error as NSError {
                print("core data fetch failed\(error)")
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func addPodcastClicked(_ sender: NSButton) {
        if self.podcastExists(rssURL: self.podcastURLTextField.stringValue) {
            return
        }
        if let url = URL(string: podcastURLTextField.stringValue) {
            URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                    print("\(String(describing: error))")
                } else {
                    if (data != nil) {
                        let parser = Parser()
                        let info = parser.getPodcastMetaData(data: data!)

                        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                            DispatchQueue.main.async {
                                let podcast = Podcast(context: context)
                                podcast.imageURL = info.imageURL
                                podcast.title = info.title
                                podcast.rssURL = self.podcastURLTextField.stringValue
                                
                                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                                
                                self.getPodcasts()
                            }
                        }
                        print(info)
                    }
                }
            }.resume()
        }
    }
    
    func podcastExists(rssURL: String) -> Bool {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchy.predicate = NSPredicate(format: "rssURL == %@", rssURL)
            do {
                let matchingPodcasts = try context.fetch(fetchy)
                if matchingPodcasts.count >= 1 {
                    return true
                }
                return false
            } catch let error as NSError {
                print("core data fetch failed\(error)")
            }
        }
        return false
    }
    
//    MARK: -
//    MARK: Table View Delegate
    func numberOfRows(in tableView: NSTableView) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "podcastcell"), owner: self) as? NSTableCellView
        let podcast = podcasts[row]
        
        if podcast.title != nil {
            cell?.textField?.stringValue = podcast.title!
        } else {
            cell?.textField?.stringValue = "Unknown Title"
        }
        return cell
    }
    
}

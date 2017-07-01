//
//  EpisodeViewController.swift
//  PodcastPlayer
//
//  Created by Bright on 7/1/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa
import AVFoundation
import WebKit
class EpisodeViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var pausePlayButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!
    
    var podcast : Podcast? = nil
    var podcastsVC: PodcastsViewController? = nil
    var episodes: [Episode] = []
    var player : AVPlayer? = nil
    
    func updateView() {
        if podcast?.title != nil {
            titleLabel.stringValue = podcast!.title!
        } else {
            titleLabel.stringValue = ""
        }
        
        if podcast?.imageURL != nil {
            let image = NSImage(byReferencing: URL(string: podcast!.imageURL!)!)
            imageView.image = image
        } else {
            imageView.image = nil
        }
        
        if podcast != nil {
            tableView.isHidden = false
            deleteButton.isHidden = false
            pausePlayButton.isHidden = false
        } else {
            tableView.isHidden = true
            deleteButton.isHidden = true
            pausePlayButton.isHidden = true
        }
        getEpisodes()
    }
    
    func getEpisodes() {
        if podcast?.rssURL != nil {
            if let url = URL(string: podcast!.rssURL!) {
            URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                    print("\(String(describing: error))")
                } else {
                    if (data != nil) {
                        let parser = Parser()
                        self.episodes = parser.getEpisodes(data: data!)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
//                        print(episodes)
                    }
                }
                }.resume()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    @IBAction func pausePlayClicked(_ sender: NSButton) {
        if pausePlayButton.title == "Pause" {
            player?.pause()
            pausePlayButton.title = "Play"
        } else {
            player?.play()
            pausePlayButton.title = "Pause"
        }
     }
    
    @IBAction func deleteClicked(_ sender: Any) {
        if podcast != nil {
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                context.delete(podcast!)
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                podcastsVC?.getPodcasts()
                
                podcast = nil
                updateView()
            }
        }
    }
    
    // MARK: -
    func numberOfRows(in tableView: NSTableView) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let episode = episodes[row]
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "episodeCell"), owner: self) as? EpisodeCell
        cell?.titleLabel.stringValue = episode.title
//        cell?.pubDateLabel.stringValue = episode.pubDate.description
        cell?.descriptionWebView.loadHTMLString(episode.htmlDescription, baseURL: nil)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        cell?.pubDateLabel.stringValue = dateFormatter.string(from: episode.pubDate)
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow >= 0 {
            let episode = episodes[tableView.selectedRow]
            if let url = URL(string: episode.audioURL) {
                player?.pause()
                player = nil
                player = AVPlayer(url: url)
                player?.play()
                pausePlayButton.isHidden = false
                pausePlayButton.title = "Pause"
            }
        }
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
}

//
//  SplitController.swift
//  PodcastPlayer
//
//  Created by Bright on 7/1/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa

class SplitController: NSSplitViewController {

    @IBOutlet weak var podcastsItem: NSSplitViewItem!
    @IBOutlet weak var episodesItem: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let podcastsVC = podcastsItem.viewController as? PodcastsViewController {
            if let episodesVC = episodesItem.viewController as? EpisodeViewController {
                podcastsVC.episodesVC = episodesVC
                episodesVC.podcastsVC = podcastsVC
            }
        }
    }
    
    
    
}

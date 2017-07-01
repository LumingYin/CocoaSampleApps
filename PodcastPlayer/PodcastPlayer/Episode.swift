//
//  Episode.swift
//  PodcastPlayer
//
//  Created by Bright on 7/1/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Foundation
import Cocoa

class Episode {
    var title = ""
    var pubDate = Date()
    var htmlDescription = ""
    var audioURL = ""
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter
    }()
}

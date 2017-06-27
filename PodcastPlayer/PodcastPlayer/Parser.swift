//
//  Parser.swift
//  PodcastPlayer
//
//  Created by Bright on 6/26/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Foundation

class Parser {
    
    public func getPodcastMetaData(data: Data) -> (title: String?, imageURL: String?) {
        print("wooh \(data)")
        
        let xml = SWXMLHash.parse(data)
        
        let title = xml["rss"]["channel"]["title"].element?.text
        let imageURL = xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text
        return(title, imageURL)
    }
    
}

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
    
    func getEpisodes(data: Data) -> [Episode] {
        let xml = SWXMLHash.parse(data)
        print(xml)
        let items = xml["rss"]["channel"]["item"]
        print("item begins\(items)item ends")
        
        var episodes : [Episode] = []
        
        for item in items.all {
            let episode = Episode()
            print(item["title"])
            
            if let title = item["title"].element?.text {
                episode.title = title
            }
            if let description = item["description"].element?.text {
                episode.htmlDescription = description
            }
//            if let link = item["link"].element?.text {
            if let link = item["enclosure"].element?.attribute(by: "url")?.text {
                episode.audioURL = link
            }
            if let pubDate = item["pubDate"].element?.text {
                if let date = Episode.formatter.date(from: pubDate) {
                    episode.pubDate = date
                }
            }
            
            episodes.append(episode)
            print(episode.pubDate)
        }
        return episodes
    }
    
    
}

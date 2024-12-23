//
//  NewsItem.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 21.12.2024.
//

import Foundation

struct NewsItem: Parserable {
    let guid: String
    let title: String
    let link: String
    let pubDateString: String?
    let pubDate: Date?
    var source: String?
    let description: String?
    let author: String?
    let enclosure: String?
    var isRead: Bool
    
    static var mainElement: String { "item" }
    static var enclosureElement: String? { "enclosure" }
    static var enclosureAttribute: String? { "url" }
    
    static func from(dictionary: [String: String]) -> NewsItem? {
        guard
            let guid = dictionary["guid"],
            let title = dictionary["title"],
            let link = dictionary["link"]
        else {
            return nil
        }
        
        let pubDateString = dictionary["pubDate"]
        let pubDate = NewsItem.date(from: pubDateString)
        
        return NewsItem(
            guid: guid,
            title: title,
            link: link,
            pubDateString: pubDateString,
            pubDate: pubDate,
            source: nil,
            description: dictionary["description"],
            author: dictionary["author"],
            enclosure: dictionary["enclosure"],
            isRead: false
        )
    }
    
    static func date(from pubDateString: String?) -> Date? {
        guard let pubDateString else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.date(from: pubDateString)
    }
}


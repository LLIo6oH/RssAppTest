//
//  RealmNewsItem.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 23.12.2024.
//

import RealmSwift

class RealmNewsItem: Object {
    @objc dynamic var guid: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionText: String? = nil
    @objc dynamic var source: String? = nil
    @objc dynamic var pubDate: String? = nil
    @objc dynamic var link: String = ""
    @objc dynamic var author: String? = nil
    @objc dynamic var enclosure: String? = nil
    @objc dynamic var isRead: Bool = false
    
    override static func primaryKey() -> String? {
        return "guid"
    }
}

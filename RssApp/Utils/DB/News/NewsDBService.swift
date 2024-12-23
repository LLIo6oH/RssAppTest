//
//  NewsDBService.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 23.12.2024.
//

import RealmSwift

protocol NewsDBServiceProtocol {
    func saveNews(items: [NewsItem], completion: @escaping (Error?) -> Void)
    func getAllNews(completion: @escaping ([NewsItem]) -> Void)
    func updateNewsReadStatus(guid: String, isRead: Bool, completion: @escaping (Error?) -> Void)
    func clearCache(completion: @escaping (Error?) -> Void)
}

final class NewsDBService: NewsDBServiceProtocol {
    var dbService: DBServiceProtocol
    
    init(
        dbService: DBServiceProtocol
    ) {
        self.dbService = dbService
    }
    
    func saveNews(items: [NewsItem], completion: @escaping (Error?) -> Void) {
        let realmItems = items.map { item in
            let realmItem = RealmNewsItem()
            realmItem.guid = item.guid
            realmItem.title = item.title
            realmItem.descriptionText = item.description
            realmItem.source = item.source
            realmItem.pubDate = item.pubDateString
            realmItem.link = item.link
            realmItem.author = item.author
            realmItem.enclosure = item.enclosure
            realmItem.isRead = item.isRead
            return realmItem
        }
        
        dbService.save(objects: realmItems, completion: completion)
    }
    
    func getAllNews(completion: @escaping ([NewsItem]) -> Void) {
        dbService.fetchAll(ofType: RealmNewsItem.self) { (realmItems: [RealmNewsItem]) in
            let newsItems = realmItems.map { item in
                let pubDate = NewsItem.date(from: item.pubDate)
                
                return NewsItem(
                    guid: item.guid,
                    title: item.title,
                    link: item.link,
                    pubDateString: item.pubDate,
                    pubDate: pubDate,
                    source: item.source,
                    description: item.descriptionText,
                    author: item.author,
                    enclosure: item.enclosure,
                    isRead: item.isRead
                )
            }
            completion(newsItems)
        }
    }
    
    func updateNewsReadStatus(guid: String, isRead: Bool, completion: @escaping (Error?) -> Void) {
        dbService.updateObject(ofType: RealmNewsItem.self, withPrimaryKey: guid) { (realmItem: RealmNewsItem) in
            realmItem.isRead = isRead
        } completion: { error in
            completion(error)
        }
    }
    
    func clearCache(completion: @escaping (Error?) -> Void) {
        dbService.clearCache(ofType: RealmNewsItem.self, completion: completion)
    }
}

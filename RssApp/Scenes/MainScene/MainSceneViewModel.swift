//
//  Untitled.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 22.12.2024.
//

import Foundation

final class MainSceneViewModel {
    // MARK: - PROPERTIES
    private let newsAPIService: NewsAPIServiceProtocol
    private let newsDBService: NewsDBServiceProtocol
    private let imageCacheService: ImageCacheServiceProtocol
    
    // MARK: - INITIALIZATION
    init(
        newsAPIService: NewsAPIServiceProtocol,
        newsDBService: NewsDBServiceProtocol,
        imageCacheService: ImageCacheServiceProtocol
    ) {
        self.newsAPIService = newsAPIService
        self.newsDBService = newsDBService
        self.imageCacheService = imageCacheService
    }
    
    // MARK: - DATA FETCHING
    func fetchNews(completion: @escaping ([NewsItem]) -> Void) {
        newsDBService.getAllNews { [weak self] cachedNewsItems in
            guard let self = self else { return }
            
            completion(cachedNewsItems)
            
            self.newsAPIService.fetchNews(sources: NewsSource.allCases) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let news):
                    let updatedReadStatusNews = news.map { newItem -> NewsItem in
                        if let cachedItem = cachedNewsItems.first(where: { $0.guid == newItem.guid }) {
                            var updatedItem = newItem
                            updatedItem.isRead = cachedItem.isRead
                            return updatedItem
                        } else {
                            return newItem
                        }
                    }
                    
                    self.newsDBService.saveNews(items: updatedReadStatusNews) { error in
                        if let error = error {
                            print("Error saving news to DB: \(error)")
                            return
                        }
                        self.newsDBService.getAllNews { updatedNewsItems in
                            let sortedItems = updatedNewsItems.sorted {
                                $0.pubDate ?? Date.distantPast > $1.pubDate ?? Date.distantPast
                            }
                            completion(sortedItems)
                        }
                    }
                case .failure(let error):
                    print("Error fetching news from API: \(error)")
                    // TODO: Show error somehow
                }
            }
        }
    }
    
    func loadImage(for url: String, completion: @escaping (Data?) -> Void) {
        imageCacheService.loadImage(from: url) { imageData in
            DispatchQueue.main.async {
                completion(imageData)
            }
        }
    }
    
    // MARK: - DB FUNCTIONALITY
    func updateNewsStatus(newsItem: NewsItem, completion: @escaping (NewsItem?) -> Void) {
        newsDBService.updateNewsReadStatus(guid: newsItem.guid, isRead: true) { error in
            if let error = error {
                print("Failed to update news read status: \(error)")
                completion(nil)
            } else {
                self.newsDBService.getAllNews { updatedNewsItems in
                    let updatedItem = updatedNewsItems.first { $0.guid == newsItem.guid }
                    completion(updatedItem)
                }
            }
        }
    }
}

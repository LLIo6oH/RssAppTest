//
//  NewsAPI.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 22.12.2024.
//

import Foundation

protocol NewsAPIServiceProtocol {
    func fetchNews(sources: [NewsSource], completion: @escaping (Result<[NewsItem], Error>) -> Void)
}

final class NewsAPIService: NewsAPIServiceProtocol {
    let networkService: NetworkServiceProtocol
    let parserService: ParserService<NewsItem>
    let realmNewsService: NewsDBServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol,
        parserService: ParserService<NewsItem>,
        realmNewsService: NewsDBServiceProtocol
    ) {
        self.parserService = parserService
        self.networkService = networkService
        self.realmNewsService = realmNewsService
    }
    
    func fetchNews(sources: [NewsSource], completion: @escaping (Result<[NewsItem], Error>) -> Void) {
        let newsDispatchGroup = DispatchGroup()
        var allNewsItems: [NewsItem] = []
        var errors: [Error] = []
        
        for source in sources {
            newsDispatchGroup.enter()
            
            let request = NewsRequest(url: source.rawValue)
            networkService.performRequest(request) { [weak self] response in
                guard let self else { return }
                
                switch response {
                case .success(let data):
                    let parsedItems = self.parserService.parse(data: data)
                    let updatedItems = parsedItems.map { item in
                        var updatedItem = item
                        updatedItem.source = source.rawValue
                        return updatedItem
                    }
                    
                    allNewsItems.append(contentsOf: updatedItems)
                case .failure(let error):
                    errors.append(error)
                }
                newsDispatchGroup.leave()
            }
        }
        
        newsDispatchGroup.notify(queue: .main) {
            if errors.isEmpty {
                completion(.success(allNewsItems))
            } else {
                completion(.failure(errors.first!)) // TODO: Add proper error handling
            }
        }
    }
}

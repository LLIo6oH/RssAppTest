//
//  ServiceAssembly.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 22.12.2024.
//

import Swinject

class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkServiceProtocol.self) { _ in NetworkService() }
        container.register(DBServiceProtocol.self) { _ in DBService() }
        container.register(ParserService<NewsItem>.self) { _ in ParserService<NewsItem>() }
        container.register(ImageCacheServiceProtocol.self) { _ in ImageCacheService() }
        
        container.register(NewsAPIServiceProtocol.self) { resolver in
            let networkService = resolver.resolve(NetworkServiceProtocol.self)!
            let parserService = resolver.resolve(ParserService<NewsItem>.self)!
            let realmNewsService = resolver.resolve(NewsDBServiceProtocol.self)!
            return NewsAPIService(networkService: networkService, parserService: parserService, realmNewsService: realmNewsService)
        }
        
        container.register(NewsDBServiceProtocol.self) { resolver in
            let dbService = resolver.resolve(DBServiceProtocol.self)!
            return NewsDBService(dbService: dbService)
        }
    }
}

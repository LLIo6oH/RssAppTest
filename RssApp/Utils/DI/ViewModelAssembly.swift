//
//  ViewModelAssembly.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 22.12.2024.
//

import Swinject

class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MainSceneViewModel.self) { resolver in
            let newsAPIService = resolver.resolve(NewsAPIServiceProtocol.self)!
            let newsDBService = resolver.resolve(NewsDBServiceProtocol.self)!
            let imageCacheService = resolver.resolve(ImageCacheServiceProtocol.self)!
            return MainSceneViewModel(newsAPIService: newsAPIService, newsDBService: newsDBService, imageCacheService: imageCacheService)
        }
        
        container.register(SettingsViewModel.self) { resolver in
            let dbService = resolver.resolve(DBServiceProtocol.self)!
            let imageCacheService = resolver.resolve(ImageCacheServiceProtocol.self)!
            return SettingsViewModel(imageCacheService: imageCacheService, dbService: dbService)
        }
    }
}

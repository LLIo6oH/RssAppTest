//
//  SettingsViewModel.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 23.12.2024.
//

import Foundation

final class SettingsViewModel {
    // MARK: - PROPERTIES
    private let imageCacheService: ImageCacheServiceProtocol
    private let dbService: DBServiceProtocol
    private var updateInterval: TimeInterval = 300
    
    // MARK: - INITIALIZATION
    init(
        imageCacheService: ImageCacheServiceProtocol,
        dbService: DBServiceProtocol
    ) {
        self.imageCacheService = imageCacheService
        self.dbService = dbService
    }
    
    // MARK: - USER INTERACTION
    func clearImageCache() {
        imageCacheService.clearCashe()
        dbService.clearCache(ofType: RealmNewsItem.self, completion: {_ in }) // TODO: Comletion as optional
        NotificationCenter.default.post(name: .cacheIsCleared, object: nil)
    }
    
    func setUpdateInterval(_ interval: TimeInterval) {
        updateInterval = interval
        NotificationCenter.default.post(name: .updateTimerIntervalChanged, object: interval)
    }
}

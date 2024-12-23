//
//  ImageCache.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 23.12.2024.
//

import UIKit

protocol ImageCacheServiceProtocol {
    func loadImage(from url: String, completion: @escaping (Data?) -> Void)
    func clearCashe()
}

final class ImageCacheService: ImageCacheServiceProtocol {
    private let cache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: String, completion: @escaping (Data?) -> Void) {
        if let cachedImage = cache.object(forKey: url as NSString) {
            completion(cachedImage.pngData())
            return
        }
        
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            self.cache.setObject(image, forKey: url as NSString)
            DispatchQueue.main.async {
                completion(image.pngData())
            }
        }
        task.resume()
    }
    
    func clearCashe() {
        cache.removeAllObjects()
    }
}

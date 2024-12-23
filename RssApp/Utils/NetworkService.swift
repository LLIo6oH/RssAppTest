//
//  NetworkManager.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 21.12.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func performRequest(_ request: NetworkRequest, completion: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    func performRequest(_ request: NetworkRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: request.url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        if let parameters = request.parameters {
            do {
                if request.method == .post || request.method == .put {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                }
            } catch {
                completion(.failure(NetworkError.invalidParameters))
                return
            }
        }
        
        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if (request.method == .post || request.method == .put), urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.unknown))
            }
        }
        
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case unknown
    case invalidParameters
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

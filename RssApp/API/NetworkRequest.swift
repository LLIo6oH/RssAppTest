//
//  NetworkRequest.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 21.12.2024.
//

protocol NetworkRequest {
    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension NetworkRequest {
    var method: HTTPMethod { .get }
    var parameters: [String: Any]? { nil }
    var headers: [String: String]? { nil }
}

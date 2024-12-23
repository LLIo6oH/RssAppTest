//
//  ParserableProtocol.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 23.12.2024.
//

protocol Parserable {
    static var mainElement: String { get }
    static var enclosureElement: String? { get }
    static var enclosureAttribute: String? { get }
    static func from(dictionary: [String: String]) -> Self?
}

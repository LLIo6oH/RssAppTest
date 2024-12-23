//
//  ParserService.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 23.12.2024.
//

import Foundation

protocol ParserServiceProtocol {
    associatedtype Model: Parserable
    func parse(data: Data) -> [Model]
}

final class ParserService<T: Parserable>: NSObject, XMLParserDelegate, ParserServiceProtocol {
    typealias Model = T
    
    private var currentElement: String = ""
    private var currentData: [String: String] = [:]
    private var items: [T] = []
    private var currentText: String = ""
    
    func parse(data: Data) -> [T] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return items
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        if elementName == T.mainElement {
            currentData = [:]
        }
        
        if elementName == T.enclosureElement, let attributeKey = T.enclosureAttribute, let attribute = attributeDict[attributeKey] {
            currentData[elementName] = attribute
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentText += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == T.mainElement {
            if let item = T.from(dictionary: currentData) {
                items.append(item)
            }
        } else if elementName != T.enclosureElement{
            currentData[elementName] = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        currentText = ""
    }
}

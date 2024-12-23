//
//  Sources.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 21.12.2024.
//

enum NewsSource: String, CaseIterable {
    case vedomosti = "https://www.vedomosti.ru/rss/news.xml"
    case rbc = "http://static.feed.rbc.ru/rbc/internal/rss.rbc.ru/rbc.ru/news.rss"
    
    static var allSources: [NewsSource] {
        return Array(self.allCases)
    }
    
    var sourceTitle: String {
        switch self {
        case .vedomosti: return "Ведомости"
        case .rbc: return "РБК"
        }
    }
}

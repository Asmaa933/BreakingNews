//
//  CachingManager.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 25/12/2021.
//

import Foundation

class CachingManager {
    
    static let shared = CachingManager()
    
    private let itemArchiveURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectory.first!
        return documentDirectory.appendingPathComponent("articles.plist")
    }()
    
    private init() {}
    
    @discardableResult
    func saveArticles(_ articles: [Article]) -> Bool {
        var isSaved = false
        debugPrint("Saving articles to: \(itemArchiveURL)")
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(articles)
            try data.write(to: itemArchiveURL, options: [.atomic])
            isSaved = true
            debugPrint("Saved all of the articles")
        } catch (let encodingError) {
            debugPrint("Error encoding articles: \(encodingError)")
        }
        return isSaved
    }
    
    
    func loadArticles() -> [Article] {
        var articles = [Article]()
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let unarchiver = PropertyListDecoder()
            articles = try unarchiver.decode([Article].self, from: data)
        } catch (let decodingError) {
            debugPrint("Error reading in saved articles: \(decodingError)")
        }
        return articles
    }
}

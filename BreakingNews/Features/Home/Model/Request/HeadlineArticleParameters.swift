//
//  HeadlineArticleParameters.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import Foundation

struct HeadlineArticleParameters: Codable {
    
    let apiKey: String = NetworkConstants.apiKey
    let country: String
    let category: String
    let page: Int
    let query: String?
    let pageSize: Int?
    
    enum CodingKeys: String, CodingKey {
        case apiKey, country, category, page, pageSize
        case query = "q"
    }
    
    internal init(country: String, category: String, page: Int, query: String? = nil, pageSize: Int? = 50) {
        self.country = country
        self.category = category
        self.query = query
        self.pageSize = pageSize
        self.page = page
    }
}

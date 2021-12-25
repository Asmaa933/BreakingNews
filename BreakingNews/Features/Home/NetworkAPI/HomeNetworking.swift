//
//  HomeNetworking.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import Foundation
import Alamofire

enum HomeNetworking {
    case fetchArticles(HeadlineArticleParameters)
}

extension HomeNetworking: Requestable {
    var baseURL: String {
        return NetworkConstants.baseURL
    }
    
    var path: String {
        switch self {
        case .fetchArticles:
            return NetworkConstants.topHeadlines
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchArticles:
            return .get
        }
    }
    
    var parameters: [String : Any] {
        switch self {
            
        case .fetchArticles(let params):
            return params.toJSON()
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchArticles(_):
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .fetchArticles:
            return URLEncoding.default
        }
    }
}

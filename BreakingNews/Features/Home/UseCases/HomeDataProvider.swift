//
//  HomeDataProvider.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import Foundation

typealias ArticleResult = Result<ArticleResponse, Error>
typealias ArticleBlock = (ArticleResult) -> Void

protocol HomeDataProviderUseCase {
    func loadData(requestParameters: HeadlineArticleParameters, completion: ArticleBlock?)
}

class HomeDataProvider: HomeDataProviderUseCase {
    
    var apiHandler: ApiHandlerProtocol
    
    init(apiHandler: ApiHandlerProtocol = ApiHandler.shared) {
        self.apiHandler = apiHandler
    }
    
    func loadData(requestParameters: HeadlineArticleParameters, completion: ArticleBlock?) {
        let request = HomeNetworking.fetchArticles(requestParameters)
        apiHandler.fetchData(request: request, mappingClass: ArticleResponse.self) {[weak self] response in
            guard let self = self else { return }
            self.handleResponse(result: response, completion: completion)
        }
    }
    
    private func handleResponse(result: ArticleResult, completion: ArticleBlock?) {
        switch result {
        case .success(let value):
            completion?(.success(value))
        case .failure(let error):
            debugPrint(error.localizedDescription)
            completion?(.failure(error))
        }
    }
}

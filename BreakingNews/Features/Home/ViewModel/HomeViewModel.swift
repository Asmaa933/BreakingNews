//
//  HomeViewModel.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import Foundation

enum HomeState {
    case searching(text: String)
    case notSearching
}

protocol HomeViewModelProtocol {
    var statePresenter: StatePresentable? { get set }
    func fetchArticles()
    func getArticlesCount() -> Int
    func getArticle(at index: Int) -> Article
    func loadMoreArticles()
    func searchForArticle(by text: String)
}

class HomeViewModel: HomeViewModelProtocol {
    
    private let userFavorite: UserFavorite
    private let dataSource: HomeDataProviderUseCase
    private var articles = [Article]()
    private var pageNumber: Int = 1
    private var hasMoreItems: Bool = true
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var currentState: HomeState = .notSearching

    
    var statePresenter: StatePresentable?
    
    
    init(userFavorite: UserFavorite, dataSource: HomeDataProviderUseCase) {
        self.userFavorite = userFavorite
        self.dataSource = dataSource
    }
    
    func fetchArticles() {
        pageNumber = 1
        loadData(isLoadMore: false)
    }
    
    func loadMoreArticles() {
        switch currentState {
        case .searching(text: let text):
            loadData(searchText: text, isLoadMore: true)
        case .notSearching:
            loadData(isLoadMore: true)
        }
    }
    
    func getArticlesCount() -> Int {
        let count = articles.count
        if count == 0 {
            statePresenter?.render(state: .empty)
        }
        return count
    }
    
    func getArticle(at index: Int) -> Article { articles[index] }
    
    func searchForArticle(by text: String) {
        pageNumber = 1
        if text.isEmpty {
            self.currentState = .notSearching
            loadData(isLoadMore: false)
        } else {
            pendingRequestWorkItem?.cancel()
            let requestWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.currentState = .searching(text: text)
                self.loadData(searchText: text, isLoadMore: false)
            }
            pendingRequestWorkItem = requestWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                          execute: requestWorkItem)
        }
        
    }
}

private extension HomeViewModel {
    
    func loadData(searchText: String? = nil, isLoadMore: Bool) {
        guard hasMoreItems else { return }
        if isLoadMore {
            statePresenter?.render(state: .loadingMore)
        } else {
            statePresenter?.render(state: .loading)
            articles.removeAll()
        }
        let requestParameters = HeadlineArticleParameters(country: userFavorite.countryISO,
                                                          category: userFavorite.category,
                                                          page: pageNumber,
                                                          query: searchText)
        dataSource.loadData(requestParameters: requestParameters) {[weak self] result in
            guard let self = self else { return }
            self.handleDataLoading(result: result)
        }
    }
    
    func handleDataLoading(result: ArticleResult) {
        switch result {
        case .success(let value):
            setData(items: value.articles ?? [])
            checkHasMoreItems(totalResultCount: value.totalResults ?? 0)
        case .failure(let error):
            statePresenter?.render(state: .error(error.localizedDescription))
        }
    }
    
    func setData(items: [Article]) {
        self.articles.append(contentsOf: items)
        statePresenter?.render(state: .populated)
    }
    
    func checkHasMoreItems(totalResultCount: Int) {
        if articles.count < totalResultCount && articles.count < 100 {
            pageNumber += 1
        } else {
            hasMoreItems = false
        }
    }
}

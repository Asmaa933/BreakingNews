//
//  HomeViewModel.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import Foundation

enum HomeState: Equatable {
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
    private var searchedArticles = [Article]()
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
        if !loadDataFromCaching() {
            loadData(isLoadMore: false)
        }
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
        let count = currentState == .notSearching ? articles.count : searchedArticles.count
        if count == 0 {
            statePresenter?.render(state: .empty)
        }
        return count
    }
    
    func getArticle(at index: Int) -> Article {
        currentState == .notSearching ? articles[index] : searchedArticles[index]
    }
    
    func searchForArticle(by text: String) {
        hasMoreItems = true
        if text.isEmpty {
            searchedArticles.removeAll()
            self.currentState = .notSearching
            pageNumber = articles.count / 20 + 1
            statePresenter?.render(state: .populated)
        } else {
            pageNumber = 1
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

fileprivate extension HomeViewModel {
    
    @discardableResult
    func loadDataFromCaching() -> Bool {
        articles = CachingManager.shared.loadArticles()
        pageNumber = articles.count / 20 + 1
        statePresenter?.render(state: .populated)
        return !articles.isEmpty
    }
    
    func loadData(searchText: String? = nil, isLoadMore: Bool) {
        guard hasMoreItems else { return }
        if isLoadMore {
            statePresenter?.render(state: .loadingMore)
        } else {
            statePresenter?.render(state: .loading)
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
            checkHasMoreItems(totalResultCount: value.totalResults ?? 0,
                              isNewArrayNotEmpty: !(value.articles?.isEmpty ?? false))
        case .failure(let error):
            statePresenter?.render(state: .error(error))
        }
    }
    
    func setData(items: [Article]) {
        switch currentState {
        case .searching:
            self.searchedArticles.append(contentsOf: items)
            statePresenter?.render(state: .populated)
        case .notSearching:
            guard !items.isEmpty else { return }
            var newArticles = self.articles
            newArticles.append(contentsOf: items)
            CachingManager.shared.saveArticles(newArticles)
            loadDataFromCaching()
        }
    }
    
    func checkHasMoreItems(totalResultCount: Int, isNewArrayNotEmpty: Bool) {
        if articles.count < totalResultCount && isNewArrayNotEmpty {
            pageNumber += 1
        } else {
            hasMoreItems = false
        }
    }
}

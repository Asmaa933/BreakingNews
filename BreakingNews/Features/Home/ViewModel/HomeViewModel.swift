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
    func fetchArticles(isRefresh: Bool)
    func getArticlesCount() -> Int
    func getArticle(at index: Int) -> Article
    func loadMoreArticles()
    func searchForArticle(by text: String)
    func checkLastCacheDate()
    func stopTimer()
    func getTitle() -> String
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
    private weak var timer: Timer?
    
    var statePresenter: StatePresentable?
    
    init(userFavorite: UserFavorite, dataSource: HomeDataProviderUseCase) {
        self.userFavorite = userFavorite
        self.dataSource = dataSource
    }
    
    deinit {
        stopTimer()
    }
    
    func fetchArticles(isRefresh: Bool) {
        pageNumber = 1
        hasMoreItems = true
        if isRefresh {
            loadData(isLoadMore: false, isRefresh: true)
        } else if !loadDataFromCaching() {
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
        searchedArticles.removeAll()
        pendingRequestWorkItem?.cancel()
        if text.isEmpty {
            currentState = .notSearching
            loadDataFromCaching()
        } else {
            pageNumber = 1
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
    
    func getTitle() -> String {
        userFavorite.category.capitalized + " news in " + userFavorite.country
    }
}

fileprivate extension HomeViewModel {
    
    @discardableResult
    func loadDataFromCaching(state: State = .populated) -> Bool {
        articles = CachingManager.shared.loadArticles()
        pageNumber = articles.count / 20 + 1
        statePresenter?.render(state: state)
        return !articles.isEmpty
    }
    
    func loadData(searchText: String? = nil, isLoadMore: Bool, isRefresh: Bool = false) {
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
            self.handleDataLoading(result: result, isRefresh: isRefresh)
        }
    }
    
    func handleDataLoading(result: ArticleResult, isRefresh: Bool) {
        switch result {
        case .success(let value):
            setData(items: value.articles ?? [], isRefresh: isRefresh)
            checkHasMoreItems(totalResultCount: value.totalResults ?? 0,
                              isNewArrayNotEmpty: !(value.articles?.isEmpty ?? false))
        case .failure(let error):
            statePresenter?.render(state: .error(error))
        }
    }
    
    func setData(items: [Article], isRefresh: Bool) {
        if isRefresh {
            handleRefreshArticles(items: items)
            return
        } else {
            setArticles(items)
        }
    }
    
    func setArticles(_ items: [Article]) {
        switch currentState {
        case .searching:
            self.searchedArticles.append(contentsOf: items)
            statePresenter?.render(state: .populated)
        case .notSearching:
            guard !items.isEmpty else {
                statePresenter?.render(state: .populated)
                return
            }
            var newArticles = self.articles
            newArticles.append(contentsOf: items)
            CachingManager.shared.saveArticles(newArticles)
            startTimer()
            loadDataFromCaching()
        }
    }
    
    func handleRefreshArticles(items: [Article]) {
        CachingManager.shared.saveArticles(items)
        startTimer()
        loadDataFromCaching(state: .refresh)
    }
    
    func checkHasMoreItems(totalResultCount: Int, isNewArrayNotEmpty: Bool) {
        if articles.count < totalResultCount && isNewArrayNotEmpty {
            pageNumber += 1
        } else {
            hasMoreItems = false
        }
    }
}

extension HomeViewModel {
    
   private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 60 * 15, repeats: true, block: {[weak self] _ in
            guard let self = self else { return }
            self.fetchArticles(isRefresh: true)
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func checkLastCacheDate() {
        guard let lastCache = UserDefaultsManager.getLastCacheDate() else { return }
        let difference = lastCache.getDifferenceInMinutes()
        if difference > 15 {
            self.fetchArticles(isRefresh: true)
        }
    }
}

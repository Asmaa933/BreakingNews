//
//  HomeViewModelTests.swift
//  BreakingNewsTests
//
//  Created by Asmaa Tarek on 26/12/2021.
//

import XCTest
@testable import BreakingNews

class HomeViewModelTests: XCTestCase {
    
    var userFavorite: UserFavorite!
    override func setUp() {
        UserDefaultsManager.saveUserFavorite(UserFavorite(countryISO: "us", category: "technology", country: "America"))
        userFavorite = UserDefaultsManager.getUserFavorite()
    }
    
    override class func tearDown() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.UserFavorite.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.lastCacheDate.rawValue)
    }
    
    func testFetchDataFromAPI() {
        CachingManager.shared.saveArticles([])
        let homeProvider = FakeHomeDataSource(shouldReturnError: false, error: nil)
        let sut = HomeViewModel(userFavorite: userFavorite, dataSource: homeProvider)
        let viewController = FakeHomeViewController()
        sut.statePresenter = viewController
        sut.fetchArticles(isRefresh: false)
        XCTAssertTrue(sut.getArticlesCount() == 3)
        XCTAssertTrue(viewController.errorMessage == "")
        XCTAssertFalse(viewController.isEmpty)
        XCTAssertFalse(viewController.centerLoadingIndicator)
    }
    
    func testFailFetchDataFromAPI() {
        CachingManager.shared.saveArticles([])
        let homeProvider = FakeHomeDataSource(shouldReturnError: true, error: ErrorHandler.generalError)
        let sut = HomeViewModel(userFavorite: userFavorite, dataSource: homeProvider)
        let viewController = FakeHomeViewController()
        sut.statePresenter = viewController
        sut.fetchArticles(isRefresh: false)
        XCTAssertTrue(sut.getArticlesCount() == 0)
        XCTAssertTrue(viewController.errorMessage == ErrorHandler.generalError.message )
        XCTAssertTrue(viewController.isEmpty)
        XCTAssertFalse(viewController.isRefresh)
        XCTAssertFalse(viewController.centerLoadingIndicator)
    }
    
    func testFetchDataFromCache() {
        CachingManager.shared.saveArticles([FakeArticle().article])
        let homeProvider = FakeHomeDataSource(shouldReturnError: false, error: nil)
        let sut = HomeViewModel(userFavorite: userFavorite, dataSource: homeProvider)
        let viewController = FakeHomeViewController()
        sut.statePresenter = viewController
        sut.fetchArticles(isRefresh: false)
        XCTAssertTrue(sut.getArticlesCount() == 1)
        XCTAssertTrue(viewController.errorMessage == "")
        XCTAssertFalse(viewController.isEmpty)
        XCTAssertFalse(viewController.centerLoadingIndicator)
    }
    
    func testRefreshData() {
        let expectationObject = expectation(description: "Testing loading in tableview")
        CachingManager.shared.saveArticles([FakeArticle().article])
        let homeProvider = FakeHomeDataSource(shouldReturnError: false, error: nil)
        let sut = HomeViewModel(userFavorite: userFavorite, dataSource: homeProvider)
        let viewController = FakeHomeViewController()
        sut.statePresenter = viewController
        sut.statePresenter?.render(state: .loading)
        XCTAssertTrue(viewController.centerLoadingIndicator)
        sut.fetchArticles(isRefresh: true)
        XCTAssertTrue(sut.getArticlesCount() == 3)
        expectationObject.fulfill()
        XCTAssertTrue(viewController.errorMessage == "")
        XCTAssertFalse(viewController.isEmpty)
        XCTAssertFalse(viewController.centerLoadingIndicator)
        XCTAssertTrue(viewController.isRefresh)
        XCTAssertFalse(viewController.footerLoadingIndicator)
        waitForExpectations(timeout: 5)
    }
    
    func testGetArticle() {
        CachingManager.shared.saveArticles([])
        let homeProvider = FakeHomeDataSource(shouldReturnError: false, error: nil)
        let sut = HomeViewModel(userFavorite: userFavorite, dataSource: homeProvider)
        sut.fetchArticles(isRefresh: false)
        let article = sut.getArticle(at: 0)
        XCTAssertEqual(article.author!, "fefe")
    }
    
    func testLoadMoreArticles() {
        CachingManager.shared.saveArticles([])
        let homeProvider = FakeHomeDataSource(shouldReturnError: false, error: nil)
        let sut = HomeViewModel(userFavorite: userFavorite, dataSource: homeProvider)
        let viewController = FakeHomeViewController()
        sut.statePresenter = viewController
        sut.statePresenter?.render(state: .loading)
        XCTAssertTrue(viewController.centerLoadingIndicator)
        sut.fetchArticles(isRefresh: false)
        XCTAssertTrue(sut.getArticlesCount() == 3)
        XCTAssertFalse(viewController.centerLoadingIndicator)
        sut.statePresenter?.render(state: .loadingMore)
        XCTAssertTrue(viewController.footerLoadingIndicator)
        sut.loadMoreArticles()
        XCTAssertTrue(sut.getArticlesCount() == 6)
        XCTAssertFalse(viewController.footerLoadingIndicator)
        XCTAssertFalse(viewController.isRefresh)
        XCTAssertFalse(viewController.isEmpty)
        XCTAssertTrue(viewController.errorMessage.isEmpty)
        XCTAssertTrue(viewController.numberOfTimesRefreshed == 2)
        
    }
    
    func testGetTitle() {
        let homeProvider = FakeHomeDataSource(shouldReturnError: false, error: nil)
        let sut = HomeViewModel(userFavorite: userFavorite, dataSource: homeProvider)
        let title = sut.getTitle()
        XCTAssertEqual(title, "Technology news in America")
    }
    
    func testRefreshWhenLastCachingWasMore15Minutes() {
        CachingManager.shared.saveArticles([FakeArticle().article])
        let date = Date(timeIntervalSince1970: 1640298616)
        UserDefaultsManager.saveLastCacheDate(date: date)
        let homeProvider = FakeHomeDataSource(shouldReturnError: false, error: nil)
        let sut = HomeViewModel(userFavorite: userFavorite, dataSource: homeProvider)
        let viewController = FakeHomeViewController()
        sut.statePresenter = viewController
        sut.checkLastCacheDate()
        XCTAssertTrue(sut.getArticlesCount() == 3)
        XCTAssertTrue(viewController.isRefresh)
    }
    
    func testRefreshUsingTimerMock() {
        CachingManager.shared.saveArticles([FakeArticle().article])
        let homeProvider = FakeHomeDataSource(shouldReturnError: false, error: nil)
        let sut = HomeViewModel(userFavorite: userFavorite, dataSource: homeProvider, timer: MockTimer.currentTimer)
        let viewController = FakeHomeViewController()
        sut.statePresenter = viewController
        MockTimer.currentTimer.fire()
     //   XCTAssertTrue(sut.getArticlesCount() == 3)
       // XCTAssertFalse(viewController.isRefresh)
    }
    
    func testNotRefreshWhenLastCachingWasNow(){
        CachingManager.shared.saveArticles([FakeArticle().article])
        UserDefaultsManager.saveLastCacheDate(date: Date())
        let homeProvider = FakeHomeDataSource(shouldReturnError: false, error: nil)
        let sut = HomeViewModel(userFavorite: userFavorite, dataSource: homeProvider)
        let viewController = FakeHomeViewController()
        sut.statePresenter = viewController
        sut.fetchArticles(isRefresh: false)
        sut.checkLastCacheDate()
        XCTAssertTrue(sut.getArticlesCount() == 1)
        XCTAssertFalse(viewController.isRefresh)
    }
    
    func testSearchForText() {
        let expectationObject = expectation(description: "Testing Search")
        CachingManager.shared.saveArticles([])
        let homeProvider = FakeHomeDataSource(shouldReturnError: false, error: nil)
        let sut = HomeViewModel(userFavorite: userFavorite, dataSource: homeProvider)
        let viewController = FakeHomeViewController()
        sut.searchForArticle(by: "xxx")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            expectationObject.fulfill()
            XCTAssertTrue(sut.currentState == .searching(text: "xxx"))
            XCTAssertTrue(sut.getArticlesCount() == 3)
            XCTAssertTrue(viewController.errorMessage.isEmpty)
        }
        waitForExpectations(timeout: 5)
    }
    
    func testChangeSearchTextBeforeTime() {
        let expectationObject = expectation(description: "Test Search For Empty String")
        CachingManager.shared.saveArticles([])
        let homeProvider = FakeHomeDataSource(shouldReturnError: false, error: nil)
        let sut = HomeViewModel(userFavorite: userFavorite, dataSource: homeProvider)
        let viewController = FakeHomeViewController()
        sut.searchForArticle(by: "xxx")
        sut.searchForArticle(by: "yyy")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            expectationObject.fulfill()
            XCTAssertTrue(sut.currentState == .searching(text: "yyy"))
            XCTAssertTrue(sut.getArticlesCount() == 3)
            XCTAssertTrue(viewController.errorMessage.isEmpty)
        }
        waitForExpectations(timeout: 5)
    }
    
    
    func testChangeSearchEmptyString() {
        let expectationObject = expectation(description: "Test Search For Empty String")
        CachingManager.shared.saveArticles([FakeArticle().article])
        let homeProvider = FakeHomeDataSource(shouldReturnError: false, error: nil)
        let sut = HomeViewModel(userFavorite: userFavorite, dataSource: homeProvider)
        let viewController = FakeHomeViewController()
        sut.searchForArticle(by: "xxx")
        sut.searchForArticle(by: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            expectationObject.fulfill()
            XCTAssertTrue(sut.currentState == .notSearching)
            XCTAssertTrue(sut.getArticlesCount() == 1)
            XCTAssertTrue(viewController.errorMessage.isEmpty)
        }
        waitForExpectations(timeout: 5)
    }
    
    func testLoadMoreItemForSearch() {
        let expectationObject = expectation(description: "Test Search For Empty String")
        CachingManager.shared.saveArticles([FakeArticle().article])
        let homeProvider = FakeHomeDataSource(shouldReturnError: false, error: nil)
        let sut = HomeViewModel(userFavorite: userFavorite, dataSource: homeProvider)
        let viewController = FakeHomeViewController()
        sut.searchForArticle(by: "xxx")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            sut.loadMoreArticles()
            expectationObject.fulfill()
            XCTAssertTrue(sut.currentState == .searching(text: "xxx"))
            XCTAssertTrue(sut.getArticlesCount() == 6)
            XCTAssertTrue(viewController.errorMessage.isEmpty)
        }
        waitForExpectations(timeout: 5)
    }
}

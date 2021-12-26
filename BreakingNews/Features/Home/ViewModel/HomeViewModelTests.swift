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
}

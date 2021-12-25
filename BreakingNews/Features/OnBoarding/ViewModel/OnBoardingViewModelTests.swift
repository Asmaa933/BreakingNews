//
//  OnBoardingViewModelTests.swift
//  BreakingNewsTests
//
//  Created by Asmaa Tarek on 25/12/2021.
//

import XCTest
@testable import BreakingNews

class OnBoardingViewModelTests: XCTestCase {
    
    func testSaveUserFavorites() {
        let sut = OnBoardingViewModel()
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.UserFavorite.rawValue)
        sut.selectedCountryIndex = 0
        sut.selectedCategoryIndex = 0
        sut.startHeadlines()
        let userFavorites = UserDefaultsManager.getUserFavorite()
        XCTAssertTrue(userFavorites?.country == sut.getCountries()[0])
        XCTAssertTrue(userFavorites?.category == sut.getCategories()[0].lowercased())
    }
    
    func testUserDidnotSelectFavorites() {
        let sut = OnBoardingViewModel()
        let fakeView = FakeOnBoardingViewController()
        sut.statePresenter = fakeView
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.UserFavorite.rawValue)
        sut.startHeadlines()
        let userFavorites = UserDefaultsManager.getUserFavorite()
        XCTAssertNil(userFavorites)
        XCTAssertEqual(fakeView.errorMessage, ErrorHandler.selectDropDown.message)
        XCTAssertFalse(fakeView.isDefaultState)
    }
}

//
//  OnBoardingViewModel.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import Foundation

protocol OnBoardingViewModelProtocol {
    var statePresenter: StatePresentable? { get set }
    var selectedCategoryIndex: Int? { get set}
    var selectedCountryIndex: Int? { get set}
    var userFavorite: UserFavorite? { get }
    func getCategories() -> [String]
    func getCountries() -> [String]
    func startHeadlines()
}

class OnBoardingViewModel: OnBoardingViewModelProtocol {
    
    private var categories = NewsCategory.allCases
    private var countries = NewsCountry.allCases
    private(set) var userFavorite: UserFavorite?
    var statePresenter: StatePresentable?
    var selectedCategoryIndex: Int?
    var selectedCountryIndex: Int?
    
    
    func getCategories() -> [String] {
        categories.map { $0.rawValue.capitalized }
    }
    
    func getCountries() -> [String] {
        countries.map { $0.rawValue }
    }
    
    func startHeadlines() {
        guard let selectedCountryIndex = selectedCountryIndex,
              let selectedCategoryIndex = selectedCategoryIndex else {
                  statePresenter?.render(state: .error(ErrorHandler.selectDropDown))
                  return
              }
        
        let userFavorite = UserFavorite(countryISO: countries[selectedCountryIndex].isoCode,
                                        category: categories[selectedCategoryIndex].rawValue,
                                        country: countries[selectedCountryIndex].rawValue)
        UserDefaultsManager.saveUserFavorite(userFavorite)
        self.userFavorite = userFavorite
        statePresenter?.render(state: .populated)
    }
}



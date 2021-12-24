//
//  OnBoardingViewModel.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import Foundation

protocol OnBoardingViewModelProtocol {
    var selectedCategoryIndex: Int? { get set}
    var selectedCountryIndex: Int? { get set}
    func getCategories() -> [String]
    func getCountries() -> [String]
    func startHeadlines()
}

class OnBoardingViewModel: OnBoardingViewModelProtocol {
    
    private var categories = NewsCategory.allCases
    private var countries = NewsCountry.allCases
    var selectedCategoryIndex: Int?
    var selectedCountryIndex: Int?
    
    func getCategories() -> [String] {
        categories.map { $0.rawValue.capitalized }
    }
    
    func getCountries() -> [String] {
        countries.map { $0.rawValue }
    }
    
    func startHeadlines() {
        
    }
}

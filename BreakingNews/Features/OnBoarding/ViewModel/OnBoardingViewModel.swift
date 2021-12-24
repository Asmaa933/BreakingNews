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

class OnBoardingViewModel {
    
}

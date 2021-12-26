//
//  FakeHomeViewController.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 26/12/2021.
//

import Foundation

class FakeHomeViewController: StatePresentable {
    
    var errorMessage = ""
    var isEmpty = false
    var centerLoadingIndicator = false
    var footerLoadingIndicator = false
    var numberOfTimesRefreshed = 0
    var isRefresh = false
    
    func render(state: State) {
        switch state {
        case .loading:
            centerLoadingIndicator = true
        case .loadingMore:
            footerLoadingIndicator = true
        case .error(let error):
            centerLoadingIndicator = false
            footerLoadingIndicator = false
            show(error: error)
        case .empty:
            isEmpty = true
        case .populated:
            centerLoadingIndicator = false
            footerLoadingIndicator = false
        case .refresh:
            centerLoadingIndicator = false
            footerLoadingIndicator = false
            isRefresh = true
        }
    }
    
    func show(error: Error) {
        errorMessage = (error as? ErrorHandler)?.message ?? error.localizedDescription
    }
    
    func dataLoaded() {
        numberOfTimesRefreshed += 1
    }
    
}


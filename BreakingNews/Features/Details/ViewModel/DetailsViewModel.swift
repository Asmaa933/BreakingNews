//
//  DetailsViewModel.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import Foundation

protocol DetailsViewModelProtocol {
    var article: Article { get }
    var statePresenter: StatePresentable? { get set }
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    var statePresenter: StatePresentable?
    private(set) var article: Article
    
    init(article: Article) {
        self.article = article
    }
}

//
//  DetailsViewModel.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import Foundation

protocol DetailsViewModelProtocol {
    
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    private var article: Article
    
    init(article: Article) {
        self.article = article
    }
}

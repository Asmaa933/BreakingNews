//
//  DetailsViewModel.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import Foundation
import UIKit

protocol DetailsViewModelProtocol {
    var article: Article { get }
    var statePresenter: StatePresentable? { get set }
    var articleURL: URL? { get }
    func openArticleInSafari()
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    var statePresenter: StatePresentable?
    private(set) var article: Article
    private(set) var articleURL: URL?
    
    init(article: Article) {
        self.article = article
    }
    
    func openArticleInSafari() {
        guard let stringURL = article.url?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
              let url = URL(string: stringURL), UIApplication.shared.canOpenURL(url) else {
                  statePresenter?.render(state: .error(ErrorHandler.invalidURL))
                  return
              }
        articleURL = url
        statePresenter?.render(state: .populated)
    }
}

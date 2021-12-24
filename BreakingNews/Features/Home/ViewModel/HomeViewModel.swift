//
//  HomeViewModel.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import Foundation

protocol HomeViewModelProtocol {
}

class HomeViewModel: HomeViewModelProtocol {
    
    private let userFavorite: UserFavorite
    private let dataSource: HomeDataProviderUseCase

    init(userFavorite: UserFavorite, dataSource: HomeDataProviderUseCase) {
        self.userFavorite = userFavorite
        self.dataSource = dataSource
    }

}

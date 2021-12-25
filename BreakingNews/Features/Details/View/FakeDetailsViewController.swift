//
//  FakeDetailsViewController.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 26/12/2021.
//

import Foundation

class FakeDetailsViewController: StatePresentable {
    
    var errorMessage = ""
    var openSafari = false
    
    func render(state: State) {
        switch state {
        case .error(let error):
            show(error: error)
        case  .populated:
            openSafari = true
        default:
            break
        }
    }
    
    func show(error: Error) {
        errorMessage = (error as? ErrorHandler)?.message ?? error.localizedDescription
    }
}

//
//  State.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import UIKit

enum State {
    case loading
    case error(String)
    case empty
    case populated
}

enum EmptyState {
    case visible, hidden
}

protocol EmptyPresentable {
    func setEmptyView()
}

extension EmptyPresentable {
    func setEmptyView() {}
}

protocol ErrorPresentable {
    func show(errorMessage: String)
}

extension ErrorPresentable where Self: UIViewController {
    func show(errorMessage: String) {
        let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

protocol StatePresentable: EmptyPresentable, ErrorPresentable {
    func render(state: State)
}

//
//  State.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import UIKit

enum State {
    case loading
    case loadingMore
    case error(Error)
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
    func show(error: Error)
}

extension ErrorPresentable where Self: UIViewController {
    func show(error: Error) {
        let message = (error as? ErrorHandler)?.message ?? error.localizedDescription
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

protocol StatePresentable: EmptyPresentable, ErrorPresentable {
    func render(state: State)
}

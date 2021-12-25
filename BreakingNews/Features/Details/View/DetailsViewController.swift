//
//  DetailsViewController.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import UIKit
import SafariServices

class DetailsViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var articleImage: UIImageView!
    
    private var viewModel: DetailsViewModelProtocol
    
    init(viewModel: DetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.statePresenter = self
        setupView()
    }
    
    @IBAction private func backAction(_ sender: UIButton) {
        pop()
    }
    
    @IBAction private func openArticleAction(_ sender: BottomButton) {
        viewModel.openArticleInSafari()
    }
}

fileprivate extension DetailsViewController {
    func setupView() {
        articleImage.layer.cornerRadius = 10
        updateUI()
    }
    
    func updateUI() {
        let article = viewModel.article
        titleLabel.text = article.title ?? "-"
        authorLabel.text = article.author ?? "-"
        sourceLabel.text = article.source?.name ?? "-"
        descriptionLabel.text = article.articleDescription ?? "-"
        if let imageURL = article.urlToImage {
            articleImage.setImageWith(url: imageURL)
        }
    }
    
    func openSafariView() {
        guard let url = viewModel.articleURL else { return }
        let safari = SFSafariViewController(url: url)
        present(safari, animated: true)
    }
}

extension DetailsViewController: StatePresentable {
    func render(state: State) {
        switch state {
        case .error(let error):
            show(error: error)
        case .populated:
            openSafariView()
        default:
            break
        }
    }
}

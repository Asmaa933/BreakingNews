//
//  DetailsViewController.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private let viewModel: DetailsViewModelProtocol
    
    init(viewModel: DetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction private func backAction(_ sender: UIButton) {
        
    }
    
    @IBAction private func openArticleAction(_ sender: BottomButton) {
    }
}

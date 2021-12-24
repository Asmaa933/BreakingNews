//
//  HomeViewController.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var newsTableView: UITableView!
    
    private var viewModel: HomeViewModelProtocol
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.statePresenter = self
        viewModel.fetchArticles()
        setupView()
    }
}

fileprivate extension HomeViewController {
    
    func setupView() {
        setupNewsTableView()
    }
    
    func setupNewsTableView() {
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.registerCellNib(cellClass: NewsTableViewCell.self)
    }
    
    func reloadData() {
        newsTableView.isHidden = false
        newsTableView.reloadData()
        newsTableView.restore()
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getArticlesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as NewsTableViewCell
        let article = viewModel.getArticle(at: indexPath.row)
        cell.configureCell(imageURL: article.urlToImage, title: article.title)
        return cell
    }
}

extension HomeViewController: StatePresentable {
    func render(state: State) {
        switch state {
        case .loading:
            break // show loader
        case .error(let error):
            show(errorMessage: error)
        case .empty:
            setEmptyView()
        case .populated:
            reloadData() // dismiss loader
        }
    }
    
    func setEmptyView() {
        newsTableView.setEmptyView(title: "No result found")
    }
}

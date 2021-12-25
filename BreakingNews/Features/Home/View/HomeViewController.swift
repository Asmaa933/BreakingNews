//
//  HomeViewController.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var newsLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var searchBar: CustomSearchBar!
    @IBOutlet private weak var newsTableView: UITableView!
    
    private var viewModel: HomeViewModelProtocol
    private var footerActivityIndicator: UIActivityIndicatorView?
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkLastCacheDate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopTimer()
        dismissKeyBoard()
    }
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.statePresenter = self
        viewModel.fetchArticles(isRefresh: false)
        setupView()
    }
}

fileprivate extension HomeViewController {
    
    func setupView() {
        setupNewsTableView()
        setupSearchBar()
        handleTapOnView()
        newsLabel.text = viewModel.getTitle()
    }
    
    func setupNewsTableView() {
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.registerCellNib(cellClass: NewsTableViewCell.self)
        newsTableView.keyboardDismissMode = .onDrag
    }
    
    func reloadData() {
        removeIndicators()
        newsTableView.isHidden = false
        newsTableView.reloadData()
    }
    
    func removeIndicators() {
        newsTableView.removeActivityIndicatorFromFooter(footerActivityIndicator)
        dismissLoading()
    }
    
    func setupSearchBar() {
        searchBar.textDidChange = {[weak self] text in
            guard let self = self else { return}
            self.viewModel.searchForArticle(by: text)
        }
    }
    
    func showLoading() {
        newsTableView.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    func dismissLoading() {
        newsTableView.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
    
    func scrollToTop() {
        removeIndicators()
        newsTableView.reloadData()
        if viewModel.getArticlesCount() != 0 {
            newsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func handleTapOnView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getArticlesCount() - 1 {
            viewModel.loadMoreArticles()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewModel = DetailsViewModel(article: viewModel.getArticle(at: indexPath.row))
        let detailsViewController = DetailsViewController(viewModel: detailsViewModel)
        push(viewController: detailsViewController)
    }
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
            showLoading()
        case .loadingMore:
            footerActivityIndicator = newsTableView.showActivityIndicatorInFooter()
        case .error(let error):
            reloadData()
            show(error: error)
        case .empty:
            setEmptyView()
        case .populated:
            newsTableView.restore()
            reloadData()
        case .refresh:
            scrollToTop()
        }
    }
    
    func setEmptyView() {
        newsTableView.setEmptyView(title: "No result found")
    }
}


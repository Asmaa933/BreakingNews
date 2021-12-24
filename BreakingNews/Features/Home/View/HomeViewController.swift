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
    
    //MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
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
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as NewsTableViewCell
        return cell
    }
}

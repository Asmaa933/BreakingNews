//
//  CustomSearchBar.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 25/12/2021.
//

import UIKit

class CustomSearchBar: UISearchBar {

    var textDidChange: ((String) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSearchBar()
    }

    private func setupSearchBar() {
        self.delegate = self
    }
}

extension CustomSearchBar: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textDidChange?(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.resignFirstResponder()
        textDidChange?("")
    }
}

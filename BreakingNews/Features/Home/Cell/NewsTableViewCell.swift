//
//  NewsTableViewCell.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var newsTitle: UILabel!
    
    func configureCell(imageURL: String?, title: String?) {
        newsTitle.text = title
        if let imageURL = imageURL {
            newsImage.setImageWith(url: imageURL)
        }
    }
}

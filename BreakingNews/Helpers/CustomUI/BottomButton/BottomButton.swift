//
//  BottomButton.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import UIKit

class BottomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }
    
    private func setupButton() {
        self.layer.cornerRadius = 10
        self.backgroundColor = .color(for: .bottomButton)
        self.layer.shadowColor = UIColor.color(for: .shadowColor).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
    }

}


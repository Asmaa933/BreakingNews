//
//  UIImageView+Ext.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import UIKit
import SDWebImage

extension UIImageView {

    func setImageWith(url: String, placeHolder: UIImage = #imageLiteral(resourceName: "placeholder")) {
        let transformer = SDImageResizingTransformer(size: getSize(), scaleMode: .fill)
        self.sd_setImage(with: URL(string: url), placeholderImage: placeHolder, options: [], context: [.imageTransformer: transformer])
    }

    private func getSize() -> CGSize {
        if self.bounds.size.equalTo(.zero) {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        } else {
            return CGSize(width: self.bounds.width, height: self.bounds.height)
        }
    }
}

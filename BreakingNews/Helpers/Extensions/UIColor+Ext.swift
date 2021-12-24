//
//  UIColor+Ext.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import UIKit

enum Color: String {
    case bottomButton = "BottomButton"
    case shadowColor = "ShadowColor"
}

extension UIColor {
    static func color(for color: Color) -> UIColor {
        UIColor(named: color.rawValue) ?? UIColor()
    }
}

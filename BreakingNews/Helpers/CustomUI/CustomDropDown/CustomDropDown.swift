//
//  CustomDropDown.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import UIKit
import DropDown

class CustomDropDown: UITextField {
    
    var didSelectItem: ((Int) -> Void)? // index
    private let dropMenu = DropDown()
    
    public var dropMenuItems: [String]? {
        get {
            return dropMenu.dataSource
        }
        set {
            dropMenu.dataSource = newValue ?? []
        }
    }
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        setupDropDown()
    }
}

fileprivate extension CustomDropDown {
    
    func setupDropDown() {
        dropMenu.bottomOffset = CGPoint(x: 0, y: (self.bounds.height))
        dropMenu.direction = .any
        dropMenu.anchorView = self.plainView
        dropMenu.selectionAction = {[weak self] (index: Int, _: String) in
            guard let self = self else { return }
            self.handleItemSelection(at: index)
        }
    }
    
    func handleItemSelection(at index: Int) {
        didSelectItem?(index)
    }
}

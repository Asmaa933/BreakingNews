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
    private var label = UILabel()
    
    public var dropMenuItems: [String]? {
        get {
            return dropMenu.dataSource
        }
        set {
            dropMenu.dataSource = newValue ?? []
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}

fileprivate extension CustomDropDown {
    
    func setupView() {
        setupTextField()
        setupDropDown()
        setupLabel()
    }
    
    func setupTextField() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dropMenuTapped)))
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
    }
    
    func setupDropDown() {
        dropMenu.bottomOffset = CGPoint(x: 0, y: (self.bounds.height))
        dropMenu.direction = .any
        dropMenu.anchorView = self.plainView
        dropMenu.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.handleItemSelection(at: index, item: item)
        }
    }
    
    func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = placeholder
        label.textColor = .gray
        label.isHidden = true
        label.font = UIFont.boldSystemFont(ofSize: 13)
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 15),
            label.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5)
        ])
    }
    
    func handleItemSelection(at index: Int, item: String) {
        self.text = item
        self.label.isHidden = false
        didSelectItem?(index)
    }
    
    @objc func dropMenuTapped() {
        dropMenu.show()
    }
}

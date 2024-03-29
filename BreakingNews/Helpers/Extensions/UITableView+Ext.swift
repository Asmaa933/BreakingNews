//
//  UITableView+Ext.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import UIKit

extension UITableView {
    
    func registerCellNib<Cell: UITableViewCell>(cellClass: Cell.Type) {
        let identifier = String(describing: Cell.self)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func dequeue<Cell: UITableViewCell>() -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? Cell else {
            fatalError("Error in dequeue cell")
        }
        return cell
    }
    
    func setEmptyView(title: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        messageImageView.backgroundColor = .clear
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = .black
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        
        NSLayoutConstraint.activate([
            messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20),
            messageImageView.widthAnchor.constraint(equalToConstant: 100),
            messageImageView.heightAnchor.constraint(equalToConstant: 100),
            titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 5),
            titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor)
        ])
        messageImageView.image = UIImage(named: "placeholder")
        titleLabel.text = title
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
    func showActivityIndicatorInFooter() -> UIActivityIndicatorView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 40))
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = #colorLiteral(red: 0.9764705882, green: 0.4941176471, blue: 0.03921568627, alpha: 1)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.center = footerView.center
        loadingIndicator.startAnimating()
        footerView.clipsToBounds = true
        footerView.addSubview(loadingIndicator)
        tableFooterView = footerView
        return loadingIndicator
    }
    
    func removeActivityIndicatorFromFooter(_ loadingIndicator: UIActivityIndicatorView?) {
        if loadingIndicator != nil {
            loadingIndicator?.stopAnimating()
            loadingIndicator?.removeFromSuperview()
            self.tableFooterView = nil
            self.tableFooterView?.isHidden = true
        }
    }
}

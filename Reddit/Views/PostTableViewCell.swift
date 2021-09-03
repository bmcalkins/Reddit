//
//  PostTableViewCell.swift
//  Reddit
//
//  Created by Folarin Williamson on 10/10/20.
//

import UIKit

// MARK: PostTableViewCell
class PostTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    override var reuseIdentifier: String? {
        return String(describing: PostTableViewCell.self)
    }
    
    func configure(_ vm: PostCellConfigurable) {
        selectionStyle = .none
        titleLabel.text = vm.title
        subtitleLabel.text = vm.subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        layout()
    }
    
    private func layout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10.0).isActive = true
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.numberOfLines = 0
        addSubview(subtitleLabel)
        subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0).isActive = true
        bottomAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10.0).isActive = true
    }
}

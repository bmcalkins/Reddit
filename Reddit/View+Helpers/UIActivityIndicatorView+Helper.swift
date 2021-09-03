//
//  UIActivityIndicatorView+Helper.swift
//  Reddit
//
//  Created by Folarin Williamson on 10/11/20.
//

import UIKit

extension UIActivityIndicatorView {
    func showInCenterOf(view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        startAnimating()
    }
}

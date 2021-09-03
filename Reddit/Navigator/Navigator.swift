//
//  Navigator.swift
//  Reddit
//
//  Created by Folarin Williamson on 10/10/20.
//

import UIKit

class Navigator {
    let navigationController: UINavigationController
    
    init(rootController: UIViewController) {
        self.navigationController = UINavigationController(rootViewController: rootController)
    }
}

extension Navigator: PostsViewControllerDelegate {
    func selectedPost(with urlString: String) {
        let controller = WebViewController.create(urlString)
        navigationController.pushViewController(controller, animated: true)
    }
}

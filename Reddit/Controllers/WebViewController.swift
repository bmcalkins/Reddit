//
//  WebViewController.swift
//  Reddit
//
//  Created by Folarin Williamson on 10/10/20.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    private var urlString: String!
    private let webview =  WKWebView()
    
    private var spinner: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        return activity
    }()
    
    static func create(_ urlString: String) -> WebViewController {
        let vc: WebViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: String(describing: WebViewController.self))
        vc.urlString = urlString
        return vc
    }
    
    override func loadView() {
        super.loadView()
        self.view = webview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webview.load(request)
            spinner.showInCenterOf(view: view)
        }
        
        webview.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if Float(webview.estimatedProgress) == 1 {
                spinner.stopAnimating()
            }
        }
    }
}

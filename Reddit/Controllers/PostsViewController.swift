//
//  PostsViewController.swift
//  Reddit
//
//  Created by Folarin Williamson on 10/10/20.
//

import UIKit

protocol PostsViewControllerDelegate {
    func selectedPost(with urlString: String)
}

class PostsViewController: UIViewController {
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var tableView: UITableView!
    private var viewModel: PostsViewModel!
    var delegate: PostsViewControllerDelegate?
    
    private var spinner: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        return activity
    }()
    
    private var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: "Error",
                                      message: "Something went wrong. We're looking into it.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alert
    }()
    
    private var searchText: String = "" {
        didSet {
            viewModel.fetch(searchText)
        }
    }
    
    static func create(_ vm: PostsViewModel) -> PostsViewController {
        let vc: PostsViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: String(describing: PostsViewController.self))
        vc.viewModel = vm
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        searchBar.placeholder = "Search Subreddits"
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
                
        viewModel.loadingState.bind {[weak self] loadingState in
            DispatchQueue.main.async {
                self?.processLoadingState(loadingState)
            }
        }
        
        viewModel.posts.bind {[weak self] posts in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func processLoadingState(_ state: LoadingState) {
        switch state {
        case .error:
            spinner.stopAnimating()
            present(errorAlert, animated: true, completion: nil)
        case .loaded:
            spinner.stopAnimating()
        case .loading:
            spinner.showInCenterOf(view: view)
        }
    }
}

// MARK: UITableViewDataSource
extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self)) as? PostTableViewCell else {
            fatalError("PostsViewController(UITableViewDataSource); unable to create PostTableViewCell")
        }
        
        let vm = viewModel.posts.value[indexPath.row]
        cell.configure(RedditPostCellViewModel(title: vm.title, subtitle: vm.subreddit))
        return cell
    }
}

// MARK: UITableViewDelegate
extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = viewModel.posts.value[indexPath.row].url
        delegate?.selectedPost(with: url)
    }
}

// MARK: UISearchBarDelegate
extension PostsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            searchText = text
        }
    }
}


/// NOTE: WARNINGS IN CONSOLE
/// https://developer.apple.com/forums/thread/112095
/// https://stackoverflow.com/questions/39793459/xcode-8-ios-10-starting-webfilter-logging-for-process

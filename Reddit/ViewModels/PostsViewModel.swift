//
//  PostsViewModel.swift
//  Reddit
//
//  Created by Folarin Williamson on 10/10/20.
//

import Foundation

enum LoadingState {
    case error
    case loading
    case loaded
}

protocol PostsViewModel {
    var posts: Dynamic<[Post]> { get }
    var loadingState: Dynamic<LoadingState> { get }
    func fetch(_ subreddit: String)
}

class RedditPostsViewModel: PostsViewModel {
    let posts: Dynamic<[Post]> = Dynamic([])
    let loadingState: Dynamic<LoadingState> = Dynamic(.loaded)
    
    func fetch(_ subreddit: String) {
        loadingState.value = .loading
        
        RedditPostsAPIRequest(subreddit: subreddit, client: BaseRequest()).execute() { result in
            switch result {
            case .failure:
                self.loadingState.value = .error
            case let .success(posts):
                self.loadingState.value = .loaded
                self.posts.value = posts
            }
        }
    }
}



//
//  RedditPostsAPIRequest.swift
//  Reddit
//
//  Created by Folarin Williamson on 10/10/20.
//

import Foundation
 
typealias PostsCompletionHandler = (Result<[Post], Error>) -> Void

// MARK: RedditPostsAPIRequest
struct RedditPostsAPIRequest: APIRequest {
    var url: String
    var method: RequestMethod
    let client: HTTPClient
    
    init(subreddit: String, client: HTTPClient) {
        self.url = "https://www.reddit.com/r/\(subreddit)/.json"
        self.method = .get
        self.client = client
    }
    
    func execute(completion: @escaping PostsCompletionHandler) {
        client.execute(self) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(data):
                guard let response = try? JSONDecoder().decode(RedditPostResponse.self, from: data) else {
                    completion(.failure(RequestError.parse))
                    return
                }
                completion(.success(response.posts))
            }
        }
    }
}

// MARK: RedditPostResponse
struct RedditPostResponse: Decodable {
    let posts: [Post]
    
    private struct PostObject: Decodable {
        let data: Post
    }
    
    enum RootObjectCodingKeys: CodingKey {
        case data
    }
    
    enum DataObjectCodingKeys: CodingKey {
        case children
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootObjectCodingKeys.self)
        let dataContainer = try rootContainer.nestedContainer(keyedBy: DataObjectCodingKeys.self, forKey: .data)
        let postObjects = try dataContainer.decode([PostObject].self, forKey: .children)
        posts = postObjects.map { $0.data }
    }
}

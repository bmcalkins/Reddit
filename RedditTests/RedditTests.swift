//
//  RedditTests.swift
//  RedditTests
//
//  Created by Folarin Williamson on 10/10/20.
//

import XCTest
@testable import Reddit

class RedditTests: XCTestCase {

    func testPostTableViewCell() throws {
        // Arrange
        
        // Act
        
        // Assert
    }
    
    func testRedditPostsAPIRequestExecuted() {
        let mockClient = MockURLSession()
        let sut = RedditPostsAPIRequest(subreddit: "abc", client: mockClient)
        sut.execute {_ in }
        XCTAssertTrue(mockClient.didExecute)
    }
    
    func testNavigator() {
        let mock = MockController()
        let sut = Navigator(rootController: mock)
        mock.delegate = sut
        mock.postTouched()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            guard let topController = sut.navigationController.topViewController else {
                XCTFail("")
                return
            }
            
            XCTAssertTrue(topController is WebViewController)
        }
    }
    
    func testActivityIndicator() {
        let mock = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.showInCenterOf(view: mock)
        XCTAssertTrue(activityIndicator.isAnimating)
        XCTAssertEqual(activityIndicator.superview, mock)
    }
    
    func testWebViewController() {
        let sut = WebViewController.create("nba")
        _ = sut.view
        XCTAssertNotNil(sut.view)
    }
}

extension RedditTests {
    class MockURLSession: HTTPClient {
        var inputRequest: URLRequest?
        var didExecute = false
        var result: Result<Data, Error>?
        
        func execute(_ request: APIRequest, completion: @escaping RequestCompletionHandler) {
            didExecute = true
            result.map(completion)
        }
    }
}

extension RedditTests {
    class MockController: UIViewController {
        var delegate: PostsViewControllerDelegate?
        
        func postTouched() {
            delegate?.selectedPost(with: "example")
        }
    }
}

extension RedditTests {
    class MockPostAPIRequest: APIRequest {
        var url: String = "https://www.reddit.com/r/.json"
        var method: RequestMethod = .get
        var client: HTTPClient = MockURLSession()
    }
}

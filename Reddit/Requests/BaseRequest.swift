//
//  BaseRequest.swift
//  Reddit
//
//  Created by Folarin Williamson on 10/10/20.
//

import Foundation

typealias RequestCompletionHandler = (Result<Data, Error>) -> Void

enum RequestError: Error {
    case dataMissing
    case parse
}

enum RequestMethod: String {
    case get = "GET"
}

// MARK: HTTPClient
protocol HTTPClient {
    func execute(_ request: APIRequest, completion: @escaping RequestCompletionHandler)
}

// MARK: URLSessionProtocol
typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

// MARK: APIRequest
protocol APIRequest {
    var url: String { get }
    var method: RequestMethod { get }
    var client: HTTPClient { get }
}

// MARK: BaseRequest
struct BaseRequest: HTTPClient {
    let session: URLSessionProtocol
    
    init(_ session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func execute(_ request: APIRequest, completion: @escaping RequestCompletionHandler) {
        guard let url = URL(string: request.url) else {
            fatalError("BaseRequest; unable to set url")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                if let responseError = error {
                    completion(.failure(responseError))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(RequestError.dataMissing))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}


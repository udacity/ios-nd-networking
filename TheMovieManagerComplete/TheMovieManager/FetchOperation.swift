//
//  FetchOperation.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// FIXME: rename from fetch... RequestOperation
// FIXME: make enum for HTTPMethod

// MARK: - HTTPMethod: String

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case update = "UPDATE"
    case delete = "DELETE"
}

// MARK: - FetchOperation: BaseOperation

class FetchOperation: BaseOperation {
    
    // MARK: Properties
    
    var fetchedData: Data?
    var fetchedResponse: URLResponse?
    var fetchedError: Error?
    
    private var urlComponents: URLComponents?
    private var headers: [String: String] = [:]
    private var httpMethod: HTTPMethod = .get
    private var httpBody: Data?
    private var task: URLSessionDataTask?
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    init(urlComponents: URLComponents, httpBody: Data? = nil) {
        self.urlComponents = urlComponents
        
        // FIXME: make fetch and post different?
        if let httpBody = httpBody {
            self.httpBody = httpBody
            httpMethod = .post
            headers["Content-Type"] = "application/json;charset=utf-8"
        }
        
        super.init()
        
        setup()
    }
    
    private func setup() {
        if let urlComponents = urlComponents, let url = urlComponents.url {
            var request = URLRequest(url: url)
            
            // add method
            request.httpMethod = httpMethod.rawValue
            
            // add headers
            for (key, value) in headers { request.addValue(value, forHTTPHeaderField: key) }
            
            // add http body
            if let httpBody = httpBody { request.httpBody = httpBody }
            
            task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                self.fetchedData = data
                self.fetchedResponse = response
                self.fetchedError = error
                self.state = .finished
            }
        }
        
        state = .ready
    }
    
    // MARK: Operation
    
    override func start() {
        guard !isCancelled else {
            return
        }
        
        state = .executing
        task?.resume()
    }
}

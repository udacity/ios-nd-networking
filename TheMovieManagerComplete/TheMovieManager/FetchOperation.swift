//
//  FetchOperation.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - FetchOperation: BaseOperation

class FetchOperation: BaseOperation {
    
    // MARK: Properties
    
    var fetchedData: Data?
    var fetchedResponse: URLResponse?
    var fetchedError: Error?
    
    private let request: URLRequest
    private var task: URLSessionDataTask?
    
    // MARK: Initialize
    
    init(request: URLRequest) {
        self.request = request
        super.init()
        setup()
    }
    
    private func setup() {
        task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.fetchedData = data
            self.fetchedResponse = response
            self.fetchedError = error
            self.state = .finished
        }                
    }
    
    // MARK: Operation
    
    override func start() {
        guard !isCancelled else { return }
        
        state = .executing
        task?.resume()
    }
}

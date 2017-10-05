//
//  ImageFetchOperation.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 10/3/17.
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
    
    func setup() {
        // setup fetch        
        task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.fetchedData = data
            self.fetchedResponse = response
            self.fetchedError = error
            self.state = .Finished
        }
        state = .Ready
    }
    
    // MARK: Operation
    
    override func start() {
        // start fetch
        state = .Executing
        task?.resume()
    }
}

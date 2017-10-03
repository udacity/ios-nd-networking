//
//  ImageFetchOperation.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - ImageFetchOperation: BaseOperation

class ImageFetchOperation: BaseOperation {
    
    // MARK: Properties
    
    var fetchedImageData: Data?
    var fetchedResponse: URLResponse?
    var fetchedError: Error?
    
    private let url: URL
    private var task: URLSessionDataTask?
    
    // MARK: Initialize
    
    init(url: URL) {
        self.url = url
        super.init()
        setup()
    }
    
    func setup() {
        // setup fetch
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            self.fetchedImageData = data
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

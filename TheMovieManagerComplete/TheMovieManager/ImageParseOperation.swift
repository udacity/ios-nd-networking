//
//  ImageParseOperation.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/10/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import Foundation

// MARK: - ImageParseOperation: BaseOperation

class ImageParseOperation: BaseOperation {
    
    // MARK: Properties
    
    var parsedImage: UIImage?
    var parsedError: Error?
    
    // MARK: Initialize
    
    override init() {
        super.init()
        state = .ready
    }
    
    // MARK: Operation
    
    override func start() {
        state = .executing
        
        // extract data from finished fetch operation
        if let imageFetchOp = dependencies.first as? FetchOperation {
            if let data = imageFetchOp.fetchedData {
                parsedImage = UIImage(data: data)
            }
            parsedError = imageFetchOp.fetchedError
        } else {
            print("unexpected operation dependency chain")
        }
        
        state = .finished
    }
}

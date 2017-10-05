//
//  FlickrParseOperation.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import Foundation

// MARK: - FlickrParseOperation: BaseOperation

class FlickrParseOperation: BaseOperation {
    
    // MARK: Properties
    
    var parsedResult: AnyObject?
    var parsedError: Error?
    
    let searchType: SearchType
    
    // MARK: Initialize
    
    init(searchType: SearchType) {
        self.searchType = searchType
        super.init()
        state = .ready
    }
    
    // MARK: Operation
    
    override func start() {
        state = .executing
        
        let fetchOp = dependencies.first as? FlickrFetchOperation
        if let error = fetchOp?.fetchedError {
            parsedError = error
        } else if let data = fetchOp?.fetchedData {
            parse(data: data)
        } else {
            print("unexpected operation dependency chain")
        }
        
        state = .finished
    }
    
    // MARK: Parse
    
    func parse(data: Data) {
        do {
            let decoder = JSONDecoder()
            switch searchType {
            case .location(_, _), .phrase(_):            
                let result = try decoder.decode(PhotoResponse.self, from: data)
                parsedResult = result as AnyObject
            }
        } catch let error {
            parsedError = error
        }
    }
}

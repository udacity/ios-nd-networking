//
//  ParseOperation.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - ParseOperation<T: Decodable>: BaseOperation

class ParseOperation<T: Decodable>: BaseOperation {
    
    // MARK: Properties
    
    var parsedResult: AnyObject?
    var parsedResponse: URLResponse?
    var parsedError: Error?
    
    let type: T.Type
    
    // MARK: Initialize
    
    init(type: T.Type) {
        self.type = type
        super.init()
        state = .ready
    }
    
    // MARK: Operation
    
    override func start() {
        guard !isCancelled else {
            return
        }
        
        state = .executing
        
        // grab (and parse) the results from fetch operation
        let fetchOp = dependencies.first as? FetchOperation
        parsedResponse = fetchOp?.fetchedResponse
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
            let result = try decoder.decode(type, from: data)
            parsedResult = result as AnyObject
        } catch let error {
            parsedError = error
        }
    }
}

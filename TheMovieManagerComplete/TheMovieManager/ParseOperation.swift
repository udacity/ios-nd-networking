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
    }
    
    // MARK: Operation
    
    override func start() {
        guard !isCancelled else { return }
        
        state = .executing
        
        if let fetchOp = dependencies.first as? FetchOperation {
            // capture response and error
            parsedResponse = fetchOp.fetchedResponse
            parsedError = fetchOp.fetchedError
            
            // decode data from finished fetch operation
            if let data = fetchOp.fetchedData {
                parseData(data)
            }
        }        
        
        state = .finished
    }
    
    // MARK: Parse
    
    func parseData(_ data: Data) {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(type, from: data)
            parsedResult = result as AnyObject
        } catch let error {
            parsedError = error
        }
    }
}

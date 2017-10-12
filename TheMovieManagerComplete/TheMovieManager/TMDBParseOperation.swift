//
//  TMDBParseOperation.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - TMDBParseOperation<T: Decodable>: ParseOperation<T>

class TMDBParseOperation<T: Decodable>: ParseOperation<T> {
    
    // MARK: Properties
    
    var error: TMDBError {
        if let errorResults = parsedResult as? ErrorResults {
            return .badRequestSemantics(errors: errorResults.errors)
        } else if let status = parsedResult as? Status {
            return .badRequest(status: status)
        } else {
            return .parseFailed(error: parsedError)
        }
    }
    
    // MARK: Parse
    
    override func parseData(_ data: Data) {
        do {
            let decoder = JSONDecoder()            
            if let parsedResponse = parsedResponse as? HTTPURLResponse {
                switch parsedResponse.statusCode {
                case 401:
                    parsedResult = try decoder.decode(Status.self, from: data) as AnyObject
                case 404:
                    parsedResult = try decoder.decode(Status.self, from: data) as AnyObject
                case 422:
                    parsedResult = try decoder.decode(ErrorResults.self, from: data) as AnyObject
                default: 
                    parsedResult = try decoder.decode(type, from: data) as AnyObject
                }
            }
        } catch let error {
            parsedError = error
        }
    }
}

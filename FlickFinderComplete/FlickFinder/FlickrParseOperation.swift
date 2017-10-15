//
//  FlickrParseOperation.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 10/13/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - FlickrParseOperation<T: Decodable>: ParseOperation<T>

class FlickrParseOperation<T: Decodable>: ParseOperation<T> {
    
    // MARK: Properties
    
    var error: FlickrError {
        if let status = parsedResult as? Status {
            return .failedReqest(status: status)
        } else {
            return .parseFailed(error: parsedError)
        }
    }
    
    // MARK: Parse
    
    override func parseData(_ data: Data) {
        let decoder = JSONDecoder()
        
        // NOTE: Normally, the status code can be used to determine the parsed type, but since Flickr returns different types for the same status codes, chained do/catch blocks are used.
        do {
            parsedResult = try decoder.decode(type, from: data)
        } catch {
            do {
                parsedResult = try decoder.decode(Status.self, from: data)
            } catch let error {
                parsedError = error
            }
        }
    }
}

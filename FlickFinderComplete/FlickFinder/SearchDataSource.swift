//
//  SearchDataSource.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import Foundation

// MARK: - SearchDataSource: NSObject

class SearchDataSource: NSObject {
    
    // MARK: Properties
    
    var photoResponse: PhotoResponse?
    
    // MARK: Search
    
    func searchWithType(_ type: SearchType, completion: @escaping (UIImage, String) -> (), error: @escaping (String) -> ()) {
        guard let request = FlickrAPI().search(withType: type) else {
            error("cannot create url for request")
            return
        }
        
        let fetch = FetchOperation(request: request)
        
        // FIXME: get random photo
        // FIXME: do the double search to get total number of pages...
        let parse = ParseOperation(searchType: type)
        parse.addDependency(fetch)
        parse.completionBlock = {
            if let photoResponse = parse.parsedResult as? PhotoResponse {
                self.photoResponse = photoResponse
                let photo = photoResponse.photos.photo[0]
                completion(photo.image, photo.title)
            } else {
                if let parsedError = parse.parsedError {
                    error("Could not retrieve data: \(parsedError)")
                }
                else {
                    error("Could not retrieve data")
                }
            }
        }
        
        let queue = OperationQueue()
        queue.addOperation(fetch)
        queue.addOperation(parse)
    }
}


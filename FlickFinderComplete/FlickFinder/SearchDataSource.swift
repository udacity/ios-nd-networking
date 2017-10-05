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
    
    let flickr = FlickrAPI()
    var photoResponse: PhotoResponse?
    
    // MARK: Search
    
    func searchWithType(_ type: SearchType, completion: @escaping (UIImage, String) -> (), error: @escaping (String) -> ()) {
        
        guard type.isValid else {
            error(type.invalidString)
            return
        }
        
        let fetchForPageNumber = FlickrFetchOperation(searchType: type)
        fetchForPageNumber.makeReady()
        
        let parseForPageNumber = FlickrParseOperation(searchType: type)
        parseForPageNumber.addDependency(fetchForPageNumber)
        
        let fetchForPhoto = FlickrFetchOperation(searchType: type)
        fetchForPhoto.addDependency(parseForPageNumber)
        
        let parseForPhoto = FlickrParseOperation(searchType: type)
        parseForPhoto.addDependency(fetchForPhoto)
        
        parseForPageNumber.completionBlock = {
            if let photoResponse = parseForPageNumber.parsedResult as? PhotoResponse {
                let randomPage = photoResponse.photoList.randomPage()
                fetchForPhoto.makeReady(withPageNumber: randomPage)
            } else {
                if let parsedError = parseForPageNumber.parsedError {
                    error("Could not retrieve data: \(parsedError)")
                }
                else {
                    error("Could not retrieve data")
                }
            }
        }
        
        parseForPhoto.completionBlock = {
            if let photoResponse = parseForPageNumber.parsedResult as? PhotoResponse {
                self.photoResponse = photoResponse
                let randomPhoto = photoResponse.photoList.randomPhoto()
                completion(randomPhoto.image, randomPhoto.title)
            } else {
                if let parsedError = parseForPageNumber.parsedError {
                    error("Could not retrieve data: \(parsedError)")
                }
                else {
                    error("Could not retrieve data")
                }
            }
        }
        
        let queue = OperationQueue()
        queue.addOperation(fetchForPageNumber)
        queue.addOperation(parseForPageNumber)
        queue.addOperation(fetchForPhoto)
        queue.addOperation(parseForPhoto)
    }
}


//
//  ImageDataSource.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import Foundation

// MARK: - ImageDataSource: NSObject

class ImageDataSource: NSObject {

    // MARK: Properties
    
    let imageJSONString = Constants.CatJSONString
    
    // MARK: Load

    func load(completionHandler: @escaping (UIImage, String) -> (), errorHandler: @escaping (String) -> ()) {
        loadFromNetwork(completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    // MARK: Network
    
    private func loadFromNetwork(completionHandler: @escaping (UIImage, String) -> (), errorHandler: @escaping (String) -> ()) {
        // use codable to construct preimage and url
        guard let preImage = imageJSONString.toPreImage(), let url = preImage.url else {
            errorHandler("cannot create preimage for request")
            return
        }
        
        // create fetch
        let fetch = ImageFetchOperation(url: url)
    
        // create parse (depends on fetch)
        let parse = ImageParseOperation()
        parse.addDependency(fetch)
        parse.completionBlock = {
            if let parsedImage = parse.parsedImage {
                completionHandler(parsedImage, preImage.title)
            } else {
                if let parsedError = parse.parsedError {
                    errorHandler("cannot parse image data - \(parsedError)")
                } else {
                    errorHandler("cannot parse image data")
                }
            }
        }
    
        // run operations on background queue
        let queue = OperationQueue()
        queue.addOperation(fetch)
        queue.addOperation(parse)
    }
}

//
//  ImageDataSource.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import Foundation

// MARK: - ImageDataSourceDelegate

protocol ImageDataSourceDelegate {
    func imageDataSourceDidFetchImage(imageDataSource: ImageDataSource)
    func imageDataSource(_ imageDataSource: ImageDataSource, didFailWithError error: Error)
}

// MARK: - ImageDataSource: NSObject

class ImageDataSource: NSObject {
    
    // MARK: Properties
    
    var image: UIImage?
    var title: String?
    var delegate: ImageDataSourceDelegate?
    
    // MARK: Fetch

    func fetchImage(of request: ImageRequest) {
        // get request
        guard let urlRequest = request.urlRequest else {
            self.delegate?.imageDataSource(self, didFailWithError: ImageRequestError.basic(description: "cannot get url request"))
            return
        }

        // create fetch
        let fetch = FetchOperation(request: urlRequest)
        
        // create parse (depends on fetch)
        let parse = ParseImageOperation()
        parse.addDependency(fetch)
        parse.completionBlock = {
            DispatchQueue.main.async {
                if let image = parse.parsedImage {
                    self.image = image
                    self.title = request.rawValue
                    self.delegate?.imageDataSourceDidFetchImage(imageDataSource: self)
                } else {
                    if let error = parse.parsedError {
                        self.delegate?.imageDataSource(self, didFailWithError: ImageRequestError.parseFailed(error: error))
                    } else {
                        self.delegate?.imageDataSource(self, didFailWithError: ImageRequestError.basic(description: "could not parse image data"))
                    }
                }
            }
        }
        
        // run operations on background queue
        let queue = OperationQueue()
        queue.addOperation(fetch)
        queue.addOperation(parse)
    }
}

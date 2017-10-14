//
//  ImageDataSource.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Constants

let catJSONString = """
{
"urlString": "https://upload.wikimedia.org/wikipedia/commons/4/4d/Cat_November_2010-1a.jpg",
"title": "Cat November 2010-1a"
}
"""

let dogJSONString = """
{
"urlString": "https://upload.wikimedia.org/wikipedia/commons/e/ec/Terrier_mixed-breed_dog.jpg",
"title": "Terrier mixed-breed dog"
}
"""

// MARK: - ImageDataSourceDelegate

protocol ImageDataSourceDelegate {
    func imageDataSourceDidFetchImage(imageDataSource: ImageDataSource)
    func imageDataSource(_ imageDataSource: ImageDataSource, didFailWithError error: Error)
}

// MARK: - ImageDataSource: NSObject

class ImageDataSource: NSObject {
    
    // MARK: Properties
    
    let preImage = catJSONString.toPreImage()
    var image: UIImage?    
    var delegate: ImageDataSourceDelegate?
    
    // MARK: Fetch

    func fetchImage() {
        // get url
        guard let url = preImage?.url else {
            self.delegate?.imageDataSource(self, didFailWithError: ImageRequestError.basic(description: "cannot create preimage for request"))
            return
        }
        
        // create fetch
        let fetch = FetchOperation(request: URLRequest(url: url))
        
        // create parse (depends on fetch)
        let parse = ParseImageOperation()
        parse.addDependency(fetch)
        parse.completionBlock = {
            DispatchQueue.main.async {
                if let image = parse.parsedImage {
                    self.image = image
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

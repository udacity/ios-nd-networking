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
    
    var image: Image
    
    // MARK: Initializer
    
    override init() {
        image = Image(title: Constants.Cat.Title, url: URL(string: Constants.Cat.URL))
        super.init()
    }
    
    // MARK: Data Source

    func load(completion: @escaping (UIImage, String) -> (), error: @escaping (String) -> ()) {
        guard let url = image.url else { return }
        
        let fetch = ImageFetchOperation(url: url)
        
        let parse = ImageParseOperation()
        parse.addDependency(fetch)
        parse.completionBlock = {
            if let parsedImage = parse.parsedImage {
                completion(parsedImage, self.image.title)
            } else {
                if let parsedError = parse.parsedError {
                    error("Could not retrieve data: \(parsedError)")
                } else {
                    error("Could not retrieve data")
                }
            }
        }
        
        // run operations on background queue
        let queue = OperationQueue()
        queue.addOperation(fetch)
        queue.addOperation(parse)
    }
}

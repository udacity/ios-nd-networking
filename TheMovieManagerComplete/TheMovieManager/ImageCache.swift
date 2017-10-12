//
//  ImageCache.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/11/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class ImageCache {
    
    // MARK: Properties
    
    private let imageCache = NSCache<NSString, UIImage>()
    private let queue = OperationQueue()
    
    // MARK: Load Image
    
    func loadImageWithURL(_ url: URL, completion: @escaping (UIImage?) -> ()) {
        guard let path = url.relativePath.removingPercentEncoding else {
            completion(nil)
            return
        }
        
        let key = NSString(string: path)
        
        // get image from cache, if exists
        if let imageFromCache = imageCache.object(forKey: key) {
            completion(imageFromCache)
            return
        }
        
        // otherwise, get image from network
        let request = URLRequest(url: url)
        let fetch = FetchOperation(request: request)
        let parse = ParseImageOperation()
        parse.addDependency(fetch)
        parse.completionBlock = {
            if let parsedImage = parse.parsedImage {
                self.imageCache.setObject(parsedImage, forKey: key) // add image to cache
            }
            
            DispatchQueue.main.async {
                completion(parse.parsedImage)
            }
        }
        
        queue.addOperation(fetch)
        queue.addOperation(parse)
    }
    
    // MARK: Shared Instance
    
    private init() {}
    
    static let shared = ImageCache()
}

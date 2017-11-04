//
//  Flickr.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Flickr

struct Flickr {
    
    // MARK: Constants
    
    static var apiKey = "API_KEY_HERE"
    static let scheme = "https"
    static let host = "api.flickr.com"
    static let path = "/services/rest"
    static let searchBBoxHalfWidth = 1.0
    static let searchBBoxHalfHeight = 1.0
    static let searchLatRange = (-90.0, 90.0)
    static let searchLonRange = (-180.0, 180.0)
    
    struct QueryKeys {
        static let searchMethod = "method"
        static let apiKey = "api_key"
        static let extras = "extras"
        static let responseFormat = "format"
        static let noJSONCallback = "nojsoncallback"
        static let safeSearch = "safe_search"
        static let text = "text"
        static let boundingBox = "bbox"
        static let page = "page"
    }
    
    struct QueryValues {
        static let searchMethod = "flickr.photos.search"
        static let noJSONCallback = "1" /* 1 means "disable callback" */
        static let safeSearch = "1" /* 1 mean "use safe search" */
        static let urls = "url_o,url_m"
        static let responseFormat = "json"
    }
    
    // MARK: Properties
    
    private let queue = OperationQueue()
    
    // MARK: Request
    
    func makeRequest<T>(_ request: FlickrRequest, type: T.Type, completion: ((FlickrParseOperation<T>) -> (Void))?) {
        guard let urlRequest = request.urlRequest else { return }
        
        // create fetch and parse operations
        let fetch = FetchOperation(request: urlRequest)
        let parse = FlickrParseOperation(type: type)
        parse.addDependency(fetch)
        parse.completionBlock = {
            DispatchQueue.main.async {
                completion?(parse)
            }
        }
        
        // run operations on queue
        queue.addOperation(fetch)
        queue.addOperation(parse)
    }
    
    // MARK: Images
    
    func getImageFor(photo: Photo, completion: @escaping (UIImage?) -> ()) {
        guard let url = photo.imageURL else { return }
        
        let request = URLRequest(url: url)
        let fetch = FetchOperation(request: request)
        let parse = ParseImageOperation()
        parse.addDependency(fetch)
        parse.completionBlock = {
            if let parsedImage = parse.parsedImage {
                DispatchQueue.main.async {
                    completion(parsedImage)
                }
            }
        }
        
        queue.addOperation(fetch)
        queue.addOperation(parse)
    }
    
    // MARK: Helpers
    
    func bboxStringWith(latitude: Double, longitude: Double) -> String {
        let minimumLon = max(longitude - Flickr.searchBBoxHalfWidth, Flickr.searchLonRange.0)
        let minimumLat = max(latitude - Flickr.searchBBoxHalfHeight, Flickr.searchLatRange.0)
        let maximumLon = min(longitude + Flickr.searchBBoxHalfWidth, Flickr.searchLonRange.1)
        let maximumLat = min(latitude + Flickr.searchBBoxHalfHeight, Flickr.searchLatRange.1)
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
    }
    
    // MARK: Shared Instance
    
    private init() {
        // load api key
        if let secretsURL = Bundle.main.url(forResource: "Secrets", withExtension: "plist"), let data = try? Data(contentsOf: secretsURL), let secrets = try? PropertyListDecoder().decode(Secrets.self, from: data) {
            Flickr.apiKey = secrets.flickrAPIKey
        }
    }
    
    static let shared = Flickr()
}

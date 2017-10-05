//
//  FlickrAPI.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - SearchType

enum SearchType {
    case location(Double, Double)
    case phrase(String)
    
    var isValid: Bool {
        switch self {
        case .location(let latitude, let longitude):
            return latitude.inRange(FlickrAPI.searchLatRange) && longitude.inRange(FlickrAPI.searchLonRange)
        case .phrase(let text):
            return !text.isEmpty
        }
    }
    
    var invalidString: String {
        switch self {
        case .location(_, _):
            return "Lat should be [-90, 90].\nLon should be [-180, 180]."
        case .phrase(_):
            return "Phrase is empty."
        }
    }
    
    var bboxString: String {
        switch self {
        case .location(let latitude, let longitude):
            let minimumLon = max(longitude - FlickrAPI.searchBBoxHalfWidth, FlickrAPI.searchLonRange.0)
            let minimumLat = max(latitude - FlickrAPI.searchBBoxHalfHeight, FlickrAPI.searchLatRange.0)
            let maximumLon = min(longitude + FlickrAPI.searchBBoxHalfWidth, FlickrAPI.searchLonRange.1)
            let maximumLat = min(latitude + FlickrAPI.searchBBoxHalfHeight, FlickrAPI.searchLatRange.1)
            return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
        default:
            return ""
        }
    }
}

// MARK: - FlickrAPI

struct FlickrAPI {
    
    // MARK: Constants
    
    static let scheme = "https"
    static let host = "api.flickr.com"
    static let path = "/services/rest"
    static let searchBBoxHalfWidth = 1.0
    static let searchBBoxHalfHeight = 1.0
    static let searchLatRange = (-90.0, 90.0)
    static let searchLonRange = (-180.0, 180.0)
    
    struct Keys {
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
    
    struct Values {
        static let searchMethod = "flickr.photos.search"
        static let apiKey = "API_KEY_HERE"
        static let responseFormat = "json"
        static let noJSONCallback = "1" /* 1 means "disable callback" */
        static let urls = "url_o,url_m"
        static let safeSearch = "1" /* 1 mean "use safe search" */
    }
    
    // MARK: Helper
    
    func urlWithQueryItems(_ items: [String:Any]) -> URL? {
        var components = URLComponents()
        components.scheme = FlickrAPI.scheme
        components.host = FlickrAPI.host
        components.path = FlickrAPI.path
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in items {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        
        return components.url
    }
}

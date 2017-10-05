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
        static let apiKey = "bb90aa6f358ecb3404b6c9c1684d6aad"
        static let responseFormat = "json"
        static let noJSONCallback = "1" /* 1 means "disable callback" */
        static let urls = "url_o,url_m"
        static let safeSearch = "1" /* 1 mean "use safe search" */
    }
    
    // MARK: Search
    
    func search(withType type: SearchType) -> URLRequest? {
        
        var queryItems: [String:Any] = [
            FlickrAPI.Keys.searchMethod: FlickrAPI.Values.searchMethod,
            FlickrAPI.Keys.apiKey: FlickrAPI.Values.apiKey,
            FlickrAPI.Keys.safeSearch: FlickrAPI.Values.safeSearch,
            FlickrAPI.Keys.extras: FlickrAPI.Values.urls,
            FlickrAPI.Keys.responseFormat: FlickrAPI.Values.responseFormat,
            FlickrAPI.Keys.noJSONCallback: FlickrAPI.Values.noJSONCallback
        ]
        
        switch type {
        case .location(let latitude, let longitude):
            queryItems[Constants.FlickrParameterKeys.BoundingBox] = bboxString(latitude: latitude, longitude: longitude)
        case .phrase(let text):
            queryItems[Constants.FlickrParameterKeys.Text] = text
        }
        
        guard let url = urlWithQueryItems(queryItems) else { return nil }
        return URLRequest(url: url)        
    }
    
    // MARK: Helpers
    
    private func bboxString(latitude: Double, longitude: Double) -> String {
        let minimumLon = max(longitude - FlickrAPI.searchBBoxHalfWidth, FlickrAPI.searchLonRange.0)
        let minimumLat = max(latitude - FlickrAPI.searchBBoxHalfHeight, FlickrAPI.searchLatRange.0)
        let maximumLon = min(longitude + FlickrAPI.searchBBoxHalfWidth, FlickrAPI.searchLonRange.1)
        let maximumLat = min(latitude + FlickrAPI.searchBBoxHalfHeight, FlickrAPI.searchLatRange.1)
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
    }
    
    private func urlWithQueryItems(_ items: [String:Any]) -> URL? {
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
    
    // isTextFieldValid(latitudeTextField, forRange: Constants.Flickr.SearchLatRange) && isTextFieldValid(longitudeTextField, forRange: Constants.Flickr.SearchLonRange)
    
//    func isTextFieldValid(_ textField: UITextField, forRange: (Double, Double)) -> Bool {
//        if let value = Double(textField.text!), !textField.text!.isEmpty {
//            return isValueInRange(value, min: forRange.0, max: forRange.1)
//        } else {
//            return false
//        }
//    }
//
//    func isValueInRange(_ value: Double, min: Double, max: Double) -> Bool {
//        return !(value < min || value > max)
//    }
}


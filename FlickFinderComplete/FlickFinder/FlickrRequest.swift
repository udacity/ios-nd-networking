//
//  FlickrRequest.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 10/13/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - FlickrRequest

enum FlickrRequest {
    case searchPhotosByLocation(latitude: Double, longitude: Double, page: Int?)
    case searchPhotosByPhrase(String, page: Int?)
    
    // MARK: URL Request
    
    var urlRequest: URLRequest? {
        var request: URLRequest?
        
        if let url = components.url {
            request = URLRequest(url: url)
        }
        
        return request
    }
    
    // MARK: Components
    
    var components: URLComponents {
        var components = URLComponents()
        components.scheme = Flickr.scheme
        components.host = Flickr.host
        components.path = Flickr.path
        components.queryItems = queryItems
        return components
    }
    
    // MARK: Query Items
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        // items needed by both searches
        items.append(URLQueryItem(name: Flickr.QueryKeys.searchMethod, value: Flickr.searchMethod))
        items.append(URLQueryItem(name: Flickr.QueryKeys.apiKey, value: Flickr.apiKey))
        items.append(URLQueryItem(name: Flickr.QueryKeys.safeSearch, value: Flickr.safeSearch))
        items.append(URLQueryItem(name: Flickr.QueryKeys.extras, value: Flickr.urls))
        items.append(URLQueryItem(name: Flickr.QueryKeys.responseFormat, value: Flickr.responseFormat))
        items.append(URLQueryItem(name: Flickr.QueryKeys.noJSONCallback, value: Flickr.noJSONCallback))
        
        switch self {
        case .searchPhotosByLocation(_, _, let pageNumber), .searchPhotosByPhrase(_, let pageNumber):
            if let pageNumber = pageNumber {
                items.append(URLQueryItem(name: Flickr.QueryKeys.page, value: "\(pageNumber)"))
            }
        }
        
        switch self {
        case .searchPhotosByLocation(let latitude, let longitude, _):
            let bboxString = Flickr.shared.bboxStringWith(latitude: latitude, longitude: longitude)
            items.append(URLQueryItem(name: Flickr.QueryKeys.boundingBox, value: bboxString))
        case .searchPhotosByPhrase(let phrase, _):
            items.append(URLQueryItem(name: Flickr.QueryKeys.text, value: phrase))
        }
        
        return items
    }
    
    // MARK: Errors
    
    var isValid: Bool {
        switch self {
        case .searchPhotosByLocation(let latitude, let longitude, _):
            return latitude.inRange(Flickr.searchLatRange) && longitude.inRange(Flickr.searchLonRange)
        case .searchPhotosByPhrase(let phrase, _):
            return !phrase.isEmpty
        }
    }
    
    var invalidString: String {
        switch self {
        case .searchPhotosByLocation:
            return "Lat should be [-90, 90].\nLon should be [-180, 180]."
        case .searchPhotosByPhrase:
            return "Phrase is empty."
        }
    }
}

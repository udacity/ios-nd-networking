//
//  FlickrError.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 10/13/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - FlickrError: Error

enum FlickrError: Error {
    case emptyPhrase
    case invalidLocation
    case failedRequest(status: Status)
    case parseFailed(error: Error?)
}

// MARK: - FlickrError: LocalizedError

extension FlickrError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyPhrase:
            return "Phrase Empty."
        case .invalidLocation:
            return "Lat should be [-90, 90].\nLon should be [-180, 180]."
        case .failedRequest(let status):
            return status.message
        case .parseFailed(let error):
            return error?.localizedDescription
        }
    }
}

// MARK: - FlickrError: CustomNSError

extension FlickrError: CustomNSError {
    public static var errorDomain: String {
        return "Flickr"
    }
    
    // MARK: Documentation at flickr.com/services/api/flickr.photos.search.html
    
    public var errorCode: Int {
        switch self {
        case .failedRequest(let status):
            return status.code
        case .emptyPhrase:
            return 150
        case .invalidLocation:
            return 151
        case .parseFailed:
            return 152
        }
    }
}

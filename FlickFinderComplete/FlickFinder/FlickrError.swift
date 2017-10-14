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
    case invalidSearch(description: String)
    case failedReqest(status: Status)
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
        case .invalidSearch(let description):
            return description
        case .failedReqest(let status):
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
}


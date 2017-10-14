//
//  ImageRequestError.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 10/14/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - ImageRequestError: Error

enum ImageRequestError: Error {
    case parseFailed(error: Error?)
    case basic(description: String)
}

// MARK: - ImageRequestError: LocalizedError

extension ImageRequestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .parseFailed(let error):
            return error?.localizedDescription ?? "parsing failed"
        case .basic(let description):
            return description
        }
    }
}

// MARK: - ImageRequestError: CustomNSError

extension ImageRequestError: CustomNSError {
    public static var errorDomain: String {
        return "ImageRequest"
    }
}

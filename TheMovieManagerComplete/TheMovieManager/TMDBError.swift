//
//  TMDBError.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/12/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - TMDBError: Error

enum TMDBError: Error {
    case badRequest(status: Status)
    case badRequestSemantics(errors: [String])
    case parseFailed(error: Error?)
    case unexpectedStatusCode(Int)
    case basic(description: String)
}

// MARK: - TMDBError: LocalizedError

extension TMDBError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badRequest(let status):
            return status.message
        case .badRequestSemantics(let errors):
            return "\(errors)"
        case .parseFailed(let error):
            return error?.localizedDescription ?? "parsing failed"
        case .unexpectedStatusCode(let code):
            return "unexpected status code \(code)"
        case .basic(let description):
            return description
        }
    }
}

// MARK: - TMDBError: CustomNSError

extension TMDBError: CustomNSError {
    public static var errorDomain: String {
        return "TMDB"
    }
    
    // MARK: Documentation at themoviedb.org/documentation/api/status-codes
    
    public var errorCode: Int {
        switch self {
        case .badRequest(let status):
            return status.code
        case .badRequestSemantics:
            return 40
        case .parseFailed:
            return 41
        case .unexpectedStatusCode:
            return 42
        case .basic:
            return 43
        }
    }
}

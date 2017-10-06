//
//  RequestToken.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - RequestToken: Codable

struct RequestToken: Codable {
    
    // MARK: Properties
    
    let expiresAt: String
    let isValid: Bool
    let token: String
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case expiresAt = "expires_at"
        case isValid = "success"
        case token = "request_token"        
    }
}

//
//  SessionID.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - SessionID: Codable

struct SessionID: Codable {
    
    // MARK: Properties
    
    let id: String
    let isValid: Bool
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case id = "session_id"
        case isValid = "success"
    }
}

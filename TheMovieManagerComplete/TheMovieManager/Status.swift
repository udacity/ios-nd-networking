//
//  Status.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: Documentation at themoviedb.org/documentation/api/status-codes

// MARK: - Status: Codable

struct Status: Codable {
    
    // MARK: Properties
    
    let code: Int
    let message: String
    let success: Bool?
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case code = "status_code"
        case message = "status_message"
        case success
    }
}

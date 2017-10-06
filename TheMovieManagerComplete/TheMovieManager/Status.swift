//
//  Status.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - Status: Codable

struct Status: Codable {
    
    // MARK: Properties
    
    let statusCode: Int
    let statusMessage: String
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

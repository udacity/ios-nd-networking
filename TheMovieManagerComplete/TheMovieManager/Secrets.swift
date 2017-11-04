//
//  Secrets.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 11/4/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - Secrets: Codable

struct Secrets: Codable {
    
    // MARK: Properites
    
    let theMovieDBAPIKey: String
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case theMovieDBAPIKey = "TheMovieDBAPIKey"
    }
}

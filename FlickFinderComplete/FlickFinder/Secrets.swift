//
//  Secrets.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 11/4/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - Secrets: Codable

struct Secrets: Codable {
    
    // MARK: Properites
    
    let flickrAPIKey: String
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case flickrAPIKey = "FlickrAPIKey"
    }
}

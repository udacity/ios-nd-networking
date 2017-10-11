//
//  Config.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - Config

struct Config: Codable {
    
    // MARK: Properties
    
    let images: ImageConfig
    let changeKeys: [String]
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case images
        case changeKeys = "change_keys"
    }
}

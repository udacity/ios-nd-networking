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
    
    // MARK: - ImageConfig: Codable
    
    struct ImageConfig: Codable {
        
        // MARK: Properties
        
        let baseURL: String
        let secureBaseURL: String
        let backdropSizes: [String]
        let logoSizes: [String]
        let posterSizes: [String]
        let profileSizes: [String]
        let stillSizes: [String]
        let changeKeys: [String]
        
        // MARK: Keys
        
        enum CodingKeys: String, CodingKey {
            case baseURL = "base_url"
            case secureBaseURL = "secure_base_url"
            case backdropSizes = "backdrop_sizes"
            case logoSizes = "logo_sizes"
            case posterSizes = "poster_sizes"
            case profileSizes = "profile_sizes"
            case stillSizes = "still_sizes"
            case changeKeys = "change_keys"
        }
    }
}

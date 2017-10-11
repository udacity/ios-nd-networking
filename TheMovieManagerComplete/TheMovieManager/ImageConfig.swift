//
//  ImageConfig.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/10/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

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
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case secureBaseURL = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
    
    // MARK: Size
    
    func sizeForImageType(_ imageType: ImageType) -> String? {
        switch imageType {
        case .backdrop(let type):
            return backdropSizes[type.rawValue]
        case .logo(let type):
            return logoSizes[type.rawValue]
        case .poster(let type):
            return posterSizes[type.rawValue]
        case .profile(let type):
            return profileSizes[type.rawValue]
        case .still(let type):
            return stillSizes[type.rawValue]
        }
    }
}

//
//  Account.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - Account: Codable

struct Account: Codable {

    // MARK: Properties
    
    let avatar: Avatar
    let id: Int
    let languageCode: String
    let countryCode: String
    let name: String
    let includeAdult: Bool
    let username: String
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case id
        case languageCode = "iso_639_1"
        case countryCode = "iso_3166_1"
        case name
        case includeAdult = "include_adult"
        case username
    }
}

// MARK: - Avatar: Codable

struct Avatar: Codable {
 
    // MARK: Properties
    
    let gravatar: Gravatar
}

// MARK: - Gravatar: Codable

struct Gravatar: Codable {
    
    // MARK: Properties
    
    let hash: String
}

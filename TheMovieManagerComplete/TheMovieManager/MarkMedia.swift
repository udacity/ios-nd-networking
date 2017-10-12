//
//  MarkMedia.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - MediaType: String, Codable

enum MediaType: String, Codable {
    case movie, tv
}

// MARK: - MarkMedia: Codable

struct MarkMedia: Codable {
    
    // MARK: Properties
    
    let type: MediaType
    let id: Int
    var favorite: Bool?
    var watchlist: Bool?
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case type = "media_type"
        case id = "media_id"
        case favorite
        case watchlist
    }
}

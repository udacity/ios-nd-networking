//
//  MarkMedia.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - MarkMedia: Codable

struct MarkMedia: Codable {
    
    // MARK: Properties
    
    let mediaType: String
    let mediaID: Int
    let favorite: Bool?
    let watchlist: Bool?
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaID = "media_id"
        case favorite
        case watchlist
    }
}

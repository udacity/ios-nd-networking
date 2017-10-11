//
//  MovieState.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/9/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - MovieState: Codable

struct MovieState: Codable {
    
    // MARK: Properties
    
    let id: Int
    var isFavorite: Bool
    var isWatchlist: Bool
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case id
        case isFavorite = "favorite"
        case isWatchlist = "watchlist"
    }
}

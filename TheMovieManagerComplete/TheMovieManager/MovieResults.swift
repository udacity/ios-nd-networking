//
//  MovieResults.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - MovieResults: Codable

struct MovieResults: Codable {
    
    // MARK: Properties
    
    let movies: [Movie]
    let page: Int    
    let totalPages: Int
    let totalResults: Int
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

//
//  Movie.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15.
//  Copyright © 2015 Jarrod Parkes. All rights reserved.
//

// MARK: - Movie: Codable

struct Movie: Codable {
    
    // MARK: Properties
    
    let backdropPath: String?
    let genres: [Int]
    let hasVideo: Bool
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let popularity: Double
    let title: String
    let voteAverage: Double
    let voteCount: Int

    var releaseYear: String { return String(releaseDate.prefix(4)) }
    var detailedTitle: String { return "\(title) (\(releaseYear))" }
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genres = "genre_ids"
        case hasVideo = "video"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case popularity
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

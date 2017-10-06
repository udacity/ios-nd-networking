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
    let isAdultFilm: Bool
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let popularity: Double
    let title: String
    let voteAverage: Double
    let voteCount: Int
    
    var releaseYear: String {
        return String(releaseDate.prefix(4))
    }
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genres = "genre_ids"
        case hasVideo = "video"
        case id
        case isAdultFilm = "adult"
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
    
    // MARK: Initializers
    
    // construct a Movie from a dictionary
//    init(dictionary: [String:AnyObject]) {
//        title = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as! String
//        id = dictionary[TMDBClient.JSONResponseKeys.MovieID] as! Int
//        posterPath = dictionary[TMDBClient.JSONResponseKeys.MoviePosterPath] as? String
//
////        if let releaseDateString = dictionary[TMDBClient.JSONResponseKeys.MovieReleaseDate] as? String, releaseDateString.isEmpty == false {
////            //releaseYear = String(releaseDateString.prefix(4))
////        } else {
////            //releaseYear = ""
////        }
//    }
    
//    static func moviesFromResults(_ results: [[String:AnyObject]]) -> [Movie] {
//
//        var movies = [Movie]()
//
//        // iterate through array of dictionaries, each Movie is a dictionary
//        for result in results {
//            movies.append(Movie(dictionary: result))
//        }
//
//        return movies
//    }
}

// MARK: - Movie: Equatable

extension Movie: Equatable {}

func ==(lhs: Movie, rhs: Movie) -> Bool {
    return lhs.id == rhs.id
}

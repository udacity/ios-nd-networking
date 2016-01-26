//
//  Movie.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - Movie

struct Movie {
    
    // MARK: Properties
    
    let title: String
    let id: Int
    let posterPath: String?
    
    // MARK: Initializers
    
    init(dictionary: [String:AnyObject]) {
        title = dictionary[Constants.TMDBResponseKeys.Title] as! String
        id = dictionary[Constants.TMDBResponseKeys.ID] as! Int
        posterPath = dictionary[Constants.TMDBResponseKeys.PosterPath] as? String
    }
    
    static func moviesFromResults(results: [[String:AnyObject]]) -> [Movie] {
        
        var movies = [Movie]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            movies.append(Movie(dictionary: result))
        }
        
        return movies
    }
    
}

// MARK: - Movie: Equatable

extension Movie: Equatable {}

func ==(lhs: Movie, rhs: Movie) -> Bool {
    return lhs.id == rhs.id
}
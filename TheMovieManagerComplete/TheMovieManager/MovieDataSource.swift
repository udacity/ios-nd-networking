//
//  MovieDataSource.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import Foundation

// MARK: - ListType

enum ListType {
    case favorite, watchlist
}

// MARK: - MovieDataSourceDelegate

protocol MovieDataSourceDelegate {
    func movieDataSourceDidFetchMovieState(movieDataSource: MovieDataSource)
    func movieDataSourceDidFetchPoster(movieDataSource: MovieDataSource)
    func movieDataSource(_ movieDataSource: MovieDataSource, didMarkMovieOnList listType: ListType)
    func movieDataSource(_ movieDataSource: MovieDataSource, didFailWithError error: Error)
}

// MARK: - MovieDataSource: NSObject

class MovieDataSource: NSObject {
    
    // MARK: Properties
    
    var state: MovieState?
    var movie: Movie
    var posterImage: UIImage?
    var delegate: MovieDataSourceDelegate?
    
    // MARK: Initializer
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    // MARK: Get
    
    func fetchState() {
        TMDB.shared.makeRequest(.getMovieState(id: movie.id), type: MovieState.self) { (parse) in
            if let state = parse.parsedResult as? MovieState {
                self.state = state
                self.delegate?.movieDataSourceDidFetchMovieState(movieDataSource: self)
            } else {
                self.delegate?.movieDataSource(self, didFailWithError: parse.error)
            }
        }
    }
    
    func fetchPoster() {
        if let posterPath = movie.posterPath {
            TMDB.shared.getImageWith(type: .poster(size: .large), path: posterPath, completion: { (image) in
                self.posterImage = image
                self.delegate?.movieDataSourceDidFetchPoster(movieDataSource: self)
            })
        }                
    }
    
    // MARK: Post
    
    func markMovie(forListType listType: ListType, value: Bool) {
        var markMedia = MarkMedia(type: .movie, id: movie.id, favorite: nil, watchlist: nil)
        let request: TMDBRequest?
        
        switch listType {
        case .favorite:
            markMedia.favorite = value
            request = .markFavorite(mark: markMedia)
        case .watchlist:
            markMedia.watchlist = value
            request = .markWatchlist(mark: markMedia)
        }
        
        if let request = request {
            markMovie(withRequest: request, value: value)
        }
    }
    
    private func markMovie(withRequest request: TMDBRequest, value: Bool) {
        TMDB.shared.makeRequest(request, type: Status.self) { (parse) in
            if let status = parse.parsedResult as? Status {
                let statusCode = status.code
                if statusCode == 1 || statusCode == 12 || statusCode == 13 {
                    switch request {
                    case .markFavorite:
                        self.state?.isFavorite = value
                        self.delegate?.movieDataSource(self, didMarkMovieOnList: .favorite)
                    case .markWatchlist:
                        self.state?.isWatchlist = value
                        self.delegate?.movieDataSource(self, didMarkMovieOnList: .watchlist)
                    default:
                        break
                    }
                } else {
                    self.delegate?.movieDataSource(self, didFailWithError: TMDBError.basic(description: "unexpected status code \(statusCode)"))
                }
            } else {
                self.delegate?.movieDataSource(self, didFailWithError: parse.error)
            }
        }
    }
}

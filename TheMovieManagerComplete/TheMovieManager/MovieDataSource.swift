//
//  MovieDataSource.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import Foundation

/* REMAINING WORK */
// FIXME: rename urlRequest that belongs to the TMDBRequest object? or rename object?
// FIXME: data sources should not expose that they are using the network...
// FIXME: move login methods in TMDB to a login data source?

// MARK: - MovieDataSourceDelegate

protocol MovieDataSourceDelegate {
    func didFetchMovieState()
    func didFetchPoster()
    func didAddMovieToFavorites()
    func didAddMovieToWatchlist()
    func didFailWithError(_ error: Error)
}

// MARK: - MovieDataSource

protocol MovieDataSource {
    var delegate: MovieDataSourceDelegate? { get set }
    
    func fetch()
    func markMovieForList(_ listType: ListType, toValue value: Bool)
}

// MARK: - ListType

enum ListType {
    case favorite, watchlist
}

// MARK: - MovieDataSourceX: NSObject

class MovieDataSourceX: NSObject {
    
    // MARK: Properties
    
    private var state: MovieState?
    var movie: Movie
    var posterImage: UIImage?
    var isWatchlist: Bool { return state?.isWatchlist ?? false }
    var isFavorite: Bool { return state?.isFavorite ?? false }
    
    // MARK: Initializer
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    // MARK: Load
    
    func loadData(completion: @escaping () -> (), error: @escaping (Error) -> ()) {
        TMDB.shared.makeRequest(request: .movieState(id: movie.id), type: MovieState.self) { (parse) in
            if let state = parse.parsedResult as? MovieState {
                self.state = state
                completion()
            } else {
                error(parse.error)
            }
        }
    }
    
    func loadPoster(completion: @escaping () -> ()) {        
        if let posterPath = movie.posterPath {
            TMDB.shared.getImageOfType(.poster(size: .large), path: posterPath, completion: { (image) in
                self.posterImage = image
                completion()
            })
        }
    }
    
    // MARK: Post
    
    func markForList(_ listType: ListType, toValue value: Bool, completion: @escaping () -> (), error: @escaping (Error) -> ()) {
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
            markMovieWithRequest(request, value: value, completion: completion, error: error)
        }
    }
    
    private func markMovieWithRequest(_ request: TMDBRequest, value: Bool, completion: @escaping () -> (), error: @escaping (Error) -> ()) {
        TMDB.shared.makeRequest(request: request, type: Status.self) { (parse) in
            if let status = parse.parsedResult as? Status {
                let statusCode = status.code
                if statusCode == 1 || statusCode == 12 || statusCode == 13 {
                    switch request {
                    case .markFavorite:
                        self.state?.isFavorite = value
                    case .markWatchlist:
                        self.state?.isWatchlist = value
                    default:
                        break
                    }
                    completion()
                } else {
                    error(TMDBError.basic(description: "unexpected status code \(statusCode)"))
                }
            } else {
                error(parse.error)
            }
        }
    }
}

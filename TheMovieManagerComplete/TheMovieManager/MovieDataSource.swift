//
//  MovieDataSource.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import Foundation

// FIXME: move somewhere else? (same place as HTTPMethod)
// FIXME: rename the load method to make sense

enum ListType {
    case favorite, watchlist
}

// MARK: - MovieDataSource: NSObject

class MovieDataSource: NSObject {
    
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
    
    func load(completion: @escaping () -> (), error: @escaping (String) -> ()) {
        let queue = OperationQueue()
        let finish = Operation()
        let config = TMDB.shared.config
        
        // get poster image
        if let posterPath = movie.posterPath, let imageConfig = config?.images, let size = imageConfig.sizeForImageType(.poster(.large)) {
            let request = TMDBRequest.getImage(size, posterPath)
            let fetch = FetchOperation(urlComponents: request.components)
            let parse = ImageParseOperation()
            parse.addDependency(fetch)
            parse.completionBlock = {
                self.posterImage = parse.parsedImage
            }
            
            finish.addDependency(parse)
            queue.addOperation(fetch)
            queue.addOperation(parse)
        }
        
        // get movie state
        let requestMovieState = TMDBRequest.movieState(movie.id)
        let fetch = FetchOperation(urlComponents: requestMovieState.components)
        let parse = TMDBParseOperation(type: MovieState.self)
        parse.addDependency(fetch)
        parse.completionBlock = {
            if let state = parse.parsedResult as? MovieState {
                self.state = state
            }
        }
        
        // specify finish behavior
        finish.addDependency(parse)
        finish.completionBlock = {
            DispatchQueue.main.async {
                if let _ = self.state, let _ = self.posterImage, finish.dependencies.count == 2 {
                    completion()
                } else if let _ = self.state {
                    completion()
                } else {
                    error("didn't work")
                }
            }
        }
        
        queue.addOperation(finish)
        queue.addOperation(fetch)
        queue.addOperation(parse)
    }
    
    // MARK: Post
    
    func markForList(_ listType: ListType, toValue value: Bool, completion: @escaping () -> (), error: @escaping (String) -> ()) {
        var markMedia = MarkMedia(type: .movie, id: movie.id, favorite: nil, watchlist: nil)
        let request: TMDBRequest!
        
        switch listType {
        case .favorite:
            markMedia.favorite = value
            request = TMDBRequest.markFavorite(markMedia)
        case .watchlist:
            markMedia.watchlist = value
            request = TMDBRequest.markWatchlist(markMedia)
        }
        
        markMovieWithRequest(request, value: value, completion: completion, error: error)
    }
    
    private func markMovieWithRequest(_ request: TMDBRequest, value: Bool, completion: @escaping () -> (), error: @escaping (String) -> ()) {
        
        let fetch = FetchOperation(urlComponents: request.components, httpBody: request.httpBody)

        let parse = TMDBParseOperation(type: Status.self)
        parse.addDependency(fetch)
        parse.completionBlock = {
            DispatchQueue.main.async {
                if let status = parse.parsedResult as? Status {
                    let statusCode = status.code
                    if statusCode == 1 || statusCode == 12 || statusCode == 13 {
                        switch request {
                        case .markFavorite(_):
                            self.state?.isFavorite = value
                        case .markWatchlist(_):
                            self.state?.isWatchlist = value
                        default:
                            break
                        }
                        completion()
                    } else {
                        error("unexpected status code: \(statusCode)")
                    }
                } else {
                    TMDB.shared.handle(parse.parsedResult, parsedError: parse.parsedError, error: error)
                }
            }
        }

        let queue = OperationQueue()
        queue.addOperation(fetch)
        queue.addOperation(parse)
    }
}

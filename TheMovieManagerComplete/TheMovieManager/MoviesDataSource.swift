//
//  MoviesDataSource.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import Foundation

// MARK: - MovieCellType

enum MovieCellType {
    case list, search
}

// MARK: - MoviesDataSourceDelegate

protocol MoviesDataSourceDelegate {
    func moviesDataSourceDidFetchMovies(moviesDataSource: MoviesDataSource)
    func moviesDataSource(_ moviesDataSource: MoviesDataSource, didFailWithError error: Error)
}

// MARK: - MoviesDataSource: NSObject

class MoviesDataSource: NSObject {
    
    // MARK: Properties
    
    let cellType: MovieCellType
    var movies = [Movie]()
    var delegate: MoviesDataSourceDelegate?
    
    // MARK: Initializer
    
    init(cellType: MovieCellType) {
        self.cellType = cellType
    }
    
    // MARK: Get
    
    func fetchList(withRequest request: TMDBRequest) {        
        TMDB.shared.makeRequest(request, type: MovieResults.self) { (parse) in
            guard !parse.isCancelled else { return }
            
            if let movieResults = parse.parsedResult as? MovieResults {
                self.movies = movieResults.movies
                self.delegate?.moviesDataSourceDidFetchMovies(moviesDataSource: self)
            } else {
                self.delegate?.moviesDataSource(self, didFailWithError: parse.error)                
            }
        }
    }
    
    // MARK: Helpers
    
    func cancelSearch() {
        TMDB.shared.cancelSearch()
    }
}

// MARK: - MoviesDataSource: UITableViewDataSource

extension MoviesDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellType {
        case .search:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSearchCell", for: indexPath)
            let movie = movies[indexPath.row]
            cell.textLabel?.text = "\(movie.title) (\(movie.releaseYear))"
            return cell
        case .list:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath)
            let movie = movies[indexPath.row]
            
            cell.textLabel?.text = movie.title
            cell.imageView?.image = UIImage(named: "Film")
            cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            
            if let posterPath = movie.posterPath {
                TMDB.shared.getImageWith(type: .poster(size: .small), path: posterPath) { (image) in
                    cell.imageView?.image = image
                }
            }

            return cell
        }
    }        
}

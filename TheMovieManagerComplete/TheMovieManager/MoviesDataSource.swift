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

// MARK: - MoviesDataSource: NSObject

class MoviesDataSource: NSObject {
    
    // MARK: Properties
    
    private let cellType: MovieCellType
    private var movies = [Movie]()
    
    // MARK: Initializer
    
    init(cellType: MovieCellType) {
        self.cellType = cellType
    }
    
    // MARK: Load
    
    func loadDataWithRequest(_ request: TMDBRequest, completion: @escaping () -> (), error: @escaping (Error) -> ()) {        
        TMDB.shared.makeRequest(request: request, type: MovieResults.self) { (parse) in
            guard !parse.isCancelled else { return }
            
            if let movieResults = parse.parsedResult as? MovieResults {
                self.movies = movieResults.movies
                completion()
            } else {
                error(parse.error)
            }
        }
    }
    
    // MARK: Cancel Search
    
    func cancelSearch() {
        TMDB.shared.cancelSearch()
    }
    
    func clearList() {
        movies = []
    }
    
    func movieAtIndex(_ index: Int) -> Movie {
        return movies[index]
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
                TMDB.shared.getImageOfType(.poster(size: .small), path: posterPath) { (image) in
                    cell.imageView?.image = image
                }
            }

            return cell
        }
    }        
}

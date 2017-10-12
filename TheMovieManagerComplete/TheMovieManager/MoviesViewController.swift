//
//  MoviesViewController.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/26/15.
//  Copyright © 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

// MARK: - MoviesViewController: UIViewController

class MoviesViewController: UIViewController {
    
    // MARK: Properties
    
    let moviesDataSource = MoviesDataSource(cellType: .list)
    var loadRequest: TMDBRequest { return view.tag == 0 ? .getFavorites : .getWatchlist }
    
    // MARK: Outlets
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = moviesDataSource
        
        moviesDataSource.delegate = self
        
        // logout
        parent?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // load movies
        moviesDataSource.fetchListWithRequest(loadRequest)
    }
    
    // MARK: Actions
    
    @objc func logout() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - MoviesViewController: MoviesDataSourceDelegate

extension MoviesViewController: MoviesDataSourceDelegate {
    func moviesDataSourceDidFetchMovies(moviesDataSource: MoviesDataSource) {
        moviesTableView.reloadData()
    }
    
    func moviesDataSource(_ moviesDataSource: MoviesDataSource, didFailWithError error: Error) {
        presentAlertForError(error, dismiss: nil)
    }
}

// MARK: - MoviesViewController: UITableViewDelegate

extension MoviesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieViewController {
            let movie = moviesDataSource.movies[indexPath.row]
            controller.movieDataSource = MovieDataSource(movie: movie)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

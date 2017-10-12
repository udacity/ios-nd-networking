//
//  MovieViewController.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - MovieViewController: UIViewController

class MovieViewController: UIViewController {
    
    // MARK: Properties
    
    var movieDataSource: MovieDataSource!
    
    // MARK: Outlets
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var toggleFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var toggleWatchlistButton: UIBarButtonItem!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        movieDataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let movie = movieDataSource.movie
        navigationItem.title = movie.detailedTitle
        
        // load state
        movieDataSource.fetchState()
        
        // load post
        setActivityIndicatorEnabled(true)
        movieDataSource.fetchPoster()
    }
    
    // MARK: Actions
            
    @IBAction func mark(_ sender: AnyObject) {    
        guard let tag = sender.tag else { return }
        
        // prepare values
        let newValue = value(forTag: tag)
        let type = listType(forTag: tag)
        
        // mark movie
        movieDataSource.markMovie(forListType: type, value: newValue)
    }
    
    // MARK: Helpers
    
    private func value(forTag tag: Int) -> Bool {
        guard let state = movieDataSource.state else {
            return false
        }
        
        return tag == 0 ? !state.isFavorite : !state.isWatchlist
    }

    private func listType(forTag tag: Int) -> ListType {
        return tag == 0 ? .favorite : .watchlist
    }
}

// MARK: - MovieViewController: MovieDataSourceDelegate

extension MovieViewController: MovieDataSourceDelegate {
    
    func movieDataSourceDidFetchMovieState(movieDataSource: MovieDataSource) {
        guard let state = movieDataSource.state else { return }
        
        setUIEnabled(true)
        toggleFavoriteButton.tintColor = state.isFavorite ? nil : .black
        toggleWatchlistButton.tintColor = state.isWatchlist ? nil : .black
    }
    
    func movieDataSourceDidFetchPoster(movieDataSource: MovieDataSource) {
        setActivityIndicatorEnabled(false)
        
        if let posterImage = movieDataSource.posterImage {
            posterImageView.image = posterImage
        }
    }
    
    func movieDataSource(_ movieDataSource: MovieDataSource, didMarkMovieOnList listType: ListType) {
        guard let state = movieDataSource.state else { return }
        
        switch listType {
        case .favorite:
            toggleFavoriteButton.tintColor = state.isFavorite ? nil : .black
        case .watchlist:
            toggleWatchlistButton.tintColor = state.isWatchlist ? nil : .black
        }
    }
    
    func movieDataSource(_ movieDataSource: MovieDataSource, didFailWithError error: Error) {
        setActivityIndicatorEnabled(false)
        presentAlert(forError: error, dismiss: nil)
    }
}

// MARK: - MovieViewController (Configure UI)

extension MovieViewController {
    
    private func setUIEnabled(_ enabled: Bool) {
        toggleFavoriteButton.isEnabled = enabled
        toggleWatchlistButton.isEnabled = enabled
    }
    
    private func setActivityIndicatorEnabled(_ enabled: Bool) {
        activityIndicator.alpha = enabled ? 1.0 : 0.0
        
        if enabled {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

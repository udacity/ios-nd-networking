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

        moviesTableView.dataSource = moviesDataSource
        moviesTableView.delegate = self
        
        // logout
        parent?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // load movies
        let _ = moviesDataSource.loadDataWithRequest(loadRequest, completion: {
            self.moviesTableView.reloadData()
        }) { (error) in
            self.presentAlertForError(error, dismiss: nil)            
        }
    }
    
    // MARK: Actions
    
    @objc func logout() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - MoviesViewController: UITableViewDelegate

extension MoviesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieViewController {
            let movie = moviesDataSource.movieAtIndex(indexPath.row)
            controller.movieDataSource = MovieDataSourceX(movie: movie)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

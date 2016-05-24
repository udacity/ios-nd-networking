//
//  MoviePickerTableView.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

// MARK: - MoviePickerViewControllerDelegate

protocol MoviePickerViewControllerDelegate {
    func moviePicker(moviePicker: MoviePickerViewController, didPickMovie movie: TMDBMovie?)
}

// MARK: - MoviePickerViewController: UIViewController

class MoviePickerViewController: UIViewController {
    
    // MARK: Properties
    
    // the data for the table
    var movies = [TMDBMovie]()
    
    // the delegate will typically be a view controller, waiting for the Movie Picker to return an movie
    var delegate: MoviePickerViewControllerDelegate?
    
    // the most recent data download task. We keep a reference to it so that it can be canceled every time the search text changes
    var searchTask: NSURLSessionDataTask?
    
    // MARK: Outlets
    
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: #selector(logout))
        
        // configure tap recognizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: Dismissals
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func cancel() {
        delegate?.moviePicker(self, didPickMovie: nil)
        logout()
    }
    
    func logout() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - MoviePickerViewController: UIGestureRecognizerDelegate

extension MoviePickerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return movieSearchBar.isFirstResponder()
    }
}

// MARK: - MoviePickerViewController: UISearchBarDelegate

extension MoviePickerViewController: UISearchBarDelegate {

    // each time the search text changes we want to cancel any current download and start a new one
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        // if the text is empty we are done
        if searchText == "" {
            movies = [TMDBMovie]()
            movieTableView?.reloadData()
            return
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - MoviePickerViewController: UITableViewDelegate, UITableViewDataSource

extension MoviePickerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellReuseId = "MovieSearchCell"
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId) as UITableViewCell!
        
        if let releaseYear = movie.releaseYear {
            cell.textLabel!.text = "\(movie.title) (\(releaseYear))"
        } else {
            cell.textLabel!.text = "\(movie.title)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {        
        let movie = movies[indexPath.row]
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        controller.movie = movie
        navigationController!.pushViewController(controller, animated: true)
    }
}

//
//  FavoritesTableViewController.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - FavoritesTableViewController: UITableViewController

class FavoritesTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var movies: [Movie] = [Movie]()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the app delegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // create and set logout button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: #selector(logout))
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        /* TASK: Get movies from favorite list, then populate the table */
        
        /* 1. Set the parameters */
        let methodParameters = [
            Constants.TMDBParameterKeys.ApiKey: Constants.TMDBParameterValues.ApiKey,
            Constants.TMDBParameterKeys.SessionID: appDelegate.sessionID!
        ]
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: appDelegate.tmdbURLFromParameters(methodParameters, withPathExtension: "/account/\(appDelegate.userID!)/favorite/movies"))
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        /* 4. Make the request */
        let task = appDelegate.sharedSession.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did TheMovieDB return an error? */
            if let _ = parsedResult[Constants.TMDBResponseKeys.StatusCode] as? Int {
                print("TheMovieDB returned an error. See the '\(Constants.TMDBResponseKeys.StatusCode)' and '\(Constants.TMDBResponseKeys.StatusMessage)' in \(parsedResult)")
                return
            }
            
            /* GUARD: Is the "results" key in parsedResult? */
            guard let results = parsedResult[Constants.TMDBResponseKeys.Results] as? [[String:AnyObject]] else {
                print("Cannot find key '\(Constants.TMDBResponseKeys.Results)' in \(parsedResult)")
                return
            }
            
            /* 6. Use the data! */
            self.movies = Movie.moviesFromResults(results)
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    // MARK: Logout
    
    func logout() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - FavoritesTableViewController (UITableViewController)

extension FavoritesTableViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // get cell type
        let cellReuseIdentifier = "FavoriteTableViewCell"
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        // set cell defaults
        cell.textLabel!.text = movie.title
        cell.imageView!.image = UIImage(named: "Film Icon")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        /* TASK: Get the poster image, then populate the image view */
        if let posterPath = movie.posterPath {
            
            /* 1. Set the parameters */
            // There are none...
            
            /* 2. Build the URL */
            let baseURL = NSURL(string: appDelegate.config.baseImageURLString)!
            let url = baseURL.URLByAppendingPathComponent("w154").URLByAppendingPathComponent(posterPath)
            
            /* 3. Configure the request */
            let request = NSURLRequest(URL: url)
            
            /* 4. Make the request */
            let task = appDelegate.sharedSession.dataTaskWithRequest(request) { (data, response, error) in
                
                /* GUARD: Was there an error? */
                guard (error == nil) else {
                    print("There was an error with your request: \(error)")
                    return
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    print("Your request returned a status code other than 2xx!")
                    return
                }
                
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    print("No data was returned by the request!")
                    return
                }
                
                /* 5. Parse the data */
                // No need, the data is already raw image data.
                
                /* 6. Use the data! */
                if let image = UIImage(data: data) {
                    performUIUpdatesOnMain {
                        cell.imageView!.image = image
                    }
                } else {
                    print("Could not create image from \(data)")
                }
            }
            
            /* 7. Start the request */
            task.resume()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /* Push the movie detail view */
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        controller.movie = movies[indexPath.row]
        navigationController!.pushViewController(controller, animated: true)
    }
}
//
//  MovieDetailViewController.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - MovieDetailViewController: UIViewController

class MovieDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var isFavorite = false
    var movie: Movie?
    
    // MARK: Outlets
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteButton: UIButton!
        
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the app delegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
                
        if let movie = movie {
            
            // setting some defaults...
            posterImageView.image = UIImage(named: "film342.png")
            titleLabel.text = movie.title
            
            /* TASK A: Get favorite movies, then update the favorite buttons */
            /* 1A. Set the parameters */
            let methodParameters = [
                Constants.TMDBParameterKeys.ApiKey: Constants.TMDBParameterValues.ApiKey,
                Constants.TMDBParameterKeys.SessionID: appDelegate.sessionID!
            ]
            
            /* 2/3. Build the URL, Configure the request */
            let request = NSMutableURLRequest(URL: appDelegate.tmdbURLFromParameters(methodParameters, withPathExtension: "/account/\(appDelegate.userID!)/favorite/movies"))
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            /* 4A. Make the request */
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
                
                /* 5A. Parse the data */
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
                
                /* 6A. Use the data! */
                let movies = Movie.moviesFromResults(results)
                self.isFavorite = false
                
                for movie in movies {
                    if movie.id == self.movie!.id {
                        self.isFavorite = true
                    }
                }
                
                performUIUpdatesOnMain {
                    self.favoriteButton.tintColor = (self.isFavorite) ? nil : UIColor.blackColor()
                }
            }
            
            /* 7A. Start the request */
            task.resume()
        
            /* TASK B: Get the poster image, then populate the image view */
            if let posterPath = movie.posterPath {
                
                /* 1B. Set the parameters */
                // There are none...
                
                /* 2B. Build the URL */
                let baseURL = NSURL(string: appDelegate.config.baseImageURLString)!
                let url = baseURL.URLByAppendingPathComponent("w342").URLByAppendingPathComponent(posterPath)
                
                /* 3B. Configure the request */
                let request = NSURLRequest(URL: url)
                
                /* 4B. Make the request */
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
                    
                    /* 5B. Parse the data */
                    // No need, the data is already raw image data.
                    
                    /* 6B. Use the data! */
                    if let image = UIImage(data: data) {
                        performUIUpdatesOnMain {
                            self.posterImageView!.image = image
                        }
                    } else {
                        print("Could not create image from \(data)")
                    }
                }
                
                /* 7B. Start the request */
                task.resume()
            }
        }
    }
    
    // MARK: Favorite Actions
    
    @IBAction func toggleFavorite(sender: AnyObject) {
        
        let shouldFavorite = !isFavorite
        
        /* TASK: Add movie as favorite, then update favorite buttons */
        
        /* 1. Set the parameters */
        let methodParameters = [
            Constants.TMDBParameterKeys.ApiKey: Constants.TMDBParameterValues.ApiKey,
            Constants.TMDBParameterKeys.SessionID: appDelegate.sessionID!
        ]
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: appDelegate.tmdbURLFromParameters(methodParameters, withPathExtension: "/account/\(appDelegate.userID!)/favorite"))
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"media_type\": \"movie\",\"media_id\": \(movie!.id),\"favorite\":\(shouldFavorite)}".dataUsingEncoding(NSUTF8StringEncoding)
        
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
            
            /* GUARD: Did we receive a TMDB status_code? */
            guard let tmdbStatusCode = parsedResult[Constants.TMDBResponseKeys.StatusCode] as? Int else {
                print("Could not find key '\(Constants.TMDBResponseKeys.StatusCode)' in  \(parsedResult)")
                return
            }
            
            /* GUARD: Did we receive the correct TMDB status_code? */
            if shouldFavorite && !(tmdbStatusCode == 12 || tmdbStatusCode == 1) {
                print("Unrecognized '\(Constants.TMDBResponseKeys.StatusCode)' in  \(parsedResult)")
                return
            } else if !shouldFavorite && tmdbStatusCode != 13 {
                print("Unrecognized '\(Constants.TMDBResponseKeys.StatusCode)' in  \(parsedResult)")
                return
            }
            
            /* 6. Use the data! */
            self.isFavorite = shouldFavorite
            
            performUIUpdatesOnMain {
                self.favoriteButton.tintColor = (shouldFavorite) ? nil : UIColor.blackColor()
            }
        }
        
        /* 7. Start the request */
        task.resume()
    }
}
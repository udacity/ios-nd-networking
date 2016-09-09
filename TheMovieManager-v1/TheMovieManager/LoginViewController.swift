//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/26/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loginButton: BorderedButton!

    var tmdbClient: TMDBClient!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the TMDB client
        tmdbClient = TMDBClient.sharedInstance()
        
        configureBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
    }
    
    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        // MARK: Authentication (GET) Methods
        /*
            Steps for Authentication...
            https://www.themoviedb.org/documentation/api/sessions
            
            Step 1: Create a new request token
            Step 2a: Ask the user for permission via the website
            Step 3: Create a session ID
            Bonus Step: Go ahead and get the user id 😄!
        */
        getRequestToken()
    }
    
    // MARK: Login
    
    private func completeLogin() {
        debugTextLabel.text = ""
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: TheMovieDB
    
    private func getRequestToken() {
        
        /* TASK: Get a request token, then store it (appDelegate.requestToken) and login with the token */
        
        /* 1. Set the parameters */
        let methodParameters = [
            TMDBClient.ParameterKeys.ApiKey: TMDBClient.Constants.ApiKey
        ]
        
        /* 2/3. Build the URL, Configure the request */
        let request = URLRequest(url: TMDBClient.tmdbURLFromParameters(methodParameters as [String:AnyObject], withPathExtension: TMDBClient.Methods.AuthenticationTokenNew))
        
        /* 4. Make the request */
        let task = tmdbClient.session.dataTask(with: request) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                print(error)
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.debugTextLabel.text = "Login Failed (Request Token)."
                }
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did TheMovieDB return an error? */
            if let _ = parsedResult[TMDBClient.JSONResponseKeys.StatusCode] as? Int {
                displayError("TheMovieDB returned an error. See the '\(TMDBClient.JSONResponseKeys.StatusCode)' and '\(TMDBClient.JSONResponseKeys.StatusMessage)' in \(parsedResult)")
                return
            }
            
            /* GUARD: Is the "request_token" key in parsedResult? */
            guard let requestToken = parsedResult[TMDBClient.JSONResponseKeys.RequestToken] as? String else {
                displayError("Cannot find key '\(TMDBClient.JSONResponseKeys.RequestToken)' in \(parsedResult)")
                return
            }
            
            /* 6. Use the data! */
            self.tmdbClient.requestToken = requestToken
            self.loginWithToken(self.tmdbClient.requestToken!)
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    private func loginWithToken(_ requestToken: String) {
        
        let authorizationURL = URL(string: "\(TMDBClient.Constants.AuthorizationURL)\(requestToken)")
        let request = URLRequest(url: authorizationURL!)
        let webAuthViewController = storyboard!.instantiateViewController(withIdentifier: "TMDBAuthViewController") as! TMDBAuthViewController
        webAuthViewController.urlRequest = request
        webAuthViewController.requestToken = requestToken
        webAuthViewController.completionHandlerForView = { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()
                } else {
                    self.displayError(errorString)
                }
            }
        }
        
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
        performUIUpdatesOnMain {
            self.present(webAuthNavigationController, animated: true, completion: nil)
        }
    }
    
    private func getSessionID(_ requestToken: String) {
        
        /* TASK: Get a session ID, then store it (appDelegate.sessionID) and get the user's id */
        
        /* 1. Set the parameters */
        let methodParameters = [
            TMDBClient.ParameterKeys.ApiKey: TMDBClient.Constants.ApiKey,
            TMDBClient.ParameterKeys.RequestToken: requestToken
        ]
        
        /* 2/3. Build the URL, Configure the request */
        let request = URLRequest(url: TMDBClient.tmdbURLFromParameters(methodParameters as [String:AnyObject], withPathExtension: TMDBClient.Methods.AuthenticationSessionNew))
        
        /* 4. Make the request */
        let task = tmdbClient.session.dataTask(with: request) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String, debugLabelText: String? = nil) {
                print(error)
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.debugTextLabel.text = "Login Failed (Session ID)."
                }
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did TheMovieDB return an error? */
            if let _ = parsedResult[TMDBClient.JSONResponseKeys.StatusCode] as? Int {
                displayError("TheMovieDB returned an error. See the '\(TMDBClient.JSONResponseKeys.StatusCode)' and '\(TMDBClient.JSONResponseKeys.StatusMessage)' in \(parsedResult)")
                return
            }
            
            /* GUARD: Is the "sessionID" key in parsedResult? */
            guard let sessionID = parsedResult[TMDBClient.JSONResponseKeys.SessionID] as? String else {
                displayError("Cannot find key '\(TMDBClient.JSONResponseKeys.SessionID)' in \(parsedResult)")
                return
            }
            
            /* 6. Use the data! */
            self.tmdbClient.sessionID = sessionID
            self.getUserID(self.tmdbClient.sessionID!)
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    private func getUserID(_ sessionID: String) {
        
        /* TASK: Get the user's ID, then store it (appDelegate.userID) for future use and go to next view! */
        
        /* 1. Set the parameters */
        let methodParameters = [
            TMDBClient.ParameterKeys.ApiKey: TMDBClient.Constants.ApiKey,
            TMDBClient.ParameterKeys.SessionID: sessionID
        ]
        
        /* 2/3. Build the URL, Configure the request */
        let request = URLRequest(url: TMDBClient.tmdbURLFromParameters(methodParameters as [String:AnyObject], withPathExtension: TMDBClient.Methods.Account))
        
        /* 4. Make the request */
        let task = tmdbClient.session.dataTask(with: request) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String, debugLabelText: String? = nil) {
                print(error)
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.debugTextLabel.text = "Login Failed (User ID)."
                }
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did TheMovieDB return an error? */
            if let _ = parsedResult[TMDBClient.JSONResponseKeys.StatusCode] as? Int {
                displayError("TheMovieDB returned an error. See the '\(TMDBClient.JSONResponseKeys.StatusCode)' and '\(TMDBClient.JSONResponseKeys.StatusMessage)' in \(parsedResult)")
                return
            }
            
            /* GUARD: Is the "id" key in parsedResult? */
            guard let userID = parsedResult![TMDBClient.JSONResponseKeys.UserID] as? Int else {
                displayError("Cannot find key '\(TMDBClient.JSONResponseKeys.UserID)' in \(parsedResult)")
                return
            }
            
            /* 6. Use the data! */
            self.tmdbClient.userID = userID
            self.completeLogin()
        }
        
        /* 7. Start the request */
        task.resume()
    }
}

// MARK: - LoginViewController (Configure UI)

private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        loginButton.isEnabled = enabled
        debugTextLabel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
    
    func configureBackground() {
        let backgroundGradient = CAGradientLayer()
        let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).cgColor
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }
}

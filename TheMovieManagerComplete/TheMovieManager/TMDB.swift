//
//  TMDB.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import Foundation

// MARK: - TMDB

class TMDB {
    
    // MARK: Constants
    
    static let apiKey = "ADD_API_KEY"
    static let scheme = "https"
    static let host = "api.themoviedb.org"    
    static let path = "/3"
    static let authorizationURL = "https://www.themoviedb.org/authenticate/"
    static let accountURL = "https://www.themoviedb.org/account/"
    
    struct QueryKeys {
        static let apiKey = "api_key"
        static let includeAdult = "include_adult"
        static let sessionID = "session_id"
        static let requestToken = "request_token"
        static let query = "query"
    }
    
    // MARK: Properties

    var sessionID: String?
    var account: Account?
    var config: Config?
    let queue = OperationQueue()
    
    // MARK: Login
    
    func loginWithHostViewController(_ hostViewController: UIViewController, completion: @escaping () -> (), error: @escaping (String) -> ()) {
        getConfig()
        createRequestToken(hostViewController, completion: completion, error: error)
    }
    
    private func createRequestToken(_ hostViewController: UIViewController, completion: @escaping () -> (), error: @escaping (String) -> ()) {
        let request = TMDBRequest.createToken
        
        let fetch = FetchOperation(urlComponents: request.components)
        let parse = TMDBParseOperation(type: RequestToken.self)
        parse.addDependency(fetch)
        parse.completionBlock = {
            if let requestToken = parse.parsedResult as? RequestToken {
                DispatchQueue.main.async {
                    self.loginWithToken(requestToken.token, hostViewController: hostViewController, completion: {
                        self.createSessionID(withToken: requestToken.token, completion: completion, error: error)
                    }, error: { (errorString) in
                        error(errorString)
                    })
                }
            } else {
                self.handle(parse.parsedResult, parsedError: parse.parsedError, error: error)
            }
        }
        
        queue.addOperation(fetch)
        queue.addOperation(parse)
    }
    
    private func createSessionID(withToken token: String, completion: @escaping () -> (), error: @escaping (String) -> ()) {
        let request = TMDBRequest.createSession(token)
        
        let fetch = FetchOperation(urlComponents: request.components)
        let parse = TMDBParseOperation(type: SessionID.self)
        parse.addDependency(fetch)
        parse.completionBlock = {
            DispatchQueue.main.async {
                if let sessionID = parse.parsedResult as? SessionID {
                    self.sessionID = sessionID.id
                    self.getAccount(completion: completion, error: error)
                } else {
                    self.handle(parse.parsedResult, parsedError: parse.parsedError, error: error)
                }
            }            
        }
        
        queue.addOperation(fetch)
        queue.addOperation(parse)
    }
    
    private func getAccount(completion: @escaping () -> (), error: @escaping (String) -> ()) {
        let request = TMDBRequest.getAccount
        
        let fetch = FetchOperation(urlComponents: request.components)
        let parse = TMDBParseOperation(type: Account.self)
        parse.addDependency(fetch)
        parse.completionBlock = {
            DispatchQueue.main.async {
                if let account = parse.parsedResult as? Account {
                    self.account = account
                    completion()
                } else {
                    self.handle(parse.parsedResult, parsedError: parse.parsedError, error: error)
                }
            }
        }
        
        queue.addOperation(fetch)
        queue.addOperation(parse)
    }
    
    private func loginWithToken(_ requestToken: String?, hostViewController: UIViewController, completion: @escaping () -> (), error: @escaping (String) -> ()) {
        let authorizationURL = URL(string: "\(TMDB.authorizationURL)\(requestToken!)")
        let request = URLRequest(url: authorizationURL!)
        let webAuthViewController = hostViewController.storyboard!.instantiateViewController(withIdentifier: "TMDBAuthViewController") as! TMDBAuthViewController
        webAuthViewController.urlRequest = request
        webAuthViewController.requestToken = requestToken
        webAuthViewController.completion = completion
        webAuthViewController.error = error
        
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
        DispatchQueue.main.async {
            hostViewController.present(webAuthNavigationController, animated: true, completion: nil)
        }
    }
    
    // MARK: Config
    
    func getConfig() {
        let request = TMDBRequest.getConfig
        
        let fetch = FetchOperation(urlComponents: request.components)
        let parse = TMDBParseOperation(type: Config.self)
        parse.addDependency(fetch)
        parse.completionBlock = {
            if let config = parse.parsedResult as? Config {
                self.config = config
            } else {
                self.handle(parse.parsedResult, parsedError: parse.parsedError, error: nil)
            }
        }
        
        queue.addOperation(fetch)
        queue.addOperation(parse)
    }
    
    // MARK: Images
    
    func getImageOfType(_ type: ImageType, path: String, completion: @escaping (UIImage) -> (), error: @escaping (String) -> ()) {
        if let size = config?.images.sizeForImageType(type) {
            let request = TMDBRequest.getImage(size, path)
            
            let fetch = FetchOperation(urlComponents: request.components)
            let parse = ImageParseOperation()
            parse.addDependency(fetch)
            parse.completionBlock = {
                DispatchQueue.main.async {
                    if let parsedImage = parse.parsedImage {
                        completion(parsedImage)
                    } else {
                        error("cannot parse image data \(parse.parsedError?.localizedDescription ?? "")")
                    }
                }
            }
            
            queue.addOperation(fetch)
            queue.addOperation(parse)
        } else {
            // FIXME: change naming of error
            error("could get imageTypePath")
        }
    }
    
    // MARK: Error Handling
    
    // FIXME: rename this
    func handle(_ parsedObject: AnyObject?, parsedError: Error?, error: ((String) -> Void)?) {
        if let errorResults = parsedObject as? ErrorResults {
            error?("\(errorResults)")
        } else if let status = parsedObject as? Status {
            error?("\(status)")
        } else {
            error?("could not retrieve data \(parsedError?.localizedDescription ?? "")")
        }
    }
        
    // MARK: Shared Instance
    
    static let shared = TMDB()
}

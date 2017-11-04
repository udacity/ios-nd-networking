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
    
    static var apiKey = "API_KEY_HERE"
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
    private let queue = OperationQueue()
    private let searchQueue = OperationQueue()
    
    // MARK: Search
    
    func cancelSearch() {
        searchQueue.cancelAllOperations()
    }
    
    // MARK: Request
    
    func makeRequest<T>(_ request: TMDBRequest, type: T.Type, completion: ((TMDBParseOperation<T>) -> (Void))?) {
        guard let urlRequest = request.urlRequest else { return }
        
        let fetch = FetchOperation(request: urlRequest)
        let parse = TMDBParseOperation(type: type)
        parse.addDependency(fetch)
        parse.completionBlock = {
            DispatchQueue.main.async {
                completion?(parse)
            }
        }
        
        switch request {
        case .searchMovies:
            searchQueue.addOperation(fetch)
            searchQueue.addOperation(parse)
        default:
            queue.addOperation(fetch)
            queue.addOperation(parse)
        }
    }
            
    // MARK: Login
    
    func login(withHostViewController hostViewController: UIViewController, completion: @escaping () -> (), error: @escaping (Error) -> ()) {
        // get configuration (for image paths)
        getConfig()
        
        // NOTE: Documentation (user auth) at developers.themoviedb.org/3/getting-started/authentication
        /*
         1. Create a new request token
         2. Get the user to authorize the request token
         3. Create a new session id with the authorized request token
         */
        
        // start authentication flow
        createRequestToken(withHostViewController: hostViewController, completion: completion, error: error)
    }
    
    private func createRequestToken(withHostViewController: UIViewController, completion: @escaping () -> (), error: @escaping (Error) -> ()) {
        makeRequest(.createToken, type: RequestToken.self) { (parse) in
            if let requestToken = parse.parsedResult as? RequestToken {
                self.authorizeToken(requestToken.token, hostViewController: withHostViewController, completion: {
                    self.createSessionID(withToken: requestToken.token, completion: completion, error: error)
                }, error: { (errorString) in
                    error(errorString)
                })
            } else {
                error(parse.error)
            }
        }
    }
    
    private func authorizeToken(_ requestToken: String, hostViewController controller: UIViewController, completion: @escaping () -> (), error: @escaping (Error) -> ()) {
        guard let authorizationURL = URL(string: "\(TMDB.authorizationURL)\(requestToken)"), let authController = controller.storyboard?.instantiateViewController(withIdentifier: "TMDBAuthViewController") as? TMDBAuthViewController else {
            error(TMDBError.basic(description: "could not initialize authorization controller"))
            return
        }
        
        authController.urlRequest = URLRequest(url: authorizationURL)
        authController.requestToken = requestToken
        authController.completion = completion
        authController.error = error
        
        let navigationController = UINavigationController()
        navigationController.pushViewController(authController, animated: false)
        
        DispatchQueue.main.async {
            controller.present(navigationController, animated: true, completion: nil)
        }
    }
    
    private func createSessionID(withToken token: String, completion: @escaping () -> (), error: @escaping (Error) -> ()) {
        makeRequest(.createSession(token: token), type: SessionID.self) { (parse) in
            if let sessionID = parse.parsedResult as? SessionID {
                self.sessionID = sessionID.id
                // as an extra step, fetch the user account
                self.getAccount(completion: completion, error: error)
            } else {
                error(parse.error)
            }
        }
    }
    
    private func getAccount(completion: @escaping () -> (), error: @escaping (Error) -> ()) {
        makeRequest(.getAccount, type: Account.self) { (parse) in
            if let account = parse.parsedResult as? Account {
                self.account = account
                completion()
            } else {
                error(parse.error)
            }
        }
    }
    
    // MARK: Config
    
    private func getConfig() {
        makeRequest(.getConfig, type: Config.self) { (parse) in
            if let config = parse.parsedResult as? Config {
                self.config = config
            }
        }
    }
    
    // MARK: Images
    
    func getImageWith(type: ImageType, path: String, completion: @escaping (UIImage?) -> ()) {
        guard let size = config?.images.size(forImageType: type), let request = TMDBRequest.getImage(size: size, path: path).urlRequest, let url = request.url else {
            return
        }
        
        ImageCache.shared.fetchImage(withURL: url) { (image) in
            completion(image)
        }
    }
    
    // MARK: Shared Instance
    
    private init() {
        // load api key
        if let secretsURL = Bundle.main.url(forResource: "Secrets", withExtension: "plist"), let data = try? Data(contentsOf: secretsURL), let secrets = try? PropertyListDecoder().decode(Secrets.self, from: data) {
            TMDB.apiKey = secrets.theMovieDBAPIKey
        }
    }
    
    static let shared = TMDB()
}

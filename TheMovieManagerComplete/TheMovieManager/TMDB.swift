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
    
    static let apiKey = "API_KEY_HERE"
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
    
    // MARK: Cancel
    
    func cancelSearch() {
        searchQueue.cancelAllOperations()
    }
            
    // MARK: Login
    
    func loginWithHostViewController(_ hostViewController: UIViewController, completion: @escaping () -> (), error: @escaping (Error) -> ()) {
        // get configuration (needed for image paths)
        getConfig()
        
        // start authentication flow
        createRequestToken(hostViewController, completion: completion, error: error)
    }
    
    func makeRequest<T>(request: TMDBRequest, type: T.Type, completion: ((TMDBParseOperation<T>) -> (Void))?) {
        guard let urlRequest = request.urlRequest else {
            return
        }
        
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
            
    private func createRequestToken(_ hostViewController: UIViewController, completion: @escaping () -> (), error: @escaping (Error) -> ()) {
        makeRequest(request: .createToken, type: RequestToken.self) { (parse) in
            if let requestToken = parse.parsedResult as? RequestToken {
                self.authorizeToken(requestToken.token, hostViewController: hostViewController, completion: {
                    self.createSessionID(withToken: requestToken.token, completion: completion, error: error)
                }, error: { (errorString) in
                    error(errorString)
                })
            } else {
                error(parse.error)
            }
        }
    }
    
    private func createSessionID(withToken token: String, completion: @escaping () -> (), error: @escaping (Error) -> ()) {
        makeRequest(request: .createSession(token: token), type: SessionID.self) { (parse) in
            if let sessionID = parse.parsedResult as? SessionID {
                self.sessionID = sessionID.id
                self.getAccount(completion: completion, error: error)
            } else {
                error(parse.error)
            }
        }
    }
    
    private func getAccount(completion: @escaping () -> (), error: @escaping (Error) -> ()) {
        makeRequest(request: .getAccount, type: Account.self) { (parse) in
            if let account = parse.parsedResult as? Account {
                self.account = account
                completion()
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
    
    // MARK: Config
    
    func getConfig() {
        makeRequest(request: .getConfig, type: Config.self) { (parse) in
            if let config = parse.parsedResult as? Config {
                self.config = config
            }
        }
    }
    
    // MARK: Images
    
    func getImageOfType(_ type: ImageType, path: String, completion: @escaping (UIImage?) -> ()) {
        guard let size = config?.images.sizeForImageType(type), let request = TMDBRequest.getImage(size: size, path: path).urlRequest, let url = request.url else {
            return
        }
        
        ImageCache.shared.loadImageWithURL(url) { (image) in
            completion(image)
        }
    }
    
    // MARK: Shared Instance
    
    private init() {}
    
    static let shared = TMDB()
}

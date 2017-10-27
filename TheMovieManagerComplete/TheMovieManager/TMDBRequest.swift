//
//  TMDBRequest.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/9/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - HTTPMethod: String

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case update = "UPDATE"
    case delete = "DELETE"
}

// MARK: - TMDBRequest

enum TMDBRequest {
    case createSession(token: String)
    case createToken
    case getAccount
    case getConfig
    case getImage(size: String, path: String)
    case getFavorites
    case getWatchlist
    case markFavorite(mark: MarkMedia)
    case markWatchlist(mark: MarkMedia)
    case getMovieState(id: Int)
    case searchMovies(query: String)
    
    // MARK: URL Request
    
    var urlRequest: URLRequest? {
        var request: URLRequest?
        
        if let url = components.url {
            var urlRequest = URLRequest(url: url)
            
            // add method
            urlRequest.httpMethod = method.rawValue
            
            // add headers
            for (key, value) in headers { urlRequest.addValue(value, forHTTPHeaderField: key) }
            
            // add http body
            if let httpBody = httpBody { urlRequest.httpBody = httpBody }
            
            request = urlRequest
        }
        
        return request
    }
    
    // MARK: HTTP Method
    
    var method: HTTPMethod {
        switch self {
        case .markFavorite, .markWatchlist:
            return .post
        default:
            return .get
        }
    }
    
    // MARK: Headers
    
    var headers: [String: String] {
        switch self {
        case .markFavorite, .markWatchlist:
            return ["Content-Type": "application/json;charset=utf-8"]
        default:
            return [:]
        }
    }
    
    // MARK: Host and Path
    
    private var hostAndPath: (String, String) {
        switch self {
        case .getImage:
            if let secureBaseURL = TMDB.shared.config?.images.secureBaseURL {
                // remove scheme from url (format: {scheme}://{host}/{path})
                let endOfSchemeIndex = secureBaseURL.index(secureBaseURL.startIndex, offsetBy: 8)
                let hostAndPath = String(secureBaseURL.suffix(from: endOfSchemeIndex))
                
                // split host and path using the index of the first '/' character
                if let endOfHostIndex = hostAndPath.index(of: "/") {
                    let host = String(hostAndPath.prefix(upTo: endOfHostIndex))
                    let path = String(hostAndPath.suffix(from: endOfHostIndex)) + subpath
                    return (host, path)
                }
            }
        default:
            return (TMDB.host, TMDB.path + subpath)
        }
        
        return ("", "")
    }
    
    // MARK: Components
    
    var components: URLComponents {
        var components = URLComponents()
        components.scheme = TMDB.scheme
        components.host = hostAndPath.0
        components.path = hostAndPath.1
        components.queryItems = queryItems        
        return components
    }
    
    // MARK: Subpath
    
    var subpath: String {
        let accountID = TMDB.shared.account?.id ?? -1
        
        switch self {
        case .createSession: return "/authentication/session/new"
        case .createToken: return "/authentication/token/new"
        case .getAccount: return "/account"
        case .getConfig: return "/configuration"
        case let .getImage(size, path): return "\(size)\(path)"
        case .getFavorites: return "/account/\(accountID)/favorite/movies"
        case .getWatchlist: return "/account/\(accountID)/watchlist/movies"
        case .markFavorite: return "/account/\(accountID)/favorite"
        case .markWatchlist: return "/account/\(accountID)/watchlist"
        case .getMovieState(let movieID): return "/movie/\(movieID)/account_states"
        case .searchMovies: return "/search/movie"
        }
    }
    
    // MARK: Query Items
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        // most requests need the api key
        switch self {
        case .getImage:
            break
        default:
            items.append(URLQueryItem(name: TMDB.QueryKeys.apiKey, value: TMDB.apiKey))
        }

        // certain requests have additional query items
        switch self {
        case .createSession(let token):
            items.append(URLQueryItem(name: TMDB.QueryKeys.requestToken, value: token))
        case .searchMovies(let query):
            items.append(URLQueryItem(name: TMDB.QueryKeys.query, value: query))
        case .getAccount, .getFavorites, .getWatchlist,
             .markFavorite, .markWatchlist, .getMovieState:
            if let sessionID = TMDB.shared.sessionID {
                items.append(URLQueryItem(name: TMDB.QueryKeys.sessionID, value: sessionID))
            }
        default:
            break
        }
        
        return items
    }
    
    // MARK: JSON Body
    
    var httpBody: Data? {
        switch self {
        case .markFavorite(let markMedia), .markWatchlist(let markMedia):
            do {
                let encoder = JSONEncoder()
                return try encoder.encode(markMedia)
            } catch {
                return nil
            }
        default:
            return nil
        }
    }
}

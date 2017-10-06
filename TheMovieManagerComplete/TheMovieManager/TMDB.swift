//
//  TMDB.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - Methods

enum Methods {
    case createSession
    case createToken
    case getAccount
    case getConfig
    case getFavorites(Int)
    case getWatchlist(Int)
    case markFavorite(Int)
    case markWatchlist(Int)
    case searchMovies
    
    var path: String {
        switch self {
        case .createSession: return "/authentication/token/new"
        case .createToken: return "/authentication/session/new"
        case .getAccount: return "/account"
        case .getConfig: return "/configuration"
        case .getFavorites(let userID): return "/account/\(userID)/favorite/movies"
        case .getWatchlist(let userID): return "/account/\(userID)/watchlist/movies"
        case .markFavorite(let userID): return "/account/\(userID)/favorite"
        case .markWatchlist(let userID): return "/account/\(userID)/favorite"
        case .searchMovies: return "/search/movie"
        }
    }
}

// MARK: - TMDB

class TMDB {
    
    // MARK: Constants
    
    static let apiKey = "API_KEY_HERE"
    static let host = "api.themoviedb.org"
    static let path = "/3"
    static let authorizationURL = "https://www.themoviedb.org/authenticate/"
    static let accountURL = "https://www.themoviedb.org/account/"
    
    struct QueryKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
    }
}

//
//  Constants.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 11/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - Constants

struct Constants {
    
    // MARK: - BasicRequest
    
    struct BasicRequest {
        static let catURLString = "https://d17h27t6h515a5.cloudfront.net/topher/2017/November/59fe511b_cat/cat.jpg"
        static let dogURLString = "https://d17h27t6h515a5.cloudfront.net/topher/2017/November/59fe5124_terrier/terrier.jpg"
    }
    
    // MARK: - Components
    
    struct Components {
        static let scheme = "https"
        static let host = "thecatapi.com"
        static let path = "/api/images/get"
        static let queryItems = [
            URLQueryItem(name: "format", value: "src"),
            URLQueryItem(name: "type", value: "png")
        ]
    }
    
    // MARK: - Insecure Domain
    
    struct InsecureDomain {
        static let scheme = "http"
        static let host = "jarrodparkes.com"
        static let path = "/images/day-2-katie-and-jarrod.jpg"
    }
    
    // MARK: - URL Session
    
    struct URLSession {
        static let scheme = "https"
        static let host = "d17h27t6h515a5.cloudfront.net"
        static let path = "/topher/2017/November/59fe5118_bigcat/bigcat.jpeg"
    }
    
    // MARK: - Upload
    
    struct Upload {
        static let scheme = "http"
        static let host = "localhost"
        static let port = 8080
    }
}


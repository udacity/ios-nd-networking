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
        static let catURLString = "https://upload.wikimedia.org/wikipedia/commons/4/4d/Cat_November_2010-1a.jpg"
        static let dogURLString = "https://upload.wikimedia.org/wikipedia/commons/e/ec/Terrier_mixed-breed_dog.jpg"
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
        static let host = "upload.wikimedia.org"
        static let path = "/wikipedia/commons/c/cb/Bengal_Cat_Details_of_Face.jpeg"
    }
    
    // MARK: - Upload
    
    struct Upload {
        static let scheme = "http"
        static let host = "localhost"
        static let port = 8080        
    }
}

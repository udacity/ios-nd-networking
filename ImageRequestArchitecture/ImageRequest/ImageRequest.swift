//
//  ImageRequest.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 11/1/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - ImageRequest

enum ImageRequest: String {
    case cat = "Cat November 2010-1a"
    case dog = "Terrier mixed-breed dog"
    
    // MARK: URL Request
    
    var urlRequest: URLRequest? {
        var request: URLRequest?
        
        if let url = components.url {
            request = URLRequest(url: url)
        }
        
        return request
    }
    
    // MARK: Path
    
    var path: String {
        switch self {
        case .cat:
            return "/wikipedia/commons/4/4d/Cat_November_2010-1a.jpg"
        case .dog:
            return "/wikipedia/commons/e/ec/Terrier_mixed-breed_dog.jpg"
        }
    }
    
    // MARK: Components
    
    var components: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "upload.wikimedia.org"
        components.path = path
        return components
    }
}

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
            return "/topher/2017/November/59fe511b_cat/cat.jpg"
        case .dog:
            return "/topher/2017/November/59fe5124_terrier/terrier.jpg"
        }
    }
    
    // MARK: Components
    
    var components: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "d17h27t6h515a5.cloudfront.net"
        components.path = path
        return components
    }
}

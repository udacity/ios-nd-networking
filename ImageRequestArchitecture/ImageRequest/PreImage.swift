//
//  PreImage.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - PreImage: Codable

struct PreImage: Codable {
            
    // MARK: Properties
    
    let title: String
    let urlString: String
    
    var url: URL? {
        return URL(string: urlString)
    }
}

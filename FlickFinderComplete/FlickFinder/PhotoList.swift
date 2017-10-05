//
//  PhotoList.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - PhotoList: Codable

struct PhotoList: Codable {

    // MARK: Properties
    
    let page: Int
    let pages: Int
    let perPage: Int
    let total: String
    let photo: [Photo]
    
    // MARK: Keys
    
    enum CodingKeys : String, CodingKey {
        case page
        case pages
        case perPage = "perpage"
        case total
        case photo
    }
}

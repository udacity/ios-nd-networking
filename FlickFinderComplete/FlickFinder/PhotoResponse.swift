//
//  PhotoResponse.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - PhotoResponse: Codable

struct PhotoResponse: Codable {
    
    // MARK: Properites
    
    let photoList: PhotoList
    let stat: String
    
    // MARK: Keys
    
    enum CodingKeys : String, CodingKey {
        case photoList = "photos"
        case stat
    }
}

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
    let photosPerPage: Int
    let total: String
    let photos: [Photo]
    
    // MARK: Keys
    
    enum CodingKeys : String, CodingKey {
        case page
        case pages
        case photosPerPage = "perpage"
        case total
        case photos = "photo"
    }
    
    // MARK: Helpers
    
    func randomPage() -> Int {
        let pageLimit = min(pages, 40)
        return Int(arc4random_uniform(UInt32(pageLimit))) + 1
    }
    
    func randomPhoto() -> Photo {
        let randomPhotoIndex = Int(arc4random_uniform(UInt32(photos.count)))
        return photos[randomPhotoIndex]
    }
}

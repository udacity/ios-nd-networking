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
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case photosPerPage = "perpage"
        case total
        case photos = "photo"
    }
    
    // MARK: Helpers
    
    func randomPage() -> Int {
        // NOTE: By default, searches use a page size of 100. Any search requesting a page that would contain an image beyond the 4000th image, will simply return the 1st page. Therefore, unique images will only be found on pages 1 through 40, assuming a search responds with 4000+ images. If a search responds with less than 4000 images, then unique images will be found on pages 1 through the last page (indicated by "pages" in the response).
        let pageLimit = min(pages, 40)
        return Int(arc4random_uniform(UInt32(pageLimit))) + 1
    }
    
    func randomPhoto() -> Photo {
        let randomPhotoIndex = Int(arc4random_uniform(UInt32(photos.count)))
        return photos[randomPhotoIndex]
    }
}

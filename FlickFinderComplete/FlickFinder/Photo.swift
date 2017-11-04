//
//  Photo.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

// MARK: - Photo: Codable

struct Photo: Codable {
    
    // MARK: Properties
    
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let originalURL: String?
    let mediumURL: String?
    let _isPublic: Int
    let _isFriend: Int
    let _isFamily: Int
    let title: String
    
    var isPublic: Bool { return _isPublic == 1 }
    var isFriend: Bool { return _isFriend == 1 }
    var isFamily: Bool { return _isFamily == 1 }
    
    var imageURL: URL? {
        // NOTE: In certain cases you may not see the originalURL. Occasionally, free accounts will not have access to view the original photo. But, for all search results, you should have either the originalURL or the mediumURL.
        if let originalURL = originalURL {
            return URL(string: originalURL)
        } else if let mediumURL = mediumURL {
            return URL(string: mediumURL)
        } else {
            return nil
        }
    }
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case originalURL = "url_o"
        case mediumURL = "url_m"
        case _isPublic = "ispublic"
        case _isFriend = "isfriend"
        case _isFamily = "isfamily"
    }
}

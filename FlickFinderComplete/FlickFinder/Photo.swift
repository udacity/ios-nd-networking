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
    
    var image: UIImage? {
        // NOTE: In certain cases you may not see the originalURL. That is because free accounts are not allowed to view there original photos. But, in the search results, you will have atleast one or the other.
        var urlString = ""
        if let originalURL = originalURL {
            urlString = originalURL
        } else if let mediumURL = mediumURL {
            urlString = mediumURL
        }
        
        if let url = URL(string: urlString), let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
            return image
        }
        
        return nil
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

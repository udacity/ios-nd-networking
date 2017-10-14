//
//  Status.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 10/13/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - Status: Codable

struct Status: Codable {
    
    // MARK: Properties
    
    let status: String
    let code: Int
    let message: String
    
    // MARK: Keys
    
    enum CodingKeys: String, CodingKey {
        case status = "stat"
        case code
        case message
    }
}

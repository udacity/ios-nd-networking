//
//  BreedsListResponse.swift
//  Randog
//
//  Created by Owen LaRosa on 10/16/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

struct BreedsListResponse: Codable {
    let status: String
    let message: [String: [String]]
}

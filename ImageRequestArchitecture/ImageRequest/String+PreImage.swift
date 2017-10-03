//
//  String+PreImage.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - String+PreImage

extension String {
    
    func toPreImage() -> PreImage? {
        
        var image: PreImage?
        
        do {
            let decoder = JSONDecoder()
            if let data = self.data(using: .utf8) {
                image = try decoder.decode(PreImage.self, from: data)
            }
        } catch {}
        
        return image
    }
}

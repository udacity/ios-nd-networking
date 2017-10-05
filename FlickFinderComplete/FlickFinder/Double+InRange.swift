//
//  Double+InRange.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 10/5/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

extension Double {
    func inRange(_ range: (min: Double, max: Double)) -> Bool {
        return !(self < range.min || self > range.max)
    }
}

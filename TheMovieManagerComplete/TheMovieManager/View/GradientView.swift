//
//  GradientView.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    var gradientLayer: CAGradientLayer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        gradientLayer = CAGradientLayer()
        let colorTop = UIColor.gradientTop.cgColor
        let colorBottom = UIColor.gradientBottom.cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = frame
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        gradientLayer.frame = frame
    }
    
}



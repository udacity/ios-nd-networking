//
//  UIViewController+Alert.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 10/10/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

// MARK: - UIViewController (Alert)

extension UIViewController {
    
    func alertError(_ error: String, handler: ((UIAlertAction) -> (Void))?) {
        let controller = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: handler)
        controller.addAction(dismiss)
        present(controller, animated: true, completion: nil)
    }
}

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
    
    func presentAlertForError(_ error: Error, dismiss: ((UIAlertAction) -> (Void))?) {
        let controller = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: dismiss)
        controller.addAction(dismissAction)
        present(controller, animated: true, completion: nil)
    }
}

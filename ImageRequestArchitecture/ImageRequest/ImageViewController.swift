//
//  ImageViewController.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - ImageViewController: UIViewController

class ImageViewController: UIViewController {
    
    // MARK: Properties
    
    let imageDataSource = ImageDataSource()
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        imageDataSource.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // fetch image
        imageDataSource.fetchImage(of: .cat)
    }
}

// MARK: - ImageViewController: ImageDataSourceDelegate

extension ImageViewController: ImageDataSourceDelegate {
    
    func imageDataSourceDidFetchImage(imageDataSource: ImageDataSource) {
        imageView.image = imageDataSource.image
        titleLabel.text = imageDataSource.title
    }
    
    func imageDataSource(_ imageDataSource: ImageDataSource, didFailWithError error: Error) {
        presentAlert(forError: error) { (alert) in
            self.titleLabel.text = "fix problem and retry 🙂!"
        }
    }
}

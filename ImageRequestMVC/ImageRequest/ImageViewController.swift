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
        
        imageDataSource.load(completion: { (image, title) in
            performUIUpdatesOnMain {
                self.showImage(image, title: title)
            }
        }) { (error) in
            performUIUpdatesOnMain {
                self.showError(error)
            }
        }
    }
    
    // MARK: Handlers
    
    func showImage(_ image: UIImage, title: String) {
        imageView.image = image
        titleLabel.text = title
    }
    
    func showError(_ error: String) {
        titleLabel.text = error
    }
}

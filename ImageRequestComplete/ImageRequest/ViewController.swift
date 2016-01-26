//
//  ViewController.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create url
        let imageURL = NSURL(string: Constants.CatURL)!
        
        // create network request
        let task = NSURLSession.sharedSession().dataTaskWithURL(imageURL) { (data, response, error) in
            
            if error == nil {
                
                // create image
                let downloadedImage = UIImage(data: data!)
                
                // update UI on a main thread
                performUIUpdatesOnMain {
                    self.imageView.image = downloadedImage
                }
                
            } else {
                print(error)
            }
        }
        
        // start network request
        task.resume()
    }
}
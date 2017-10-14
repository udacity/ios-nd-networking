//
//  ViewController.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

let catURL = "https://upload.wikimedia.org/wikipedia/commons/4/4d/Cat_November_2010-1a.jpg"
let dogURL = "https://upload.wikimedia.org/wikipedia/commons/e/ec/Terrier_mixed-breed_dog.jpg"

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create url
        guard let imageURL = URL(string: catURL) else {
            return
        }
        
        // create network request
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if let data = data {
                // create image
                let downloadedImage = UIImage(data: data)
                
                // update UI on a main thread
                DispatchQueue.main.async {
                    self.imageView.image = downloadedImage
                }
            } else {
                print(error ?? "unknown error")
            }
        }
        
        // start network request
        task.resume()
    }
}

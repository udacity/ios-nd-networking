//
//  BasicRequestViewController.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - BasicRequestViewController: ExampleViewController

class BasicRequestViewController: ExampleViewController {

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create url from string
        guard let imageURL = URL(string: Constants.BasicRequest.catURLString) else { return }
        
        // create url request
        let request = URLRequest(url: imageURL)
        
        // create task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                // create image
                let image = UIImage(data: data)
                
                // update UI on the main thread
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } else {
                print(error ?? "unknown error")
            }
        }
        
        // start task
        task.resume()
    }
}

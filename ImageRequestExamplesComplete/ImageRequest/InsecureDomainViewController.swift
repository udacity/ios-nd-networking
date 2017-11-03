//
//  InsecureDomainViewController.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 11/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

// MARK: - InsecureDomainViewController: ExampleViewController

class InsecureDomainViewController: ExampleViewController {
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create components
        var components = URLComponents()
        components.scheme = Constants.InsecureDomain.scheme
        components.host = Constants.InsecureDomain.host
        components.path = Constants.InsecureDomain.path
        
        // create url from components
        guard let imageURL = components.url else { return }
        
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

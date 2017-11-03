//
//  ComponentsViewController.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 11/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

// MARK: - ComponentsViewController: ExampleViewController

class ComponentsViewController: ExampleViewController {
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create components
        var components = URLComponents()
        components.scheme = Constants.Components.scheme
        components.host = Constants.Components.host
        components.path = Constants.Components.path
        components.queryItems = Constants.Components.queryItems
                        
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


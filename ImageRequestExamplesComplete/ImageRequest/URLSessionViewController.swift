//
//  URLSessionViewController.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 11/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

// MARK: - URLSessionViewController: ExampleViewController

class URLSessionViewController: ExampleViewController {
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create components
        var components = URLComponents()
        components.scheme = Constants.URLSession.scheme
        components.host = Constants.URLSession.host
        components.path = Constants.URLSession.path
        
        // create url from components
        guard let imageURL = components.url else { return }
        
        // create url request
        let request = URLRequest(url: imageURL)
        
        // create session config
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 60        

        // create session
        let session = URLSession(configuration: configuration)
        
        // create task
        let task = session.dataTask(with: request) { (data, response, error) in
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

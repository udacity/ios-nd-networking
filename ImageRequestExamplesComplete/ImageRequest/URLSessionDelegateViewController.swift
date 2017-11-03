//
//  URLSessionDelegateViewController.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 11/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

// MARK: - URLSessionDelegateViewController: ExampleViewController

class URLSessionDelegateViewController: ExampleViewController {
    
    // MARK: Properties
    
    var receivedData = Data()
    
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
        
        // create session and specify delegate
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
        
        // create task
        let task = session.dataTask(with: request)
        
        // start task
        task.resume()
    }
}

// MARK: - URLSessionDelegateViewController: URLSessionDataDelegate

extension URLSessionDelegateViewController: URLSessionDataDelegate {

    // MARK: URLSessionDataDelegate
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // aggregate the received
        receivedData.append(data)
    }
    
    // MARK: URLSessionTaskDelegate
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard error == nil else {
            print(error ?? "unknown error")
            return
        }

        // create image
        let image = UIImage(data: receivedData)
        
        // update UI
        imageView.image = image
    }
}

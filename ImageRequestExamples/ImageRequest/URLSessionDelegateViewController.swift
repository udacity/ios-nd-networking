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
        
        // FIXME: Make a request using the URL session delegate
    }
}

// MARK: - URLSessionDelegateViewController: URLSessionDataDelegate

extension URLSessionDelegateViewController: URLSessionDataDelegate {

    // MARK: URLSessionDataDelegate
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // FIXME: Add the new data to the received data
    }
    
    // MARK: URLSessionTaskDelegate
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // FIXME: Make sure the task was successful, then update the image view
    }
}

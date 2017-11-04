//
//  ConnectivityViewController.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 11/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

// MARK: - ConnectivityViewController: ExampleViewController

class ConnectivityViewController: ExampleViewController {
    
    // MARK: Properties
    
    var receivedData = Data()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME: Make a request using a URLSession configuration that waits for connectivity.
    }
}

// MARK: - ConnectivityViewController: URLSessionDataDelegate

extension ConnectivityViewController: URLSessionDataDelegate {
    
    // MARK: URLSessionTaskDelegate
    
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        print("waiting, show offline mode")
    }
}

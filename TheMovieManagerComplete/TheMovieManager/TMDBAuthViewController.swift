//
//  TMDBAuthViewController.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15.
//  Copyright © 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

// MARK: - TMDBAuthViewController: UIViewController

class TMDBAuthViewController: UIViewController {

    // MARK: Properties
    
    var urlRequest: URLRequest?
    var requestToken: String?
    var completion: (() -> (Void))?
    var error: ((Error) -> (Void))?
    
    // MARK: Outlets
    
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        navigationItem.title = "TheMovieDB Auth"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAuth))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let urlRequest = urlRequest {
            webView.loadRequest(urlRequest)
        }
    }
    
    // MARK: Cancel Auth Flow
    
    @objc func cancelAuth() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TMDBAuthViewController: UIWebViewDelegate

extension TMDBAuthViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard let urlString = webView.request?.url?.absoluteString, let requestToken = requestToken else { return }
        
        // redirect url if it doesn't start with the account url
        guard !urlString.contains(TMDB.accountURL) else {
            if let urlRequest = urlRequest {
                webView.loadRequest(urlRequest)
            }
            return
        }
        
        // check if user has authorized the token
        if urlString == "\(TMDB.authorizationURL)\(requestToken)/allow" {
            dismiss(animated: true) {
                self.completion?()
            }
        }
    }
}

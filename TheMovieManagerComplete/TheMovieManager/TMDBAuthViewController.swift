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
    
    var urlRequest: URLRequest? = nil
    var requestToken: String? = nil
    var completion: (() -> ())? = nil
    var error:  ((String) -> ())? = nil
    
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
        
        // FIXME: make a guard statement
        // if user has to login, this will redirect them back to the authorization url
        if let urlRequest = urlRequest, webView.request!.url!.absoluteString.contains(TMDB.accountURL) {
            webView.loadRequest(urlRequest)
        }
        
        if webView.request!.url!.absoluteString == "\(TMDB.authorizationURL)\(requestToken!)/allow" {
            
            dismiss(animated: true) {
                self.completion?()
            }
        }
    }
}

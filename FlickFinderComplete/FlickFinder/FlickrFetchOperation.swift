//
//  FlickrFetchOperation.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

// MARK: - FlickrFetchOperation: BaseOperation

class FlickrFetchOperation: BaseOperation {
    
    // MARK: Properties
    
    var fetchedData: Data?
    var fetchedResponse: URLResponse?
    var fetchedError: Error?
    
    private var queryItemsDictionary: [String:Any]
    private var task: URLSessionDataTask?
    
    // MARK: Initialize
    
    init(searchType: SearchType) {
        queryItemsDictionary = [
            FlickrAPI.Keys.searchMethod: FlickrAPI.Values.searchMethod,
            FlickrAPI.Keys.apiKey: FlickrAPI.Values.apiKey,
            FlickrAPI.Keys.safeSearch: FlickrAPI.Values.safeSearch,
            FlickrAPI.Keys.extras: FlickrAPI.Values.urls,
            FlickrAPI.Keys.responseFormat: FlickrAPI.Values.responseFormat,
            FlickrAPI.Keys.noJSONCallback: FlickrAPI.Values.noJSONCallback
        ]
        
        switch searchType {
        case .location(_, _):
            queryItemsDictionary[FlickrAPI.Keys.boundingBox] = searchType.bboxString
        case .phrase(let text):
            queryItemsDictionary[FlickrAPI.Keys.text] = text
        }
                
        super.init()
        
        // operation queue will not execute this operation while it's pending
        state = .pending
    }
    
    func makeReady(withPageNumber pageNumber: Int? = nil) {        
        if let pageNumber = pageNumber {
            queryItemsDictionary[FlickrAPI.Keys.page] = pageNumber
        }
        
        if let url = FlickrAPI().urlWithQueryItems(queryItemsDictionary) {
            let request = URLRequest(url: url)
            task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                self.fetchedData = data
                self.fetchedResponse = response
                self.fetchedError = error
                self.state = .finished
            }
        }
        
        // operation queue can now execute this operation
        state = .ready
    }
    
    // MARK: Operation
    
    override func start() {
        // start fetch
        state = .executing
        task?.resume()
    }        
}

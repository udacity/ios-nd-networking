//
//  SearchDataSource.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 10/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import Foundation

// MARK: - SearchDataSourceDelegate

protocol SearchDataSourceDelegate {
    func searchDataSourceDidFetchPhoto(searchDataSource: SearchDataSource)
    func searchDataSource(_ searchDataSource: SearchDataSource, didFailWithError error: Error)
}

// MARK: - SearchDataSource: NSObject

class SearchDataSource: NSObject {
    
    // MARK: Properties
    
    var photo: Photo?
    var delegate: SearchDataSourceDelegate?
    
    // MARK: Search
    
    func searchForRandomPhoto(withRequest request: FlickrRequest) {
        fetchRandomPage(withRequest: request)
    }
    
    private func fetchRandomPage(withRequest request: FlickrRequest) {
        Flickr.shared.makeRequest(request, type: PhotoResponse.self) { (parse) in
            if let photoResponse = parse.parsedResult as? PhotoResponse {
                // pick a random page, ignore other data
                let randomPage = photoResponse.photoList.randomPage()
                
                switch request {
                case let .searchPhotosByLocation(latitude, longitude, _):
                    self.fetchRandomPhoto(withRequest: .searchPhotosByLocation(latitude: latitude, longitude: longitude, page: randomPage))
                case let .searchPhotosByPhrase(phrase, _):
                    self.fetchRandomPhoto(withRequest: .searchPhotosByPhrase(phrase, page: randomPage))
                }
            } else {
                self.delegate?.searchDataSource(self, didFailWithError: parse.error)
            }
        }
    }
    
    private func fetchRandomPhoto(withRequest request: FlickrRequest) {
        Flickr.shared.makeRequest(request, type: PhotoResponse.self) { (parse) in
            if let photoResponse = parse.parsedResult as? PhotoResponse {
                // pick a random photo
                let randomPhoto = photoResponse.photoList.randomPhoto()
                self.photo = randomPhoto
                self.delegate?.searchDataSourceDidFetchPhoto(searchDataSource: self)
            } else {
                self.delegate?.searchDataSource(self, didFailWithError: parse.error)
            }
        }
    }
}

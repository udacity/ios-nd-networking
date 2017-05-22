//
//  Config.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//
//  The config struct stores (persist) information that is used to build image
//  URL's for TheMovieDB. The constant values below were taken from
//  the site on 1/23/15. Invoking the updateConfig convenience method
//  will download the latest using the initializer below to
//  parse the dictionary.
//
//  We will talk more about persistance in a later lesson.
//

import UIKit
import Foundation

// MARK: - File Support

private let _documentsDirectoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
private let _fileURL: URL = _documentsDirectoryURL.appendingPathComponent("TheMovieDB-Context")

// MARK: - Config

class Config: NSObject, NSCoding {
    
    // MARK: Properties
    
    // default values from 1/12/15
    var baseImageURLString = "http://image.tmdb.org/t/p/"
    var secureBaseImageURLString =  "https://image.tmdb.org/t/p/"
    var posterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "original"]
    var profileSizes = ["w45", "w185", "h632", "original"]
    var dateUpdated: Date? = nil
    
    // returns the number days since the config was last updated
    var daysSinceLastUpdate: Int? {
        if let lastUpdate = dateUpdated {
            return Int(Date().timeIntervalSince(lastUpdate)) / 60*60*24
        } else {
            return nil
        }
    }
    
    // MARK: Initialization
    
    override init() {}
    
    convenience init?(dictionary: [String:AnyObject]) {
        
        self.init()
        
        if let imageDictionary = dictionary["images"] as? [String:AnyObject],
            let urlString = imageDictionary["base_url"] as? String,
            let secureURLString = imageDictionary["secure_base_url"] as? String,
            let posterSizesArray = imageDictionary["poster_sizes"] as? [String],
            let profileSizesArray = imageDictionary["profile_sizes"] as? [String] {
                baseImageURLString = urlString
                secureBaseImageURLString = secureURLString
                posterSizes = posterSizesArray
                profileSizes = profileSizesArray
                dateUpdated = Date()
        } else {
            return nil
        }
    }
    
    // MARK: Update
    
    func updateIfDaysSinceUpdateExceeds(_ days: Int) {
        
        // if the config is up to date then return
        if let daysSinceLastUpdate = daysSinceLastUpdate, daysSinceLastUpdate <= days {
            return
        } else {
            updateConfiguration()
        }
    }
    
    private func updateConfiguration() {
        
        /* TASK: Get TheMovieDB configuration, and update the config */
        
        /* Grab the app delegate */
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        /* 1. Set the parameters */
        let methodParameters = [
            Constants.TMDBParameterKeys.ApiKey: Constants.TMDBParameterValues.ApiKey
        ]
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: appDelegate.tmdbURLFromParameters(methodParameters as [String:AnyObject], withPathExtension: "/configuration"))
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        /* 4. Make the request */
        let task = appDelegate.sharedSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }

            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error!)")
                return
            }
            
            /* Parse the data! */
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
                    
            /* 6. Use the data! */
            if let newConfig = Config(dictionary: parsedResult) {
                appDelegate.config = newConfig
                appDelegate.config.save()
            } else {
                print("Could not parse config")
            }
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    // MARK: NSCoding
    
    let BaseImageURLStringKey = "config.base_image_url_string_key"
    let SecureBaseImageURLStringKey =  "config.secure_base_image_url_key"
    let PosterSizesKey = "config.poster_size_key"
    let ProfileSizesKey = "config.profile_size_key"
    let DateUpdatedKey = "config.date_update_key"
    
    required init(coder aDecoder: NSCoder) {
        baseImageURLString = aDecoder.decodeObject(forKey: BaseImageURLStringKey) as! String
        secureBaseImageURLString = aDecoder.decodeObject(forKey: SecureBaseImageURLStringKey) as! String
        posterSizes = aDecoder.decodeObject(forKey: PosterSizesKey) as! [String]
        profileSizes = aDecoder.decodeObject(forKey: ProfileSizesKey) as! [String]
        dateUpdated = aDecoder.decodeObject(forKey: DateUpdatedKey) as? Date
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(baseImageURLString, forKey: BaseImageURLStringKey)
        aCoder.encode(secureBaseImageURLString, forKey: SecureBaseImageURLStringKey)
        aCoder.encode(posterSizes, forKey: PosterSizesKey)
        aCoder.encode(profileSizes, forKey: ProfileSizesKey)
        aCoder.encode(dateUpdated, forKey: DateUpdatedKey)
    }
    
    private func save() {
        NSKeyedArchiver.archiveRootObject(self, toFile: _fileURL.path)
    }
    
    class func unarchivedInstance() -> Config? {
        
        if FileManager.default.fileExists(atPath: _fileURL.path) {
            return NSKeyedUnarchiver.unarchiveObject(withFile: _fileURL.path) as? Config
        } else {
            return nil
        }
    }
}

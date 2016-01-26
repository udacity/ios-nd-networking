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

private let _documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
private let _fileURL: NSURL = _documentsDirectoryURL.URLByAppendingPathComponent("TheMovieDB-Context")

// MARK: - Config

class Config: NSObject, NSCoding {
    
    // MARK: Properties
    
    // default values from 1/12/15
    var baseImageURLString = "http://image.tmdb.org/t/p/"
    var secureBaseImageURLString =  "https://image.tmdb.org/t/p/"
    var posterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "original"]
    var profileSizes = ["w45", "w185", "h632", "original"]
    var dateUpdated: NSDate? = nil
    
    // returns the number days since the config was last updated
    var daysSinceLastUpdate: Int? {
        if let lastUpdate = dateUpdated {
            return Int(NSDate().timeIntervalSinceDate(lastUpdate)) / 60*60*24
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
                dateUpdated = NSDate()
        } else {
            return nil
        }
    }
    
    // MARK: Update
    
    func updateIfDaysSinceUpdateExceeds(days: Int) {
        
        // if the config is up to date then return
        if let daysSinceLastUpdate = daysSinceLastUpdate where daysSinceLastUpdate <= days {
            return
        } else {
            updateConfiguration()
        }
    }
    
    private func updateConfiguration() {
        
        /* TASK: Get TheMovieDB configuration, and update the config */
        
        /* Grab the app delegate */
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* 1. Set the parameters */
        let methodParameters = [
            Constants.TMDBParameterKeys.ApiKey: Constants.TMDBParameterValues.ApiKey
        ]
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(URL: appDelegate.tmdbURLFromParameters(methodParameters, withPathExtension: "/configuration"))
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        /* 4. Make the request */
        let task = appDelegate.sharedSession.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
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
                print("There was an error with your request: \(error)")
                return
            }
            
            /* Parse the data! */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
                    
            /* 6. Use the data! */
            if let newConfig = Config(dictionary: parsedResult as! [String:AnyObject]) {
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
        baseImageURLString = aDecoder.decodeObjectForKey(BaseImageURLStringKey) as! String
        secureBaseImageURLString = aDecoder.decodeObjectForKey(SecureBaseImageURLStringKey) as! String
        posterSizes = aDecoder.decodeObjectForKey(PosterSizesKey) as! [String]
        profileSizes = aDecoder.decodeObjectForKey(ProfileSizesKey) as! [String]
        dateUpdated = aDecoder.decodeObjectForKey(DateUpdatedKey) as? NSDate
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(baseImageURLString, forKey: BaseImageURLStringKey)
        aCoder.encodeObject(secureBaseImageURLString, forKey: SecureBaseImageURLStringKey)
        aCoder.encodeObject(posterSizes, forKey: PosterSizesKey)
        aCoder.encodeObject(profileSizes, forKey: ProfileSizesKey)
        aCoder.encodeObject(dateUpdated, forKey: DateUpdatedKey)
    }
    
    private func save() {
        NSKeyedArchiver.archiveRootObject(self, toFile: _fileURL.path!)
    }
    
    class func unarchivedInstance() -> Config? {
        
        if NSFileManager.defaultManager().fileExistsAtPath(_fileURL.path!) {
            return NSKeyedUnarchiver.unarchiveObjectWithFile(_fileURL.path!) as? Config
        } else {
            return nil
        }
    }
}
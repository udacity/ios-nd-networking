//
//  animals-solution.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForAnimalsJSON = NSBundle.mainBundle().pathForResource("animals", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawAnimalsJSON = NSData(contentsOfFile: pathForAnimalsJSON!)

/* Error object */
var parsingAnimalsError: NSError? = nil

/* Parse the data into usable form */
var parsedAnimalsJSON = try! NSJSONSerialization.JSONObjectWithData(rawAnimalsJSON!, options: .AllowFragments) as! NSDictionary

func parseJSONAsDictionary(dictionary: NSDictionary) {
    
    guard let photosDictionary = parsedAnimalsJSON["photos"] as? NSDictionary else {
        print("Cannot find key 'photos' in \(parsedAnimalsJSON)")
        return
    }
    
    guard let numAnimalsPhotos = photosDictionary["total"] as? Int else {
        print("Cannot find key 'total' in \(photosDictionary)")
        return
    }
    
    /* How many photos are in the JSON data set? */
    print(numAnimalsPhotos)
    
    guard let arrayOfPhotoDictionaries = photosDictionary["photo"] as? [[String:AnyObject]] else {
        print("Cannot find key 'photo' in \(photosDictionary)")
        return
    }
    
    for (index, photo) in arrayOfPhotoDictionaries.enumerate() {
        
        guard let commentDictionary = photo["comment"] as? [String:AnyObject] else {
            print("Cannot find key 'comment' in \(photo)")
            return
        }
        
        guard let content = commentDictionary["_content"] as? String else {
            print("Cannot find key '_content' in \(commentDictionary)")
            return
        }
        
        /* What is the array index of the photo that has content containing the text "interrufftion"? */
        if content.rangeOfString("interrufftion") != nil {
            print(index)
        }
        
        /* For the third photo in the array of photos, what animal is shown? */
        if let photoURL = photo["url_m"] as? String where index == 2 {
            print(photoURL)
        }
    }
}

parseJSONAsDictionary(parsedAnimalsJSON)

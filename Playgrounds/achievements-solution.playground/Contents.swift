//
//  achievements-solution.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForAchievementsJSON = NSBundle.mainBundle().pathForResource("achievements", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawAchievementsJSON = NSData(contentsOfFile: pathForAchievementsJSON!)

/* Error object */
var parsingAchivementsError: NSError? = nil

/* Parse the data into usable form */
var parsedAchievementsJSON = try! NSJSONSerialization.JSONObjectWithData(rawAchievementsJSON!, options: .AllowFragments) as! NSDictionary

func parseJSONAsDictionary(dictionary: NSDictionary) {
    
    /* Get top level dictionaries for achievements and categories */
    guard let achievementDictionaries = parsedAchievementsJSON["achievements"] as? [NSDictionary] else {
        print("Cannot find key 'achievements' in \(parsedAchievementsJSON)")
        return
    }
    
    guard let categoryDictionaries = parsedAchievementsJSON["categories"] as? [NSDictionary] else {
        print("Cannot find key 'categories' in \(parsedAchievementsJSON)")
        return
    }
    
    var pointsTotal = 0
    
    /* Create array to hold the categoryIds for "Matchmaking" categories */
    var matchmakingIds: [Int] = []
    
    /* Create dictionary to store the counts for "Matchmaking" categories */
    var categoryCounts: [Int: Int] = [:]
    
    /* Store all "Matchmaking" categories */
    for categoryDictionary in categoryDictionaries {
        
        if let title = categoryDictionary["title"] as? String where title == "Matchmaking" {
            
            guard let children = categoryDictionary["children"] as? [NSDictionary] else {
                print("Cannot find key 'children' in \(categoryDictionary)")
                return
            }
            
            for child in children {
                
                guard let categoryId = child["categoryId"] as? Int else {
                    print("Cannot find key 'categoryId' in \(child)")
                    return
                }
                
                matchmakingIds.append(categoryId)
            }
            
        }
    }
    
    for achievementDictionary in achievementDictionaries {
        
        /* Add to point total and print if achievement has greater than 10 points */
        guard let points = achievementDictionary["points"] as? Int else {
            print("Cannot find key 'points' in \(achievementDictionary)")
            return
        }
        
        pointsTotal += points
        
        /* How many achievements have a point value greater than 10? */
        if points > 10 {
            print("achievement has point value greater than 10")
        }
        
        /* Learn more about the "Cool Running" achievement */
        if let title = achievementDictionary["title"] as? String,
            let description = achievementDictionary["description"] as? String
            where title == "Cool Running" {		
                /* What mission must you complete... */
                print(description)
        }
    
        /* Add to category counts */
        guard let categoryId = achievementDictionary["categoryId"] as? Int else {
            print("Cannot find key 'categoryId' in \(achievementDictionary)")
            return
        }
    
        /* Does category have a key in dictionary? If not, initialize */
        if categoryCounts[categoryId] == nil {
            categoryCounts[categoryId] = 0
        }
        
        /* Add one to category count */
        if let currentCount = categoryCounts[categoryId] {
            categoryCounts[categoryId] = currentCount + 1
        }
    }
    
    /* What is the average point value for achievements? */
    print("average number of points per achievement is \(Double(pointsTotal)/Double(achievementDictionaries.count))")
    
    var matchmakingAchievementCount = 0
    
    /* Calculate number of "Matchmaking" achievements */
    for matchmakingId in matchmakingIds {
        if let categoryCount = categoryCounts[matchmakingId] {
            matchmakingAchievementCount += categoryCount
        }
    }
    
    /* How many achievements belong to "Matchmaking" category? */
    print("\(matchmakingAchievementCount) achievements belong to the \"Matchmaking\" category")
}

parseJSONAsDictionary(parsedAchievementsJSON)

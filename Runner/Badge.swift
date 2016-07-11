//
//  Badge.swift
//  Runner
//
//  Created by Zhicong Zang on 7/11/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import Foundation

let silverMultiplier = 1.05
let goldMultiplier = 1.10

struct Badge {
    let name: String?
    let imageName: String?
    let information: String?
    let distance: Double?
    
    init(json: [String: String]) {
        name = json["name"]
        imageName = json["imageName"]
        information = json["information"]
        distance = json["distance"] != nil ? Double(json["distance"]!) : nil
    }
    
}

class BadgeController {
    static let sharedController = BadgeController()
    
    lazy var badges : [Badge] = {
        var _badges = [Badge]()
        
        let filePath = NSBundle.mainBundle().pathForResource("badges", ofType: "json")!
        let jsonData = NSData(contentsOfFile: filePath)!
        
        do {
            if let jsonBadges = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as? [[String: String]] {
                for jsonBadge in jsonBadges {
                    _badges.append(Badge(json: jsonBadge))
                }
            }
        } catch {}
        
        return _badges
    }()
    
//    func badgeEarnStatusesForRuns(runs: [Run]) -> [BadgeEarnStatus] {
//        var badgeEarnStatuses = [BadgeEarnStatus]()
//        
//        for badge in badges {
//            
//        }
//    }
}

class BadgeEarnStatus {
    let badge: Badge
    var earnRun: Run?
    var silverRun: Run?
    var goldRun: Run?
    var bestRun: Run?
    
    init(badge: Badge) {
        self.badge = badge
    }
    
}
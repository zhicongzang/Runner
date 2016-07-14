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
    
    func badgeEarnStatusesForRuns(runs: [Run]) -> [BadgeEarnStatus] {
        var badgeEarnStatuses = [BadgeEarnStatus]()
        
        for badge in badges {
            let badgeEarnStatus = BadgeEarnStatus(badge: badge)
            
            for run in runs {
                if run.distance?.doubleValue > badge.distance {
                    if badgeEarnStatus.earnRun == nil {
                        badgeEarnStatus.earnRun = run
                    }
                    
                    let earnRunSpeed = (badgeEarnStatus.earnRun!.distance?.doubleValue)! / (badgeEarnStatus.earnRun!.duration?.doubleValue)!
                    let runSpeed = (run.distance?.doubleValue)! / (run.duration?.doubleValue)!
                    
                    if badgeEarnStatus.silverRun == nil && runSpeed > earnRunSpeed * silverMultiplier {
                        badgeEarnStatus.silverRun = run
                    }
                    
                    if badgeEarnStatus.goldRun == nil && runSpeed > earnRunSpeed * goldMultiplier {
                        badgeEarnStatus.goldRun = run
                    }
                    
                    if let bestRun = badgeEarnStatus.bestRun {
                        let bestRunSpeed = (bestRun.distance?.doubleValue)! / (bestRun.duration?.doubleValue)!
                        if runSpeed > bestRunSpeed {
                            badgeEarnStatus.bestRun = run
                        }
                    } else {
                        badgeEarnStatus.bestRun = run
                    }
                }
            }
            
            badgeEarnStatuses.append(badgeEarnStatus)
        }
        return badgeEarnStatuses
    }
    
    func bestBadgeForDistance(distance: Double) -> Badge {
        var bestBadge = badges.first!
        for badge in badges {
            if distance < badge.distance {
                break
            }
            bestBadge = badge
        }
        return bestBadge
    }
    
    func nextBadgeForDistance(distance: Double) -> Badge {
        var nextBadge = badges.first as Badge!
        for badge in badges {
            nextBadge = badge
            if distance < badge.distance {
                break
            }
        }
        return nextBadge
    }
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
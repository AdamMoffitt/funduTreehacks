//
//  LeagueTeam.swift
//  fundü
//
//  Created by Adam Moffitt on 2/16/18.
//  Copyright © 2018 fundü. All rights reserved.
//

import Foundation
import SwiftyJSON
class LeagueTeam: NSObject {
    
    var teamName : String
    var teamID : String
    var dayChange : Float
    var weekChange : Float
    var monthChange : Float
    var yearChange : Float
    var overallChange : Float
    
    override init() {
        teamName = ""
         teamID = ""
         dayChange = 0
         weekChange = 0
         monthChange = 0
         yearChange = 0
         overallChange = 0
    }
    
    convenience init(dictionary: NSDictionary) {
        self.init()
        if dictionary["teamName"] != nil {
            self.teamName = dictionary["teamName"] as! String
        }
        if dictionary["teamID"] != nil {
            self.teamID = dictionary["teamID"] as! String
        }
        if dictionary["dayChange"] != nil {
            self.dayChange = dictionary["dayChange"] as! Float
        }
        if dictionary["weekChange"] != nil {
            self.weekChange = dictionary["weekChange"] as! Float
        }
        if dictionary["monthChange"] != nil {
            self.monthChange = dictionary["monthChange"] as! Float
        }
        if dictionary["yearChange"] != nil {
            self.yearChange = dictionary["yearChange"] as! Float
        }
        if dictionary["overallChange"] != nil {
            self.overallChange = dictionary["overallChange"] as! Float
        }
    }
}


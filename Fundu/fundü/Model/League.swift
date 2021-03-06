//
//  League.swift
//  fundü
//
//  Created by Adam Moffitt on 2/1/18.
//  Copyright © 2018 fundü. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SwiftyJSON

class League : NSObject {
    
    var leagueName : String
    var leagueManagerID : String
    var leagueID : String
    var teams : [String] // dictionary of team names : team IDs
    var leagueType : String // Shadow, real, or crypto
    var leagueAccess : String // public or private
    var maxNumberOfTeams : Int // Maximum teams in league
    var createdOnDate : Date
    var key: String
    var ref: DatabaseReference?
    
    override init () {
        leagueName = ""
        leagueManagerID = ""
        teams = [String]()
        leagueType = ""
        leagueAccess = ""
        maxNumberOfTeams = 0
        createdOnDate = Date()
        leagueID = NSUUID().uuidString
        
        key = ""
        ref = DatabaseReference()
    }
    
    convenience init (name: String) {
        self.init()
        leagueName = name
    }
    
    convenience init(snapshot: DataSnapshot) {
        self.init()
        key = snapshot.key
        ref = snapshot.ref
        if !(snapshot.value is NSNull) {
            let json = JSON(snapshot.value as Any)
            
            self.leagueName = json["leagueName"].stringValue
            self.leagueManagerID = json["leagueManagerID"].stringValue
            self.leagueID = json["leagueID"].stringValue
            self.leagueType = json["leagueType"].stringValue
            self.leagueAccess = json["leagueAccess"].stringValue
            self.maxNumberOfTeams = json["maxNumberOfTeams"].intValue
            for (key,subJson):(String, JSON) in json["teams"] {
                self.teams.append(key)
            }
        
        }
        print(self)
    }
    
    func toAnyObject() -> Any {
        for element in teams {
            print("team: \(element)")
        }

        return [
            "leagueName": leagueName,
            //"leagueManager": leagueManager.toAnyObject,
            "leagueType": leagueType,
            "leagueAccess": leagueAccess,
            "maxNumberOfTeams": maxNumberOfTeams,
            "createdOnDate": encodeForFirebaseKey(string: String(describing: createdOnDate)),
            "leagueID": leagueID,
            "teams": teams
        ]
    }
    
    func encodeForFirebaseKey(string: String) -> (String){
        var string1 = string.replacingOccurrences(of: "_", with: "__")
        string1 = string1.replacingOccurrences(of: ".", with: "_P")
        string1 = string1.replacingOccurrences(of: "$", with: "_D")
        string1 = string1.replacingOccurrences(of: "#", with: "_H")
        string1 = string1.replacingOccurrences(of: "[", with: "_O")
        string1 = string1.replacingOccurrences(of: "]", with: "_C")
        string1 = string1.replacingOccurrences(of: "/", with: "_S")
        return string1
    }
}

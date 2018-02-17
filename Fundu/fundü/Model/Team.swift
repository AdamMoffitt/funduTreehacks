//
//  Team.swift
//  fundü
//
//  Created by Adam Moffitt on 2/6/18.
//  Copyright © 2018 fundü. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SwiftyJSON
class Team : NSObject {
    
    var teamName : String
    var teamID : String
    var members : [String]
    var portfolio : Dictionary<String, Any>
    
    override init() {
        teamName = ""
        teamID = ""
        members = [String]()
        portfolio = Dictionary()
    }
    
    convenience init(snapshot: DataSnapshot) {
        self.init()
        let key = snapshot.key
        let ref = snapshot.ref
        if !(snapshot.value is NSNull) {
            let snapshotValue = snapshot.value as! [String: AnyObject]
            //print(snapshotValue)
            if snapshotValue["teamName"] != nil {
                self.teamName = snapshotValue["teamName"] as! String
            }
            if snapshotValue["teamID"] != nil {
                self.teamID = snapshotValue["teamID"] as! String
            }
            if snapshotValue["members"] != nil {
                self.members = snapshotValue["members"] as! Array
            }
            if snapshotValue["portfolio"] != nil {
                print(snapshotValue["portfolio"])
                self.portfolio = snapshotValue["portfolio"] as! Dictionary
            }
        }
    }
    
    convenience init(dictionary: NSDictionary) {
        self.init()
            if dictionary["teamName"] != nil {
                self.teamName = dictionary["teamName"] as! String
            }
            if dictionary["teamID"] != nil {
                self.teamID = dictionary["teamID"] as! String
            }
            if dictionary["members"] != nil {
                self.members = dictionary["members"] as! Array
            }
        }
    
    convenience init (member: User) {
        self.init()
        teamName = member.username
        teamID = member.userID
        members.append(member.username)
    }
    
    func toAnyObject()-> Any {
        return [
            "teamName" : teamName,
            "teamID" : teamID,
            "members" : members
        ]
    }
}

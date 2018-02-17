//
//  User.swift
//  fundü
//
//  Created by Adam Moffitt on 2/1/18.
//  Copyright © 2018 fundü. All rights reserved.
//

import Foundation
import FirebaseDatabase

class User : NSObject {
    var firstName : String
    var lastName : String
    var username : String
    var leagues : [String] // leagues the user is a member of
    // var experience  TODO?
    var userID : String
    var email : String
    var password : String
    
    override init() {
        firstName = ""
        lastName = ""
        username = ""
        userID = ""
        leagues = [String]()
        email = ""
        password = ""
    }
    
    convenience init(username: String) {
        self.init()
        self.username = username
    }
    
    convenience init (newUsername: String, newEmail: String, newPassword: String, newID: String) {
        self.init()
        self.username = newUsername
        self.email = newEmail
        self.password = newPassword
        self.userID = newID
    }
    convenience init(dictionary: NSDictionary) {
        self.init()
        
        if dictionary["username"] != nil {
            self.username = dictionary["username"] as! String
        }
        if dictionary["firstName"] != nil {
            self.firstName = dictionary["firstName"] as! String
        }
        if dictionary["lastName"] != nil {
            self.lastName = dictionary["lastName"] as! String
        }
        if dictionary["userID"] != nil {
            self.userID = dictionary["userID"] as! String
        }
    }
    
    convenience init(snapshot: DataSnapshot) {
        self.init()
        let key = snapshot.key
        let ref = snapshot.ref
        if !(snapshot.value is NSNull) {
            let snapshotValue = snapshot.value as! [String: AnyObject]
            //print(snapshotValue)
            if snapshotValue["username"] != nil {
                self.username = snapshotValue["username"] as! String
            }
            if snapshotValue["userID"] != nil {
                self.userID = snapshotValue["userID"] as! String
            }
            if snapshotValue["firstName"] != nil {
                self.firstName = snapshotValue["firstName"] as! String
            }
            if snapshotValue["lastName"] != nil {
                self.lastName = snapshotValue["lastName"] as! String
            }
        }
    }
    
    func toAnyObject() -> Any {
        
        var leaguesArray = NSArray()
        for element in leagues {
            leaguesArray.adding(element)
        }
        print(leaguesArray)
        return [
            "firstName": firstName,
            "lastName": lastName,
            "username": username,
            "userID": userID,
            "leagues": leaguesArray
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

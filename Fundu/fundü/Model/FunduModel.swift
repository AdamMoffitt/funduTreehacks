//
//  FunduModel.swift
//  fundü
//
//  Created by Adam Moffitt on 2/2/18.
//  Copyright © 2018 fundü. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class FunduModel {
    
    var ref: DatabaseReference!
    var partiesChanged = true
    var storage : Storage
    var storageRef : StorageReference
    var myUser : User
    var leagues : [League]
    
    //singleton
    static var shared = FunduModel()
    
    init() {
        ref = Database.database().reference()
        
        // Get a reference to the storage service using the default Firebase App
        storage = Storage.storage()
        // Create a storage reference from our storage service
        storageRef = storage.reference()
        
        myUser = User()
        leagues = []

        loadFromFirebase(completionHandler: { print("completion") })
    }
    
    func setMyUser(newUser: User) {
        myUser = newUser
    }
    
    func addNewUser(newUser: User) {
        ref.child("users").child(newUser.userID).setValue(newUser.toAnyObject())
    }
    
    func newLeague(league: League) {
        print("add league: \(league.leagueID) \(league.toAnyObject())")
        self.ref.child("leagues").child(league.leagueID).setValue(league.toAnyObject())
    }
    
    func addTeamToLeague(newTeam: Team, league: League) {
        print(newTeam.toAnyObject())
        self.ref.child("leagues").child(league.leagueID).child("teams").child(encodeForFirebaseKey(string: newTeam.teamName)).setValue(newTeam.toAnyObject())
    }
    
    /******************* load leagues from firebase - observe *******************/
    func loadFromFirebase(completionHandler: @escaping () -> Void) {
        ref.child("leagues").observe(DataEventType.value, with: { (snapshot) in
            if !snapshot.exists() {
                return
            }
            var newLeagues : [League] = []
            for child in (snapshot.children.allObjects as? [DataSnapshot])! {
                let league = League(snapshot: child )
                print(league.leagueName)
                newLeagues.append(league)
            }
            self.leagues = newLeagues
        })
        completionHandler()
    }
    /****************************************************************************/
    
    /****************************************************************************/
    func getTeam(teamID: String, completion: @escaping (Team)->(UITableViewCell) ) {
        ref.child("teams").child(teamID).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                if !snapshot.exists() {
                completion(Team())
                }
                completion(Team(snapshot: snapshot))
            })
    }
    /****************************************************************************/
    
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
    
    func decodeFromFireBaseKey (string: String) -> (String) {
        var string1 = string.replacingOccurrences(of: "__" , with: "_")
        string1 = string1.replacingOccurrences(of: "_P", with: ".")
        string1 = string1.replacingOccurrences(of: "_D", with: "$")
        string1 = string1.replacingOccurrences(of: "_H", with: "#")
        string1 = string1.replacingOccurrences(of: "_O", with: "[")
        string1 = string1.replacingOccurrences(of: "_C", with: "]")
        string1 = string1.replacingOccurrences(of: "_S", with: "/")
        return string1
    }
    
}

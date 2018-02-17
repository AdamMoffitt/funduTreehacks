//
//  LeaguesViewController.swift
//  fundü
//
//  Created by Adam Moffitt on 2/1/18.
//  Copyright © 2018 fundü. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import SwiftyJSON

class LeaguesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var mainLeaguesScrollView : UIScrollView!
    
    var leaderboards = [UITableView]()
    var timeframeSegmentedControls = [UISegmentedControl]()
    let SharedFunduModel = FunduModel.shared
    let timeframesArray = ["Overall", "Today", "Past Week", "Past Month", "Past Year"]
    let selectedLeagueIndex = 0
    var navBar: UINavigationBar!
    var teams = [[Team]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLeaguesFromFirebase()
    }
    
    func createLeagueViews() {
        mainLeaguesScrollView = UIScrollView(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height-40))
        for i in 0..<SharedFunduModel.leagues.count {
            addNewLeagueView(newLeague: SharedFunduModel.leagues[i], position: i)
        }
        mainLeaguesScrollView.isPagingEnabled = true
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeftOpenMenu))
        swipeLeft.direction = .left
        mainLeaguesScrollView.addGestureRecognizer(swipeLeft)
        self.view.addSubview(mainLeaguesScrollView)
        
        //        for i in 0..<leagues.count {
        //            let leagueImageView = UIImgeView()
        //            imageView.image = leagues[i].image
        //            imageView.contentMode = .scaleAspectFit
        //            let xPosition = self.view.frame.width * CGFloat(i)
        //            imageView.frame = CGRect(x: xPosition, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        //            mainLeaguesScrollView.contentSize.width = mainLeaguesScrollView.frame.width * CGFloat(i+1)
        //            mainLeaguesScrollView.addSubview(imageView)
        //        }
    }
    
    
    @objc func changeTimeFrame(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("show all")
            sortTableViews(index: 0)
        case 0:
            print("show daily")
            sortTableViews(index: 1)
        case 1:
            print("show weekly")
            sortTableViews(index: 2)
        case 2:
            print("show monthly")
            sortTableViews(index: 3)
        case 3:
            print("show yearly")
            sortTableViews(index: 4)
        default:
            print("show all")
            sortTableViews(index: 0)
        }
        refreshTableViews()
    }
    
    // JUST FOR TESTING
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    func loadLeaguesFromFirebase() {
        SharedFunduModel.loadFromFirebase(completionHandler: {
            for i in 0..<self.SharedFunduModel.leagues.count {
                self.getTeams(leagueNumber: i, completionHandler: {
                    if i == self.SharedFunduModel.leagues.count-1 {
                        self.createLeagueViews()
                    }
                })
            }
        })
    }
    
    func getTeams(leagueNumber: Int, completionHandler: @escaping ()->Void) {
        let teamsDict = [
            "12345" : [
                "dayChange" : 0.5,
                "weekChange" : 0.34,
                "monthChange" : 0.16,
                "yearChange" : -0.30,
                "overallChange" : -0.16
            ],
            "54321" : [
                "dayChange" : 0.23,
                "weekChange" : -0.34,
                "monthChange" : 0.02,
                "yearChange" : -0.17,
                "overallChange" : -0.12
            ],
            "11223" : [
                "dayChange" : 0.23,
                "weekChange" : 0.45,
                "monthChange" : -0.12,
                "yearChange" : 0.32,
                "overallChange" : -0.05
            ]
        ]
        let json = JSON(teamsDict)
        
        for (key,subJson):(String, JSON) in json {
            print(Team(dictionary: subJson.dictionaryObject as! NSDictionary))
            self.teams[leagueNumber].append(Team(dictionary: subJson.dictionaryObject as! NSDictionary))
        }
        
        completionHandler()
        
//        for i in 0..<self.SharedFunduModel.leagues[index].teams.count {
//            let teamID = SharedFunduModel.leagues[index].teams[i]
//            SharedFunduModel.ref.child("teams").child(teamID).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//                if !snapshot.exists() {
//                    print("snapshot doesnt exist")
//                }
//                let team = Team(snapshot: snapshot)
//                self.teams.append(team)
//                completionHandler()
//            })
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in the sample data structure.
        
        var count = 0
        
        for i in 0..<self.leaderboards.count {
            if tableView == self.leaderboards[i] {
                if (i < self.SharedFunduModel.leagues.count) { // got index out of range, unsure why leaderboards and leagues length isnt the same
                    count = self.SharedFunduModel.leagues[i].teams.count
                }
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:LeaguesTableViewCell?
        
        for i in 0..<self.leaderboards.count {
            if tableView == self.leaderboards[i] {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell\(i)", for: indexPath) as? LeaguesTableViewCell
                let team = teams[i][indexPath.row]
                    print(team.teamName)
                    cell?.titleLabel!.text = team.teamName
                    
                    if indexPath.row == 0 { // gold
                        cell?.titleLabel!.textColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1.0)
                    } else if indexPath.row == 1 { // silver
                        cell?.titleLabel!.textColor = UIColor(red: 0.8392, green: 0.8392, blue: 0.8392, alpha: 1.0)
                    } else if indexPath.row == 2 { // bronze
                        cell?.titleLabel!.textColor = UIColor(red: 0.804, green: 0.498, blue: 0.196, alpha: 1.0)
                    }
                    let index = self.timeframeSegmentedControls[i].selectedSegmentIndex
                    let selectedTimeFrame = self.timeframesArray[index]
                    // let teamTimeFrames = team[team.keys.first!]! as! NSDictionary
                    // let value = ((teamTimeFrames.value(forKey: String(describing: selectedTimeFrame)) as! NSNumber).floatValue)
                    let value = Float(arc4random()) / 0xFFFFFFFF
                    var percentage = value*100
                    if percentage < 0 { // if percentage is negative
                        cell?.stockLabel?.textColor = UIColor.red
                        percentage = fabs(percentage)
                    } else {
                        cell?.stockLabel?.textColor = UIColor.green
                    }
                    cell?.stockLabel?.text = "\(percentage)%"
                    return cell!
            }
        }
        return cell!
    }
    
    @objc func moveToNextPage() {
        let page = Int(mainLeaguesScrollView.contentOffset.x / mainLeaguesScrollView.frame.size.width)
        self.mainLeaguesScrollView.contentOffset = CGPoint(x: self.mainLeaguesScrollView.frame.size.width*CGFloat(page+1), y: 0)
        sortTableViews(index: timeframeSegmentedControls[page+1].selectedSegmentIndex)
        refreshTableViews()
    }
    
    @objc func moveToPrevPage() {
        let page = Int(mainLeaguesScrollView.contentOffset.x / mainLeaguesScrollView.frame.size.width);
        self.mainLeaguesScrollView.contentOffset = CGPoint(x: self.mainLeaguesScrollView.frame.size.width*CGFloat(page-1), y: 0)
        sortTableViews(index: timeframeSegmentedControls[page-1].selectedSegmentIndex)
        refreshTableViews()
    }
    
    func sortAllLeagues() {
        for i in 0..<SharedFunduModel.leagues.count {
            for j in 0..<self.timeframesArray.count {
                let selectedTimeFrame = timeframesArray[j]
//                self.SharedFunduModel.leagues[i].teams.sort(by: {
//                    let teamTimeFrames1 = $0[$0.keys.first!]! as! NSDictionary
//                    let value1 = ((teamTimeFrames1.value(forKey: String(describing: selectedTimeFrame)) as! NSNumber).floatValue)
//                    let teamTimeFrames2 = $1[$1.keys.first!]! as! NSDictionary
//                    let value2 = ((teamTimeFrames2.value(forKey: String(describing: selectedTimeFrame)) as! NSNumber).floatValue)
//                    return value1 > value2
//                }) TODO
            }
        }
        refreshTableViews()
    }
    
    func sortTableViews(index: Int) {
        let selectedTimeFrame = timeframesArray[index]
        let page = Int(mainLeaguesScrollView.contentOffset.x / mainLeaguesScrollView.frame.size.width);
        print("page: \(page), selectedTimeFrame: \(selectedTimeFrame)")
//        self.SharedFunduModel.leagues[page].teams.sort(by: {
//            let teamTimeFrames1 = $0[$0.keys.first!] as! NSDictionary
//            let value1 = ((teamTimeFrames1.value(forKey: String(describing: selectedTimeFrame)) as! NSNumber).floatValue)
//            let teamTimeFrames2 = $1[$1.keys.first!] as! NSDictionary
//            let value2 = ((teamTimeFrames2.value(forKey: String(describing: selectedTimeFrame)) as! NSNumber).floatValue)
//            return value1 > value2
//        })
    }
    
    func refreshTableViews() {
        for i in 0..<self.leaderboards.count {
            self.leaderboards[i].reloadData()
        }
    }
    
    @objc func createNewLeague() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        let leagueName = alert.addTextField("League Name: ")
        alert.addButton("Create League!") {
            //if textfields are both not empty, create new user (in firebase and model) and segway to parties
            if(leagueName.text != "") {
                    self.SharedFunduModel.newLeague(league: League(name: leagueName.text!))
                    }
                }
        alert.showInfo("Create New League", subTitle: "")
    }
    
    func setNavBar() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        self.view.addSubview(navBar)
        addBackButton()
    }
    
    func addBackButton() {
        let navItem = UINavigationItem(title: "Leagues")
        let backButton = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(backAction))
        let createLeagueButton = UIBarButtonItem(image: UIImage(named: "increase"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(createNewLeague))
       // let backButton = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backAction))
        navItem.leftBarButtonItem = backButton
        self.navBar.setItems([navItem], animated: false)
    }
    
    @objc func backAction(_ sender: UIButton) {
        print("backaction")
        self.openMenu()
    }
    
    func openMenu() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.drawerController.setDrawerState(.opened, animated: true)
    }
    
    @objc func inviteToLeagueButtonPressed() {
        let page = Int(mainLeaguesScrollView.contentOffset.x / mainLeaguesScrollView.frame.size.width);
        let currentLeague = SharedFunduModel.leagues[page]
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        let teamName = alert.addTextField("Team / Member Name: ")
        alert.addButton("Invite") {
            //if textfields are both not empty, create new user (in firebase and model) and segway to parties
            if(teamName.text != "") {
                // SEARCH TEAMS ON FIREBASE TO CHECK IF EXISTS
                self.SharedFunduModel.ref.child("teams").observeSingleEvent(of: .value, with: { (snapshot) in
                    let teamNameEntered = teamName.text!
                    if snapshot.hasChild(teamNameEntered){
                        let snapshotValue = snapshot.value as! [String: AnyObject]
                        let team = Team(dictionary: snapshotValue["\(teamNameEntered)"] as! NSDictionary)
                        self.SharedFunduModel.addTeamToLeague(newTeam: team, league: currentLeague)
                    } else{
                        // TODO handle team doesn't exist, check individual members
                        self.SharedFunduModel.ref.child("members").observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.hasChild(teamNameEntered) {
                                let snapshotValue = snapshot.value as! [String: AnyObject]
                                print("snapshot: \(snapshotValue)")
                                let member = User(dictionary: snapshotValue["\(teamNameEntered)"] as! NSDictionary )
                                self.SharedFunduModel.addTeamToLeague(newTeam: Team(member: member), league: currentLeague)
                            } else {
                                // TODO neither team or member exists, invalid entry. Handle
                                SCLAlertView().showError("Team / User doesn't exist", subTitle: "Please enter another team / user name")
                            }
                        })
                    }
                })
            }
        }
        alert.showInfo("Invite team to \(currentLeague.leagueName)", subTitle: "")
    }
    
    @objc func leagueChatButtonPressed() {
        print("chat")
        let chatVC = FirebaseChatViewController()
        let page = Int(mainLeaguesScrollView.contentOffset.x / mainLeaguesScrollView.frame.size.width);
        let currentLeague = SharedFunduModel.leagues[page]
        chatVC.channelRef = SharedFunduModel.ref.child("leagues").child(currentLeague.leagueID)
        chatVC.senderDisplayName = SharedFunduModel.myUser.username
        chatVC.title = "\(currentLeague.leagueName) chat"
            //TODO show chat VC
        self.navigationController?.pushViewController(chatVC, animated: true)
        
    }
    
    @objc func handleSwipeLeftOpenMenu(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == UISwipeGestureRecognizerDirection.left {
            let page = Int(mainLeaguesScrollView.contentOffset.x / mainLeaguesScrollView.frame.size.width)
            if page == 0 {
                self.openMenu()
            }
        }
    }
    
    @objc func viewLeagueTeamInvestingProfileButtonPressed() {
        print("view league team investing profile")
    }

    func addNewLeagueView(newLeague: League, position: Int) {
        // leagueView.alpha = 0.8
        let xPosition = self.mainLeaguesScrollView.frame.width * CGFloat(position)
        print("xPos: \(xPosition) i: \(position) name: \(newLeague.leagueName) ")
        let leagueView = UIView(frame: CGRect(x: xPosition+10, y: 25, width: self.mainLeaguesScrollView.frame.width-20, height: self.mainLeaguesScrollView.frame.height-35))
        leagueView.backgroundColor = getRandomColor()
        if position == 1 {
            leagueView.backgroundColor = UIColor.red
        }
        
        let leagueNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: leagueView.bounds.width, height: leagueView.bounds.height/12))
        // let leagueNameLabel = UILabel(frame: CGRect(x: leagueView.frame.minX, y: leagueView.frame.minY, width: leagueView.frame.width, height: leagueView.frame.height/3))
        leagueNameLabel.text = newLeague.leagueName
        leagueNameLabel.numberOfLines = 0
        leagueNameLabel.adjustsFontSizeToFitWidth = true
        leagueNameLabel.textAlignment = .center
        leagueView.addSubview(leagueNameLabel)
        
        // TODO
        // Show money amount if team is in the league
//        if let usersTeamIndex = newLeague.teams.index(where: {
//            ($0 as! Team).members.contains(where: {
//                $0 == SharedFunduModel.myUser.username
//            })
//        }) {
            let leagueMoneyLabel = UILabel(frame: CGRect(x: 0, y: leagueView.bounds.height/12, width: leagueView.bounds.width, height: 2*leagueView.bounds.height/12))
            // let leagueNameLabel = UILabel(frame: CGRect(x: leagueView.frame.minX, y: leagueView.frame.minY, width: leagueView.frame.width, height: leagueView.frame.height/3))
            //let team = newLeague.teams[usersTeamIndex]
//            let portfolio = team["portfolio"] as! [String:Any]
//            let totalStats = portfolio["totalStats"] as! [String:Any]
            //leagueMoneyLabel.text = totalStats["currentValue"] as? String
            leagueMoneyLabel.text = String(describing: arc4random())
            leagueMoneyLabel.adjustsFontSizeToFitWidth = true
            leagueMoneyLabel.textAlignment = .center
            leagueView.addSubview(leagueMoneyLabel)
        //}

        if position < SharedFunduModel.leagues.count-1 {
            let rightImageButton = UIButton(frame: CGRect(x: leagueView.bounds.width-40, y: leagueView.bounds.height/12, width: 30, height: 30))
            rightImageButton.setBackgroundImage(UIImage(named: "arrowRight"), for: .normal)
            rightImageButton.addTarget(self, action: #selector(moveToNextPage), for: .touchUpInside)
            
            leagueView.addSubview(rightImageButton)
        }
        
        if position != 0 {
            let leftImageButton = UIButton(frame: CGRect(x: 10, y: leagueView.bounds.height/12, width: 30, height: 30))
            leftImageButton.setBackgroundImage(UIImage(named: "arrowLeft"), for: .normal)
            leftImageButton.addTarget(self, action: #selector(moveToPrevPage), for: .touchUpInside)
            
            leagueView.addSubview(leftImageButton)
        }
        
        let inviteToLeagueButton = UIButton(frame: CGRect(x: 10, y: 2*leagueView.bounds.height/12, width: 30, height: 30))
        inviteToLeagueButton.setBackgroundImage(UIImage(named: "invite"), for: .normal)
        inviteToLeagueButton.addTarget(self, action: #selector(inviteToLeagueButtonPressed), for: .touchUpInside)
        leagueView.addSubview(inviteToLeagueButton)
        
        let viewLeagueTeamInvestingProfileButton = UIButton(frame: CGRect(x: (leagueView.bounds.width/2)-15, y: 2*leagueView.bounds.height/12, width: 30, height: 30))
        viewLeagueTeamInvestingProfileButton.setBackgroundImage(UIImage(named: "portfolio"), for: .normal)
        viewLeagueTeamInvestingProfileButton.addTarget(self, action: #selector(viewLeagueTeamInvestingProfileButtonPressed), for: .touchUpInside)
        leagueView.addSubview(viewLeagueTeamInvestingProfileButton)
        
        let leagueChatButton = UIButton(frame: CGRect(x: leagueView.bounds.width-40, y: 2*leagueView.bounds.height/12, width: 30, height: 30))
        leagueChatButton.setBackgroundImage(UIImage(named: "messages"), for: .normal)
        leagueChatButton.addTarget(self, action: #selector(leagueChatButtonPressed), for: .touchUpInside)
        leagueView.addSubview(leagueChatButton)
        
        let timeframeSegmentedControl = UISegmentedControl(items: timeframesArray)
        timeframeSegmentedControl.frame = CGRect(x: 0, y: 3*leagueView.bounds.height/12, width: leagueView.bounds.width, height: leagueView.bounds.height/12)
        timeframeSegmentedControl.selectedSegmentIndex = 0
        timeframeSegmentedControl.backgroundColor = UIColor.lightGray
        timeframeSegmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.black], for: .selected)
        timeframeSegmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.black], for: .normal)
        
        timeframeSegmentedControl.addTarget(self, action: #selector(self.changeTimeFrame(sender:)), for: .valueChanged)
        timeframeSegmentedControls.append(timeframeSegmentedControl)
        leagueView.addSubview(timeframeSegmentedControl)
        sortTableViews(index: 0)
        let tableView = UITableView(frame: CGRect(x: 0, y: leagueView.bounds.height/3, width: leagueView.bounds.width, height: (2*leagueView.bounds.height)/3), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LeaguesTableViewCell.self, forCellReuseIdentifier: "cell\(position)")
        tableView.alpha = 1
        leaderboards.append(tableView)
        leagueView.addSubview(tableView)
        
        mainLeaguesScrollView.contentSize.width = mainLeaguesScrollView.frame.width * CGFloat(position+1)
        mainLeaguesScrollView.addSubview(leagueView)
    }
}

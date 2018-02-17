//
//  FeedViewController.swift
//  fundü
//
//  Created by Jordan Coppert on 12/2/17.
//  Copyright © 2017 fundü. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    var username:String!
    var token:String!
    //var delegate: CenterViewControllerDelegate?
    var tableView: UITableView!
    var dailyStats: [DailyStat]!
    var feedEvents: [FeedEvent]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate = (self.parent?.parent?.parent as! CenterViewControllerDelegate)
        self.view.backgroundColor = UIColor(red:0.21, green:0.84, blue:0.72, alpha:1.0)
        
        dailyStats = getDailyStats()
        feedEvents = getSummaryFeedEvents()
        setNavButtons()
        createTableView()
        createSearch()
        setConstraints()
    }
    
    func createSearch() {
        
    }
    
    func getDailyStats() -> [DailyStat] {
        //Stubbing this for sake of the demo
        var stats = [DailyStat]()
        stats = [DailyStat(image: "votes", message: "3 actions waiting for your vote!"),
                 DailyStat(image: "earnings", message: "You've earned $57.73 across all groups today!"),
                 DailyStat(image: "increase", message: "You're AAPL shares in RainMakers have increase 3% today!"),
                 DailyStat(image: "challenge", message: "You're the top earner among your friends this week."),
                 DailyStat(image: "newChallenges", message: "Check social for new challenges, complete them first for extra points!")]
        return stats
    }
    
    func getSummaryFeedEvents() -> [FeedEvent]{
        //Stubbing this for sake of the demo
        var events = [FeedEvent]()
        events = [FeedEvent(image: "user1", message: "Jordan Coppert just passed you on the leaderboards! Complete more challenges to catch back up.", time: "now", type: .other),
                  FeedEvent(image: "company1", message: "GOOGL announces acquisition of large augmented reality firm.", time: "3 hrs", type: .company("GOOGL")),
                  FeedEvent(image: "user2", message: "Myrl Marmarelis just joined your group RainMakers, send a message to welcome them!", time: "1 hr", type: .other),
                  FeedEvent(image: "user3", message: "Nick Kaimakis just purchased AAPL at $27.59 a share.", time: "Yesterday", type: .company("AAPL")),
                  FeedEvent(image: "company2", message: "TSLA stock up 7% after semi announcement, buy now!", time: "6 hrs", type: .company("TSLA"))]
        return events
    }
    
    func setNavButtons(){
        //let leftBarButton = UIBarButtonItem(image: UIImage(named: "menu") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(showMenu))
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "messages") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(showMessages))
        
        //self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
        
    }
    
    func createTableView(){
        let barHeight = UIApplication.shared.statusBarFrame.size.height
        let displayWidth = self.view.frame.width
        let displayHeight = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.register(FeedCollectionTableViewCell.self, forCellReuseIdentifier: "FeedCollectionTableViewCell")
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "FeedTableViewCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(red:0.21, green:0.84, blue:0.72, alpha:1.0)
        self.view.addSubview(tableView)
    }
    
    func setConstraints(){
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
//    @objc func showMenu(){
//        delegate?.toggleLeftPanel?()
//    }
    
    @objc func showMessages(){
        let chatViewController = ChatViewController()
        chatViewController.username = (self.parent!.parent as! DashboardViewController).username
        let controller = UINavigationController(rootViewController: chatViewController)
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        self.parent!.parent!.present(controller, animated: true, completion: nil) // todo make nicer
    }

}

extension FeedViewController: UITableViewDelegate {
    //Prevent highlight of cell after tap
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        if let eventCell = cell as? FeedTableViewCell {
            let event = eventCell.event!
            switch event.type {
            case .company(let ticker):
                let companyView = CompanyViewController()
                companyView.ticker = ticker
                companyView.username = self.username
                let controller = UINavigationController(rootViewController: companyView)
                self.present(controller, animated: true)
            case .other:
                break
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedEvents.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCollectionTableViewCell") as! FeedCollectionTableViewCell
            cell.setupViews(stats:dailyStats)
            cell.backgroundColor = UIColor(red:0.21, green:0.84, blue:0.72, alpha:1.0)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as! FeedTableViewCell
            cell.setupViews(feedEvent:feedEvents[indexPath.row - 1])
            cell.backgroundColor = UIColor(red:0.21, green:0.84, blue:0.72, alpha:1.0)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0) {
            return 200
        }
        else {
            return 100
        }
    }
}





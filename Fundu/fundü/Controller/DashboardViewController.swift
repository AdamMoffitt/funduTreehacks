//
//  DashboardViewController.swift
//  fundü
//
//  Created by Nicholas Kaimakis on 12/2/17.
//  Copyright © 2017 fundü. All rights reserved.
//

import UIKit

class DashboardViewController: UITabBarController {
    var username: String!
    var token:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.21, green:0.84, blue:0.72, alpha:1.0)
        setTabBarController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Set titles here because if it's done in viewDidLoad second tab won't have
    //Title until it's tapped
    func setTabBarController(){
        let feed = FeedViewController()
        feed.title = "Feed"
        feed.token = token
        feed.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "feed"), tag: 0)
        
        let social = SocialViewController()
        social.title = "Social"
        social.token = token
        social.tabBarItem = UITabBarItem(title: "Social", image: UIImage(named: "social"), tag: 1)
        
        let controllers = [feed,social]
        self.viewControllers = controllers.map {UINavigationController(rootViewController: $0)}
        
        //Color for navs
        let nav1 = controllers[0] as? UINavigationController
        nav1?.navigationBar.tintColor = UIColor.green
        let nav2 = controllers[1] as? UINavigationController
        nav2?.navigationBar.tintColor = UIColor.red
        
    }

}

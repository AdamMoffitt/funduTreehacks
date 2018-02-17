//
//  LeftDrawerTableViewController.swift
//  Fundu
//
//  Created by Adam Moffitt on 1/17/18.
//  Copyright © 2018 Adam's Apps. All rights reserved.
//

import UIKit
import KYDrawerController
import SCLAlertView

class LeftDrawerTableViewController: UITableViewController {
    
    let backgroundImage = UIImage(named: "purpleBackground")
    var menu = ["DashBoard", "Profile", "Leagues", "Market", "Settings", "Logout"]
    let SharedFunduModel = FunduModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LabelCell")
        
        // TODO add background
//        let backgroundImage = UIImage(named: "purpleBackground")
//        let imageView = UIImageView(image: backgroundImage)
//        imageView.contentMode = .scaleAspectFill
//        self.tableView.backgroundView = imageView
        
        /* to blur background image
         let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
         let blurView = UIVisualEffectView(effect: blurEffect)
         blurView.frame = imageView.bounds
         imageView.addSubview(blurView)
         */
        
        // no lines where there aren't cells
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = .clear
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = menu[indexPath.row] as! String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        
        switch (indexPath.row) {
            case 0:do {
                let dashboardVC = DashboardViewController()
                appDel.drawerController.mainViewController = dashboardVC
            }
            case 1:do{
                
            }
            case 2:do {
                let leaguesVC = LeaguesViewController()
                let navigationController = UINavigationController(rootViewController: leaguesVC)
                navigationController.title = "Leagues"
                let btnMenu = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(showMenu))
                let btnAddLeagues = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(createNewLeague))
                navigationController.topViewController?.navigationItem.leftBarButtonItem = btnMenu
                navigationController.topViewController?.navigationItem.rightBarButtonItem = btnAddLeagues
                appDel.drawerController.mainViewController = navigationController
                break;
            }
            case 3:do {
                let marketVC = MarketViewController()
                appDel.drawerController.mainViewController = marketVC
            }
            case 4:do {
            }
            case 5:do {
                }
            default:do {
                let leaguesVC = LeaguesViewController()
                appDel.drawerController.mainViewController = leaguesVC
                }
        }
    }
    
    @objc func showMenu() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.drawerController.setDrawerState(.opened, animated: true)
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
    
}



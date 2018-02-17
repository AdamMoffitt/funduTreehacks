//
//  SlideMenuViewController.swift
//  fundü
//
//  Created by Jordan Coppert on 12/3/17.
//  Copyright © 2017 fundü. All rights reserved.
//

import UIKit

class SlideMenuViewController: UIViewController {
    var tableView:UITableView!
    //Some kind of container for the options
    var menuOptions = ["Profile", "Leagues", "Market", "Settings", "Logout"]
    var username: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        setConstraints()
    }
    
    func createTableView(){
        let barHeight = UIApplication.shared.statusBarFrame.size.height
        let displayWidth = self.view.frame.width
        let displayHeight = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.register(SlideMenuCell.self, forCellReuseIdentifier: "slideMenuCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.gray
        self.view.addSubview(tableView)
    
    }
    
    func setConstraints(){
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}


extension SlideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //define actions for various buttons
        switch indexPath.row{
        case 0:
            let profViewController = ProfileViewController()
            profViewController.username = self.username
            present(profViewController, animated: true, completion: nil)
        case 1: //groups
            let leaguesVC = LeaguesViewController()
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.window?.rootViewController = leaguesVC
            appDel.window?.makeKeyAndVisible()
//
//            present(leaguesVC, animated: true, completion: nil)
        case 2: //market
            let marketVC = MarketViewController()
            present(marketVC, animated: true, completion: nil)
            break
        case 3: //settings
            break
        case 4: //logout
            break
        default:
            print("selected option not implemented")
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension SlideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Placeholder
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Placeholder
        let cell = tableView.dequeueReusableCell(withIdentifier: "slideMenuCell") as! SlideMenuCell
        cell.setupViews(text:menuOptions[indexPath.row])
        return cell
    }
}

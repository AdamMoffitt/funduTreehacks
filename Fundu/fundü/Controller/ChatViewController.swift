//
//  ChatViewController.swift
//  fundü
//
//  Created by Myrl Marmarelis on 12/5/17.
//  Copyright © 2017 fundü. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatViewController: UITableViewController, SBDChannelDelegate {
    var username:String! = "test"
    var token:String!
    var channels:[SBDGroupChannel]?
    var selectedChannel:SBDGroupChannel?
    var groupViewController:GroupViewController?
    let unique_identifier:String = "lit ass chat view"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.21, green:0.84, blue:0.89, alpha:0.8)
        self.setNavButtons()
        self.setupChatCell()
        self.connect() {
            self.justConnected()
        }
        // Do any additional setup after loading the view.
    }
    
    func connect(_ handler: @escaping ()->()) {
        SBDMain.add(self as SBDChannelDelegate, identifier: unique_identifier)
        if SBDMain.getConnectState() != SBDWebSocketConnectionState.open {
            SBDMain.connect(withUserId: username) { (user, error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                print("CONNECTED")
                handler()
                //SBDMain.updateCurrentUserInfo(withNickname: , profileUrl: , completionHandler: ) use this to set nicknames
            }
        } else {
            handler() // handler? I HARDLY KNOW HER
        }
    }
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        let userMessage = message as! SBDUserMessage
        print(userMessage.message!)
        if sender == selectedChannel {
            self.groupViewController!.receive(userMessage)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func send(_ text: String) {
        self.selectedChannel!.sendUserMessage(text, completionHandler: { (message, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            self.channel(self.selectedChannel!, didReceive: message!)
        })
    }
    
    func setNavButtons(){
        let newChatButton = UIBarButtonItem(title: "New Group",
                                            style: UIBarButtonItemStyle.plain,
                                            target: self, action: #selector(newChat))
        self.navigationItem.setRightBarButton(newChatButton, animated: false)
        let closeButton = UIBarButtonItem(title: "Back",
                                          style: UIBarButtonItemStyle.plain,
                                          target: self, action: #selector(close))
        self.navigationItem.setLeftBarButton(closeButton, animated: false)
    }
    
    @objc func newChat() {
        let alert = UIAlertController(title: "Fund Name", message: "Enter the name of your group.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Create", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction) in
                let fields = alert.textFields!
                let name = fields[0].text!
                let users = fields[1].text!.split(separator: " ")
                self.createChannel(name, users: users.map {String($0)})
        })
        alert.addAction(action)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter here"
        })
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Names of the people to add"
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func createChannel(_ name: String, users: [String]) {
        SBDGroupChannel.createChannel(withName: name, userIds: users, coverUrl: nil, data: nil) {
            (channel, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
        }
        self.queryChannels()
    }
    
    @objc func close() {
        self.navigationController!.dismiss(animated: true) {
            SBDMain.removeChannelDelegate(forIdentifier: self.unique_identifier)
            print("LEFT")
        }
    }
    
    func justConnected() {
        self.queryChannels()
    }
    
    func queryChannels() {
        let query = SBDGroupChannel.createMyGroupChannelListQuery()!
        query.includeEmptyChannel = true
        query.loadNextPage() { (channels, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            print("You are in these channels:")
            for channel in channels! {
                print(channel.name)
            }
            self.channels = channels
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.channels ?? [SBDGroupChannel()]).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "ChatCell")
        if self.channels == nil {
            cell.textLabel?.text = "Loading..."
        } else {
            cell.textLabel?.text = self.channels![indexPath.row].name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.channels == nil {
            return
        }
        self.groupViewController = GroupViewController()
        self.groupViewController!.chatController = self
        let i = indexPath.row
        selectedChannel = channels![i]
        self.navigationController!.pushViewController(self.groupViewController!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setupChatCell() {
        // nothing here
    }
    
}

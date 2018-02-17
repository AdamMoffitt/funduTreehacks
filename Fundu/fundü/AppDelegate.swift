//
//  AppDelegate.swift
//  fundü
//
//  Created by Nicholas Kaimakis on 11/29/17.
//  Copyright © 2017 fundü. All rights reserved.
//

import UIKit
import SendBirdSDK
import KYDrawerController
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerController = KYDrawerController.init(drawerDirection: .left, drawerWidth: 300)


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SBDMain.initWithApplicationId("4045412B-A24C-4B9E-8A43-32E2FFA96C36")
        
        FirebaseApp.configure()
        
        //create new window (where all view controllers appear)
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //create new instance of view controller
        let loginViewController = AuthViewController()
        
        //set initial VC to our instance
        window?.rootViewController = loginViewController
        
        //present the window
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


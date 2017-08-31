//
//  AppDelegate.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 22/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //configureRootViewController()
        UIApplication.shared.statusBarStyle = .default
        //Change status bar color
        /*let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor(red: 81.0/255.0, green: 116.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        }*/
        UserDefaults.standard.set(false, forKey: "isStopRatingPlayers")
        UINavigationBar.appearance().barTintColor = CommonHelper.mainColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        configureRootViewController()
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

    func configureRootViewController() {
        
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        
        //isUserLoggedIn
        
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            guard let viewController = UIStoryboard(name: Screens.Main.name(), bundle: nil).instantiateInitialViewController() as? HomeViewController
                else{
                    return
            }
            newWindow.rootViewController = viewController
        }else{
            guard let viewController = UIStoryboard(name: Screens.Welcome.name(), bundle: nil).instantiateInitialViewController() as? WelcomeViewController
                else{
                    return
            }
             newWindow.rootViewController = viewController
        }
        
        
        
        newWindow.makeKeyAndVisible()
        newWindow.alpha = 0.0
        
        UIView.animate(withDuration: 0.33, animations: {
            newWindow.alpha = 1.0
            
        }, completion: { _ in
            self.window = newWindow
        })
        
    }


}


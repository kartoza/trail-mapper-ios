//
//  AppDelegate.swift
//  TrailMapper
//
//  Created by Tim Sutton on 2018/01/08.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let reachability = Reachability()!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Initliase the local database
        SCIDatabaseDAO.shared().initalizeDatabase(withDBName: TMConstants.TM_DATABASE_NAME)

        // Enable keyboard operations
        IQKeyboardManager.sharedManager().enable = true

        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }

        // To check that is there any recording is going or not
        TMUtility.sharedInstance.checkForRecordringStatus()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.startTrailSectionRecordingInBackgroundMode()
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

    @objc func reachabilityChanged(note: Notification) {

        let reachability = note.object as! Reachability

        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            self.syncAllDataBaseWithServer()
        case .cellular:
            print("Reachable via Cellular")
            self.syncAllDataBaseWithServer()
        case .none:
            print("Network not reachable")
        }
    }

    func syncAllDataBaseWithServer() {
        TMUtility.sharedInstance.syncLocalTrailDetailsWithServer()
        TMUtility.sharedInstance.syncLocalTrailSectionDetailsWithServer()
    }

    func startTrailSectionRecordingInBackgroundMode() {
        var bgTask = UIBackgroundTaskIdentifier()
        bgTask = UIApplication.shared.beginBackgroundTask { () -> Void in
            UIApplication.shared.endBackgroundTask(bgTask)
        }

        TMUtility.sharedInstance.saveRecordingTrailSectionUpdatesToLocalDB()

        if (bgTask != UIBackgroundTaskInvalid)
        {
            UIApplication.shared.endBackgroundTask(bgTask);
            bgTask = UIBackgroundTaskInvalid;
        }
    }

}


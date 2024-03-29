//
//  AppDelegate.swift
//  AirNotifierClient
//
//  Created by Dongsheng Cai on 6/11/2015.
//  Copyright © 2015 Dongsheng Cai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(app: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        initializeNotificationServices()
        return true
    }

    func application(app: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let deviceTokenStr = convertDeviceTokenToString(deviceToken)
        print( " Token: \(deviceTokenStr) " )
        let bundleId: String = NSBundle.mainBundle().bundleIdentifier!;
        print( "Bundle: \(bundleId) " )
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(deviceTokenStr, forKey: "token")
    }
    
    func application(app: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]){
        print(userInfo["aps"])
        let alert = UIAlertController(title: "Oops!", message:"This feature isn't available right now", preferredStyle: .Alert)
        let notificationDict : AnyObject? =  userInfo["aps"]!["alert"]
        alert.message = notificationDict as? String
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
        self.window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
    }

    func application(app: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        // inspect notificationSettings to see what the user said!
    }

    func applicationWillResignActive(app: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(app: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(app: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(app: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(app: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func initializeNotificationServices() -> Void {
        print("Requesting permission for push notifications...");
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }

    func convertDeviceTokenToString(token: NSData) -> NSString {
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        let deviceTokenString: String = ( token.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        return deviceTokenString
    }
}


//
//  AppDelegate.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 9/3/24.
//

import UIKit
import OneSignalFramework

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // Remove this method to stop OneSignal Debugging
         OneSignal.Debug.setLogLevel(.LL_VERBOSE)
         
         // OneSignal initialization
         OneSignal.initialize("cd253220-f1b1-4b46-9307-37cf176768a9", withLaunchOptions: launchOptions)
         
         // requestPermission will show the native iOS notification permission prompt.
         // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
         OneSignal.Notifications.requestPermission({ accepted in
          // print("User accepted notifications: \(accepted)")
         }, fallbackToSettings: true)
         
         // Login your customer with externalId
         // OneSignal.login("EXTERNAL_ID")
        
        
       // UITabBar.appearance().unselectedItemTintColor = UIColor.gray
       // UITabBar.appearance().selectedImageTintColor = UIColor.black
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


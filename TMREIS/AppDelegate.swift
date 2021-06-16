//
//  AppDelegate.swift
//  TMREIS
//
//  Created by deep chandan on 26/04/21.
//

import UIKit
import SideMenuSwift
import IQKeyboardManagerSwift
import UserNotifications


@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
    

        setupSidememu()
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
    func setupSidememu()
    {
        SideMenuController.preferences.basic.menuWidth = UIScreen.main.bounds.width * 0.7
        SideMenuController.preferences.basic.defaultCacheKey = "Officer"
        SideMenuController.preferences.basic.enablePanGesture = true
      
        

    }

}

//@available(iOS 13.0, *)
//extension AppDelegate : MessagingDelegate , UNUserNotificationCenterDelegate
//{
//    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        debugPrint("fcm token :- \(fcmToken)")
//        guard let fcmToken = fcmToken else { UserDefaults.standard.setValue(" ", forKey: "fcmToken");return}
//        UserDefaults.standard.setValue(fcmToken, forKey: "fcmToken")
//    }
//    
////    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
////        debugPrint(remoteMessage)
////    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert , .badge , .sound])
//    }
//    
//}

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
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        setupSidememu()
        registerForPushNotifications()
    
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func registerForPushNotifications() {
        //1
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current()
            //2
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                //3
                print("Permission granted: \(granted)")
                guard granted else {return}
                UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                    guard settings.authorizationStatus == .authorized else {return}
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                })
            }
    }
    func setupSidememu()
    {
        SideMenuController.preferences.basic.menuWidth = UIScreen.main.bounds.width * 0.7
        SideMenuController.preferences.basic.defaultCacheKey = "Officer"
        SideMenuController.preferences.basic.enablePanGesture = true

    }
   // func openDashboard()
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("application registered for remote notifications")
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remotenotifications \(error.localizedDescription)")
    }

}

//@available(iOS 13.0, *)
extension AppDelegate : MessagingDelegate , UNUserNotificationCenterDelegate
{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        debugPrint("fcm token :- \(fcmToken ?? "")")
        guard let fcmToken = fcmToken else {return}
        UserDefaultVars.fcmToken = fcmToken
    }
    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    
//        debugPrint(remoteMessage)
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification.request.content.body)
        completionHandler([.alert , .badge , .sound])
    }
    
}

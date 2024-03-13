//
//  AppDelegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import UIKit
import CoreData
import UserNotifications
import FirebaseMessaging
import FirebaseCore
import Starscream
import Web3Wallet
import Combine
import WalletConnectNotify
import Auth
import WalletConnectPairing
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            print(urls[urls.count-1] as URL)
        Thread.sleep(forTimeInterval: 2)
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        self.registerForPushNotifications()
      
        return true
     } 
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
//        if url.scheme == "wc" {
//            // Handle the deep link URL here
//            // Extract and process the information from the URL
//            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
//            // Access components.queryItems to get parameters
//
//            // Return true to indicate that the URL was handled
//            return true
//        }
//
//        return false
//    }
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
     } 
    
    /// pair to client
    func pairClient(uri: String) {
        print("[WALLET] Pairing to: \(uri)")
        guard let uri = WalletConnectURI(string: uri) else {
            return
        }
        Task {
            do {
                try await Web3Wallet.instance.pair(uri: uri)
                
            } catch {
               
                print("[DAPP] Pairing connect error: \(error)")
            }
        }
    }

//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        // Handle the user activity here
//        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
//            // This is a universal link
//            if let url = userActivity.webpageURL {
//                
//                do {
//                    let uri = try WalletConnectURI(deeplinkUri: url)
//                    Task {
//                        try await Web3Wallet.instance.pair(uri: uri)
//                    }
//                } catch {
//                    // Handle the error here
//                    print("Error: \(error)")
//                }
//                // Handle the URL, for example, by opening a specific view controller
//                // or performing some action in your app
//            }
//        } else {
//            // Handle other types of user activities
//        }
//
//        // Call the restorationHandler with any objects that can respond to the user activity
//        restorationHandler(nil)
//
//        // Return true to indicate that the user activity was handled
//        return true
//    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
     } 
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "PlutoPe")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
         })
        return container
     }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
              } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
             } 
         } 
     } 
    
 }
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let takeParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = takeParts.joined()
        
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    //MARK:- Notification Delegate method
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        print(userInfo)
        
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Fail notification:\(error.localizedDescription)")
    }
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
       
        let aps = notification.request.content.userInfo[AnyHashable("aps")] as? NSDictionary
//        let type = (aps?.value(forKey: "notification_type") as? String ?? "").lowercased()
        let type = (notification.request.content.userInfo[AnyHashable("type")] as? String ?? "").lowercased()
        print(type)
        
        print(userInfo)
        
        completionHandler( [.alert, .badge, .sound])
        }
    
    //MARK:- notification click event herer
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        let type = (response.notification.request.content.userInfo[AnyHashable("type")] as? String ?? "").lowercased()
      
        completionHandler()
    }
}
// MARK: - MessagingDelegate

extension AppDelegate : MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("DeviceToken:\(fcmToken ?? "")")
        UserDefaults.standard.setValue(fcmToken, forKey: "fcm_Token")
        // self.ApiSentToken()
        
    }
}
extension UIApplication {
    static var currentWindow: UIWindow {
        return UIApplication.shared.connectedScenes
            .compactMap { $0.delegate as? SceneDelegate }
            .first!.window!
    }
}

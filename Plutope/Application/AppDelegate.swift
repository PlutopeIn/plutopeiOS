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
import Firebase
import FirebaseCore
import Starscream
import ReownWalletKit
import Combine
import WalletConnectNotify
import WalletConnectPairing
import IQKeyboardManagerSwift
//import FirebaseCrashlytics
// import AppsFlyerLib
// import AppTrackingTransparency
import FirebaseDynamicLinks
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var conversionData: [AnyHashable: Any]? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        Thread.sleep(forTimeInterval: 1.5)
        FirebaseApp.configure()
        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = "plutope"
        
        //  Handle Firebase Dynamic Link when app is launched from a cold start
          if let userActivityDictionary = launchOptions?[.userActivityDictionary] as? [AnyHashable: Any],
             let userActivity = userActivityDictionary["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity,
             let incomingURL = userActivity.webpageURL {
              
              DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLink, error in
                  if let error = error {
                      print("Error handling universal link: \(error.localizedDescription)")
                      return
                  }
                  
                  if let dynamicLink = dynamicLink, let deepLinkURL = dynamicLink.url {
                      self.processDynamicLink(deepLinkURL)
                  }
              }
          }
          
          //  Handle dynamic link if the app was installed and launched from the App Store
          if let url = launchOptions?[.url] as? URL {
              if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url),
                 let deepLinkURL = dynamicLink.url {
                  self.processDynamicLink(deepLinkURL)
              }
          }
        
//        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        UIViewController.swizzleViewDidAppear()
        let appVersion = UserDefaults.standard.value(forKey: appUpdatedFlagValue) as? String ?? ""
        print("appVersion",appVersion)
        UserDefaults.standard.set(appUpdatedFlagUpdate, forKey: isFromAppUpdatedKey)
        
        if appVersion == "" {
            UserDefaults.standard.set(appUpdatedFlag, forKey: appUpdatedFlagValue)
        }
       
       /* DispatchQueue.main.async {
            AppsFlyerLib.shared().appsFlyerDevKey = "Ei8muFP453CM2zbZKVuUS7"
            AppsFlyerLib.shared().appleAppID = "6466782831"
            AppsFlyerLib.shared().isDebug = false
            // Optional
                   AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
            AppsFlyerLib.shared().delegate = self
                   NotificationCenter.default.addObserver(self,
                                                          selector: #selector(self.didBecomeActiveNotification),
                   // For Swift version < 4.2 replace name argument with the commented out code
                   name: UIApplication.didBecomeActiveNotification, //.UIApplicationDidBecomeActive for Swift < 4.2
                   object: nil)
        } */
        /// Enable IQKeyboardManager
        IQKeyboardManager.shared.isEnabled = true
        Messaging.messaging().delegate = self
        
        self.registerForPushNotifications()
       
        if UserDefaults.standard.bool(forKey: "isConnected") {
                    Task {
                        await onDelete()
                    }
                }
        return true
     } 

//    @objc func didBecomeActiveNotification() {
//           AppsFlyerLib.shared().start()
//           if #available(iOS 14, *) {
//             ATTrackingManager.requestTrackingAuthorization { (status) in
//               switch status {
//               case .denied:
//                   print("AuthorizationSatus is denied")
//               case .notDetermined:
//                   print("AuthorizationSatus is notDetermined")
//               case .restricted:
//                   print("AuthorizationSatus is restricted")
//               case .authorized:
//                   print("AuthorizationSatus is authorized")
//               @unknown default:
//                   fatalError("Invalid authorization status")
//               }
//             }
//           }
//       }
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        AppsFlyerLib.shared().start()
//    }
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
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url),
           let deepLinkURL = dynamicLink.url {
            self.processDynamicLink(deepLinkURL)
            return true
        }
        
        // If not a recognized dynamic link, check for the "plutope" custom URL scheme
        if let plutopeURL = URL(string: "plutope://"), UIApplication.shared.canOpenURL(plutopeURL) {
            // "plutope" app is installed; open it
            UIApplication.shared.open(plutopeURL, options: [:], completionHandler: nil)
        } else {
            // "plutope" app is not installed; redirect to the App Store
            if let appStoreURL = URL(string: "https://apps.apple.com/in/app/plutope-crypto-wallet/id6466782831") {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
        
        return false
    }

    // Process Dynamic Link and Extract Referral Code
    private func processDynamicLink(_ url: URL) {
        // Extract referral code
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems {
            for queryItem in queryItems {
                if queryItem.name == "referral", let referralCode = queryItem.value {
                    if !referralCode.isEmpty || referralCode != "" {
                        UserDefaults.standard.set(referralCode, forKey: "referralCode")
                        UserDefaults.standard.synchronize()
                    }
                  
                }
            }
        }
        }
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
                try await WalletKit.instance.pair(uri: uri)
                
            } catch {
               
             //   print("[DAPP] Pairing connect error: \(error)")
            }
        }
    }
    func onDelete() async {
        print("onDelete method started")

        let sessions = WalletKit.instance.getSessions()  // This should return active sessions
              guard let sessionTopic = sessions.first?.topic else {
        
            return
        }
       
        do {
            Task {
                try await WalletKit.instance.disconnect(topic: sessionTopic)
                UserDefaults.standard.set(false, forKey: "isConnected") // Reset the flag
                UserDefaults.standard.removeObject(forKey: "sessionName")
               // print("Session disconnected successfully")
            }
        } catch {
          //  print("Failed to disconnect session: \(error)")
        }
    }
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
        UserDefaults.standard.setValue(token, forKey: "deviceToken")
    }
    // MARK: - Notification Delegate method
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //print(userInfo)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Fail notification:\(error.localizedDescription)")
    }
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
       
        _ = notification.request.content.userInfo[AnyHashable("aps")] as? NSDictionary
        let type = (notification.request.content.userInfo[AnyHashable("type")] as? String ?? "").lowercased()
       // print("test1",type)
        
      //  print(userInfo)
        
        completionHandler( [.alert, .badge, .sound])
        }
    
    // MARK: - notification click event herer
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        _ = response.notification.request.content.userInfo
        _ = (response.notification.request.content.userInfo[AnyHashable("type")] as? String ?? "").lowercased()
     //   print("test2")
        completionHandler()
    }
}
// MARK: - MessagingDelegate

extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("DeviceToken:\(fcmToken ?? "")")
        UserDefaults.standard.setValue(fcmToken, forKey: "fcm_Token")
        
    }
}
extension UIApplication {
    static var currentWindow: UIWindow {
        return UIApplication.shared.connectedScenes
            .compactMap { $0.delegate as? SceneDelegate }
            .first!.window!
    }
}
//extension AppDelegate: AppsFlyerLibDelegate {
//     
//    // Handle Organic/Non-organic installation
//    func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
//        conversionData = data
//        print("onConversionDataSuccess data:")
//        for (key, value) in data {
//            print(key, ":", value)
//        }
//        
//        if let status = data["af_status"] as? String {
//            if (status == "Non-organic") {
//                if let sourceID = data["media_source"],
//                    let campaign = data["campaign"] {
//                    NSLog("[AFSDK] This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
//                }
//            } else {
//                NSLog("[AFSDK] This is an organic install.")
//            }
//            if let isFirstLaunch = data["is_first_launch"] as? Bool,
//               isFirstLaunch {
//                NSLog("[AFSDK] First Launch")
//            } else {
//                NSLog("[AFSDK] Not First Launch")
//            }
//        }
//    }
//    
//    func onConversionDataFail(_ error: Error) {
//        NSLog("[AFSDK] \(error)")
//    }
//}

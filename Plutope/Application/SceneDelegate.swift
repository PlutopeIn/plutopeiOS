//
//  SceneDelegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import UIKit
import IQKeyboardManagerSwift
import LocalAuthentication
import FirebaseCore
import FirebaseMessaging
import DGNetworkingServices
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var context = LAContext()
    var appCurrentVersion : Int = 1
    var appOldVersion : Int? = 0
    var forcefullyUpdate : Bool?
     func setRootView() {
        
        // ROOT
        if (UserDefaults.standard.object(forKey: DefaultsKey.splashVideoPlayed) as? Bool ?? false) {
            
            let walletStoryboard = UIStoryboard(name: "WalletRoot", bundle: nil)
            
            if UserDefaults.standard.string(forKey: DefaultsKey.mnemonic) == nil {
                let walletSetUpVC = WalletSetUpViewController()
                let navigationController = UINavigationController(rootViewController: walletSetUpVC)
                navigationController.setNavigationBarHidden(true, animated: false)
                window?.rootViewController = navigationController
            } else if let tabBarVC = walletStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
                window?.rootViewController = tabBarVC
            }
            
        } else {
            
            let avPlayer = VideoPlayerViewController()
            let navigationController = UINavigationController(rootViewController: avPlayer)
            navigationController.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = navigationController
            
        }
         window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        ///  app version check  Api Call
        apiCheckVerstion()
        if UserDefaults.standard.string(forKey: DefaultsKey.appLockMethod) == nil {
            UserDefaults.standard.set("Passcode/Touch ID/Face ID", forKey: DefaultsKey.appLockMethod)
        }
        /// Enable IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
         /// configure fierbase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        // Root set up
        setRootView()
        self.registerForPushNotifications()
    }
    // Add this method to your class where you set up your UI
    func updateSemanticContentAttribute() {
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            inputView?.semanticContentAttribute = .forceRightToLeft
        } else {
            inputView?.semanticContentAttribute = .forceLeftToRight
        }
    }
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
           
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
        UNUserNotificationCenter.current().delegate = self
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    func sceneWillEnterForeground(_ scene: UIScene) {
        /// Biometrics
        
        guard let rootVc = self.window?.rootViewController else {
            return
        }
        
        if let  _ = (rootVc as? UINavigationController)?.topViewController as? VideoPlayerViewController {
            return
        }
        
        AppPasscodeHelper().handleAppPasscodeIfNeeded(in: rootVc) { _ in }
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
}

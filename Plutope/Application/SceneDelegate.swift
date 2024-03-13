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
import Starscream
import Web3Wallet
import Combine
import WalletConnectNotify
import Auth
import WalletConnectPairing
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var context = LAContext()
    var appCurrentVersion : Int = 1
    var appOldVersion : Int? = 0
    var forcefullyUpdate : Bool?
    let projectId = Secrets.load().projectID
    var uri: WalletConnectURI?
    var requestSent = false
    private let app = Application()
//    func onImport() {
//        guard let account = ImportAccount(input:WalletData.shared.myWallet?.privateKey ?? "" )
//        else { return }
//        self.importAccount(account)
//        print(self.importAccount(account))
//    }
//    func importAccount(_ importAccount: ImportAccount) {
//        let accountStorage = AccountStorage(defaults: UserDefaults.standard)
//        app.accountStorage.importAccount = importAccount
//    }
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
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      
        ///  app version check  Api Call
        apiCheckVerstion()
        
        do {
            let uri = try WalletConnectURI(connectionOptions: connectionOptions)
            app.uri = uri
        } catch {
            print("Error initializing WalletConnectURI: \(error.localizedDescription)")
        }

        app.requestSent = (connectionOptions.urlContexts.first?.url.absoluteString.replacingOccurrences(of: "plutope://wc?", with: "") == "requestSent")
       
        if UserDefaults.standard.string(forKey: DefaultsKey.appLockMethod) == nil {
            UserDefaults.standard.set("Passcode/Touch ID/Face ID", forKey: DefaultsKey.appLockMethod)
        }
        /// Enable IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        // Root set up
        setRootView()
        //resetRootView()
       
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let context = URLContexts.first else { return }

        do {
            let uri = try WalletConnectURI(urlContext: context)
            Task {
                try await Web3Wallet.instance.pair(uri: uri)
            }
        } catch {
            // Handle the error here
            print("Error: \(error)")
        }
    }
     
    // Add this method to your class where you set up your UI
    func updateSemanticContentAttribute() {
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            inputView?.semanticContentAttribute = .forceRightToLeft
        } else {
            inputView?.semanticContentAttribute = .forceLeftToRight
        }
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

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
import ReownWalletKit
import Combine
import WalletConnectNotify
import WalletConnectPairing
// import AppsFlyerLib
import FirebaseDynamicLinks
import CoreData
var launchURL: URL?
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var context = LAContext()
    var appCurrentVersion : Int = 1
    var appOldVersion : Int? = 0
    var uri: WalletConnectURI?
    let session: Session? = nil
    var requestSent = false
    var primaryWallet: Wallets?
    var tokensList: [Token]? = []
    let app = Application()
    var activeToken: [ActiveTokens]? = []
    var appIsInForeground = false
    var handledWalletConnectURL = false
    var foregroundNotificationToken: NSObjectProtocol?
    var interactor = MainInteractor()
    
    func setRootView() {
        
        // ROOT
//    if (UserDefaults.standard.object(forKey: DefaultsKey.splashVideoPlayed) as? Bool ?? false) {
            let walletStoryboard = UIStoryboard(name: "WalletRoot", bundle: nil)
            
            if UserDefaults.standard.string(forKey: DefaultsKey.mnemonic) == nil {
                let walletSetUpVC = WalletSetUpViewController()
                let navigationController = UINavigationController(rootViewController: walletSetUpVC)
                navigationController.setNavigationBarHidden(true, animated: false)
                UserDefaults.standard.set("true", forKey: DefaultsKey.upadtedUser)
                window?.rootViewController = navigationController
                window?.makeKeyAndVisible()
            } else {
            
          let isNewUser =  UserDefaults.standard.value(forKey: DefaultsKey.newUser) as? Bool ?? false
            if isNewUser == false {
                let tabBarVC = TabBarViewController(interactor: interactor, app: app, configurationService: app.configurationService)
                window?.rootViewController = tabBarVC
                window?.makeKeyAndVisible()
            } else {
                let isUserUpdated  = UserDefaults.standard.value(forKey: DefaultsKey.upadtedUser) as? String ?? ""
                let appVersion = UserDefaults.standard.value(forKey: appUpdatedFlagValue) as? String ?? ""
                print("appVersion1",appVersion)
                if isUserUpdated == "true" && appVersion != "" {
                    let tabBarVC = TabBarViewController(interactor: interactor, app: app, configurationService: app.configurationService)
                    window?.rootViewController = tabBarVC
                    window?.makeKeyAndVisible()
                } else {
                
                let appVersion = UserDefaults.standard.value(forKey: appUpdatedFlagValue) as? String ?? ""
                let isFromAppUpdated  = UserDefaults.standard.value(forKey: isFromAppUpdatedKey) as? String ?? ""
                if appVersion == isFromAppUpdated {
                    let updateVc = UpdateVersionViewController()
                    let navigationController = UINavigationController(rootViewController: updateVc)
                    navigationController.setNavigationBarHidden(true, animated: false)
                    window?.rootViewController = navigationController
                    window?.makeKeyAndVisible()
                } else {
                    let tabBarVC = TabBarViewController(interactor: interactor, app: app, configurationService: app.configurationService)
                    window?.rootViewController = tabBarVC
                    window?.makeKeyAndVisible()
                }
            }
            }
            }
//        else if let tabBarVC = walletStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
//                window?.rootViewController = tabBarVC
//                window?.makeKeyAndVisible()
//                
//            }
       /* } else {
            
            let avPlayer = VideoPlayerViewController()
            let navigationController = UINavigationController(rootViewController: avPlayer)
            navigationController.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            
        }*/
//         window?.makeKeyAndVisible()
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
   
    func isTokenExpired() -> Bool {
        if let expirationDate = UserDefaults.standard.object(forKey: loginApiTokenExpirey) as? Date {
            return Date() > expirationDate
        }
        return true
    }
    func checkTokenAndRedirect() {
        if isTokenExpired() {
            redirectToLoginScreen()
        }
    }
    func redirectToLoginScreen() {
        // Assuming you have a LoginViewController
       
        }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        LoggingService.instance.configure()
        ///  app version check  Api Call
         configureWeb3WalletClientIfNeeded()
        app.requestSent = (connectionOptions.urlContexts.first?.url.absoluteString.replacingOccurrences(of: "plutope://wc?", with: "") == "requestSent")
        // Check if the app was opened via a URL context
            if let urlContext = connectionOptions.urlContexts.first {
                let url = urlContext.url
                
                // Attempt to handle the URL as a Firebase Dynamic Link
                if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
                    if let deepLinkURL = dynamicLink.url {
                        // Process the deep link URL as needed
                        self.handleIncomingDynamicLink(url: deepLinkURL)
                    }
                } else {
                    // If not a Dynamic Link, proceed with existing WalletConnect handling
                    handledWalletConnectURL = true
                    
                    // Handle the URL when the app becomes active
                    foregroundNotificationToken = NotificationCenter.default.addObserver(
                        forName: .sceneWillEnterForegroundCompleted,
                        object: nil,
                        queue: .main
                    ) { [weak self] _ in
                        guard let self = self else { return }
                        NotificationCenter.default.removeObserver(self.foregroundNotificationToken as Any)
                        self.foregroundNotificationToken = nil
                        self.handleDeepLinkFromMain(url)
                    }
                    
                    // If the app is already in the foreground, handle the URL immediately
                    if scene.activationState == .foregroundActive {
                        handleDeepLinkFromMain(url)
                    }
                }
            }
            
            // Handle dynamic links on cold launch via user activity
            if let userActivity = connectionOptions.userActivities.first,
               userActivity.activityType == NSUserActivityTypeBrowsingWeb,
               let incomingURL = userActivity.webpageURL {
                
                DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { [weak self] dynamicLink, error in
                    guard let self = self else { return }
                    if let dynamicLink = dynamicLink, let deepLinkURL = dynamicLink.url {
                        self.handleIncomingDynamicLink(url: deepLinkURL)
                    }
                }
            }
            
            if let url = connectionOptions.userActivities.first?.webpageURL ?? connectionOptions.urlContexts.first?.url {
                wasOpenedWithURL(url, onStart: true)
            }

        if UserDefaults.standard.string(forKey: DefaultsKey.appLockMethod) == nil {
            UserDefaults.standard.set("Passcode/Touch ID/Face ID", forKey: DefaultsKey.appLockMethod)
        }
        /// Enable IQKeyboardManager
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
            
        // Root set up
        setRootView()
     
    }
        func apiCheckVerstion() {
            let appVersion = UserDefaults.standard.value(forKey: appUpdatedFlagValue) as? String ?? ""
            if appVersion == "" {
                let updateVc = UpdateVersionViewController()
                let navigationController = UINavigationController(rootViewController: updateVc)
                navigationController.setNavigationBarHidden(true, animated: false)
                window?.rootViewController = navigationController
                window?.makeKeyAndVisible()
            } else {
                // Root set up
                setRootView()
            }
        }
    func configureWeb3WalletClientIfNeeded() {
        Networking.configure(
            groupIdentifier: "group.com.plutoPe",
            projectId: InputConfig.projectId,
            socketFactory: DefaultSocketFactory()
        )
        let metadata = AppMetadata(
            name: "PlutoPe Wallet",
            description: "PlutoPe description",
            url: "https://www.plutope.io/",
            icons: ["https://plutope.app/api/images/applogo.png"],
            redirect:try! AppMetadata.Redirect(native: "plutope://", universal: "https://presale.plutope.io/", linkMode: true)
        )
        WalletKit.configure(metadata: metadata, crypto: DefaultCryptoProvider(), environment: BuildConfiguration.shared.apnsEnvironment)

    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
            if let incomingURL = userActivity.webpageURL {
                handleIncomingDynamicLink(url: incomingURL)
            }
        }
    
    private func handleIncomingDynamicLink(url: URL) {
        DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLink, error in
            if let error = error {
                return
            }
            
            if let dynamicLink = dynamicLink, let deepLinkURL = dynamicLink.url {
                // Extract referral code
                if let components = URLComponents(url: deepLinkURL, resolvingAgainstBaseURL: false),
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
        }
    }

    private func wasOpenedWithURL(_ url: URL, onStart: Bool) {
        launchURL = url
        NotificationCenter.default.post(name: .receievedWalletRequest, object: nil)
    }
    func sceneWillEnterForeground(_ scene: UIScene) {
            /// Biometrics
            guard let rootVc = self.window?.rootViewController else {
                return
            }
            AppPasscodeHelper().handleAppPasscodeIfNeeded(in: rootVc) { _ in
            }
        self.appIsInForeground = true
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let context = URLContexts.first else { return }
        
        let url = context.url
        // Attempt to handle the URL as a Firebase Dynamic Link
           if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
               if let deepLinkURL = dynamicLink.url {
                   // Process the deep link URL as needed
                   self.handleIncomingDynamicLink(url: deepLinkURL)
               }
               return // Exit early if the URL was a Dynamic Link
           }

           // If not a Dynamic Link, proceed with existing WalletConnect handling
        foregroundNotificationToken = NotificationCenter.default.addObserver(forName: .sceneWillEnterForegroundCompleted, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            NotificationCenter.default.removeObserver(self.foregroundNotificationToken as Any)
            self.foregroundNotificationToken = nil
            do {
                let uri = try WalletConnectURI(urlContext: context)
                Task {
                    try await WalletKit.instance.pair(uri: uri)
                    self.handledWalletConnectURL = true
                }
            } catch {
                if case WalletConnectURI.Errors.expired = error {
                   // AlertPresenter.present(message: error.localizedDescription, type: .error)
                    self.window?.rootViewController?.showToast(message: "\(error.localizedDescription)", font: AppFont.regular(15).value)
                    self.handledWalletConnectURL = false
                } else {
                    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                          let queryItems = components.queryItems,
                          queryItems.contains(where: { $0.name == "wc_ev" }) else {
                        return
                    }
                    
                    do {
                        try WalletKit.instance.dispatchEnvelope(url.absoluteString)
                    } catch {
                        self.window?.rootViewController?.showToast(message: "\(error.localizedDescription)", font: AppFont.regular(15).value)
                        //                               AlertPresenter.present(message: error.localizedDescription, type: .error)
                    }
                }
            }
        }
        
    }
    func sceneDidBecomeActive(_ scene: UIScene) {
        }

    func handleDeepLinkFromMain(_ url: URL) {
        do {
            let uri = try WalletConnectURI(deeplinkUri: url)
            app.uri = uri
            Task {
                do {
                    try await WalletKit.instance.pair(uri: uri)
                    self.handledWalletConnectURL = true
                } catch {
                    self.window?.rootViewController?.showToast(message: "WalletConnect session was disconnected. Go back to your browser and connect via WalletConnect again.", font: AppFont.regular(15).value)
                }
            }
        } catch {
            self.window?.rootViewController?.showToast(message: "WalletConnect session was disconnected. Go back to your browser and connect via WalletConnect again.", font: AppFont.regular(15).value)

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
    func onDelete() async {
        let sessions = WalletKit.instance.getSessions()  // This should return active sessions
        guard let sessionTopic = sessions.first?.topic else {
            return
        }
       
        do {
            Task {
                try await WalletKit.instance.disconnect(topic: sessionTopic)
                UserDefaults.standard.set(false, forKey: "isConnected") // Reset the flag
                UserDefaults.standard.removeObject(forKey: "sessionName")
            }
        } catch {
        }
    }
    func sceneDidDisconnect(_ scene: UIScene)  {
        appIsInForeground = false
        Task {
            await onDelete()
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        appIsInForeground = false
    }
    
}
extension Notification.Name {
    static let connectionAppeared = Notification.Name("connectionAppeared")
    static let walletsChanged = Notification.Name("walletsChanged")
    static let receievedWalletRequest = Notification.Name("receievedWalletRequest")
    static let mustTerminate = Notification.Name("terminateOtherInstances")
    static let sceneWillEnterForegroundCompleted = Notification.Name("sceneWillEnterForegroundCompleted")
}

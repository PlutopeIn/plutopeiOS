//
//  SceneDelegate+Extension.swift
//  Plutope
//
//  Created by Trupti Mistry on 21/12/23.
//

import UIKit
import DGNetworkingServices
import FirebaseCore
import FirebaseMessaging
import WalletConnectNotify
import SafariServices
extension SceneDelegate {

//    func resetRootView() {
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            let window = UIWindow(windowScene: windowScene)
//            let rootViewController = setRootViewController()
//            window.rootViewController = rootViewController
//            self.window = window
//            window.makeKeyAndVisible()
//        }
//    }
//    func setRootViewController() -> UIViewController {
//        if UserDefaults.standard.bool(forKey: DefaultsKey.splashVideoPlayed) {
//            let walletStoryboard = UIStoryboard(name: "WalletRoot", bundle: nil)
//            if UserDefaults.standard.string(forKey: DefaultsKey.mnemonic) == nil {
//                let walletSetUpVC = WalletSetUpViewController()
//                let navigationController = UINavigationController(rootViewController: walletSetUpVC)
//                navigationController.setNavigationBarHidden(true, animated: false)
//                return navigationController
//            } else if let tabBarVC = walletStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
//                return tabBarVC
//            }
//        } else {
//            let avPlayer = VideoPlayerViewController()
//            let navigationController = UINavigationController(rootViewController: avPlayer)
//            navigationController.setNavigationBarHidden(true, animated: false)
//            return navigationController
//        }
//        return UIViewController()
//    }
    
}

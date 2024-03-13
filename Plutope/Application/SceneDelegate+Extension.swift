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
    func apiCheckVerstion() {
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: ""), HttpMethod: .post, parameters: nil, headers: nil) { result in
            switch result {
                
            case .success((let response, _)):
                let status = response["status"] as? Int ?? 0
                let message = response["error_msg"] as? String ?? ""
                if status == 1 {
                    let data = response["data"] as? [[String:Any]] ?? [[:]]
                    
                    //                    UserDefaults.standard.setValue(data[0]["app_id"] as? String ?? "", forKey: Pusher_App_id)
                    //                    UserDefaults.standard.setValue(data[0]["key"] as? String ?? "", forKey: Pusher_key)
                    //                    UserDefaults.standard.setValue(data[0]["secret"] as? String ?? "", forKey: Pusher_secret)
                    //                    UserDefaults.standard.setValue(data[0]["cluster"] as? String ?? "", forKey: Pusher_cluster)
                    //                    UserDefaults.standard.setValue(data[0]["popupMessage"] as? String ?? "", forKey: popupMessage)
                    //                    UserDefaults.standard.setValue(data[0]["forcefullyUpdate"] as? Bool ?? false, forKey: forcefullyUpdat)
                    //                    UserDefaults.standard.setValue(data[0]["version_code"] as? String ?? "", forKey: version_code)
                    //                    self.forcefullyUpdate = data[0]["forcefullyUpdate"] as? Bool ?? false
                    //                    self.appOldVersion = data[0]["version_code"] as? Int ?? 0
                    
                    if self.appOldVersion ?? 0 > self.appCurrentVersion {
                        //  DispatchQueue.main.async {
                        guard let rootViewController = self.window?.rootViewController else {
                            return
                        }
                        
                        //                            let vc = VersionUpdatePopUpViewController()
                        //                            let popupMessage = UserDefaults.standard.value(forKey: popupMessage) as? String ?? ""
                        //                            vc.popupMessage = popupMessage
                        //                            vc.forcefullyUpdate = self.forcefullyUpdate
                        //                            vc.modalTransitionStyle = .crossDissolve
                        //                            vc.modalPresentationStyle = .overFullScreen
                        //                            rootViewController.present(vc, animated: true)
                        // }
                    } else {
                        self.setRootView()
                    }
                    // versionCode
                } else {
                    self.setRootView()
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func resetRootView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let rootViewController = setRootViewController()
            window.rootViewController = rootViewController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    func setRootViewController() -> UIViewController {
        if UserDefaults.standard.bool(forKey: DefaultsKey.splashVideoPlayed) {
            let walletStoryboard = UIStoryboard(name: "WalletRoot", bundle: nil)
            if UserDefaults.standard.string(forKey: DefaultsKey.mnemonic) == nil {
                let walletSetUpVC = WalletSetUpViewController()
                let navigationController = UINavigationController(rootViewController: walletSetUpVC)
                navigationController.setNavigationBarHidden(true, animated: false)
                return navigationController
            } else if let tabBarVC = walletStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
                return tabBarVC
            }
        } else {
            let avPlayer = VideoPlayerViewController()
            let navigationController = UINavigationController(rootViewController: avPlayer)
            navigationController.setNavigationBarHidden(true, animated: false)
            return navigationController
        }
        return UIViewController()
    }
    
}

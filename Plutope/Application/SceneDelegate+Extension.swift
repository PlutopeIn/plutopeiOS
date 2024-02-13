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
}
// MARK: - Notification Delegate method
@available(iOS 10, *)
extension SceneDelegate : UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Generated the Device Token...")
        let takeParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = takeParts.joined()
        
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
   
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Fail notification:\(error.localizedDescription)")
    }
    // Handle notification presentation when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
       
        let aps = notification.request.content.userInfo[AnyHashable("aps")] as? NSDictionary

        let type = (notification.request.content.userInfo[AnyHashable("type")] as? String ?? "").lowercased()
        print(type)
        
        print(userInfo)
        
        if #available(iOS 14.0, *) {
            completionHandler([.banner,.sound,.badge])
        } else {
            completionHandler([.alert,.sound,.badge])
        }
        print("Notification arrived")
        
       // completionHandler( [.alert, .badge, .sound])
        }
    
    // MARK: - Handle user interaction with the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        let type = (response.notification.request.content.userInfo[AnyHashable("type")] as? String ?? "").lowercased()
       
//        let walletStoryboard = UIStoryboard(name: "WalletRoot", bundle: nil)
//
//        if UserDefaults.standard.string(forKey: DefaultsKey.mnemonic) == nil {
//            let walletSetUpVC = WalletSetUpViewController()
//            let navigationController = UINavigationController(rootViewController: walletSetUpVC)
//            navigationController.setNavigationBarHidden(true, animated: false)
//            window?.rootViewController = navigationController
//        } else if let tabBarVC = walletStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
//            window?.rootViewController = tabBarVC
//        }
//        self.window?.makeKeyAndVisible()
    
        completionHandler()
    }
}
// MARK: - MessagingDelegate
extension SceneDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("DeviceToken:\(fcmToken ?? "")")
        UserDefaults.standard.setValue(fcmToken, forKey: "fcm_Token")
    }
}

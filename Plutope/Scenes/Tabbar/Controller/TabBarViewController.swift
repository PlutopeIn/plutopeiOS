//
//  TabBarViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 14/06/23.
//
import UIKit
import SDWebImage
class TabBarViewController: UITabBarController {
    
    let cardVC = CardViewController()
    var settingsVC = UIViewController()
    let walletDashboard = WalletDashboardViewController()
    var secondTabAlreadySelected = false
    var selectedTabIndices: [Int] = []
    
    func onImport() {
        guard let account = ImportAccount(input:WalletData.shared.myWallet?.privateKey ?? "" )
        else { return }
        self.importAccount(account)
        print(self.importAccount(account))
    }
    func importAccount(_ importAccount: ImportAccount) {
        let accountStorage = AccountStorage(defaults: UserDefaults.standard)
        accountStorage.importAccount = importAccount
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let accountStorage =  AccountStorage(defaults: UserDefaults.standard)
        onImport()
        self.delegate = self
        
        guard let importAccount = accountStorage.importAccount else { return  }
        settingsVC = SettingsViewController(importAccount: importAccount)
       
        controllersSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        customTabSetup()
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controllersSetup()
//        NotificationCenter.default.addObserver(forName: Notification.Name("LanguageDidChange"), object: nil, queue: .main) { [weak self] (notification) in
//
//               // Call tabBarItemSetup method here to update imageInsets based on language
//            self?.tabBarItemSetup()
//           }
       
    }
    fileprivate func tabBarItemSetup(_ cardNav: UINavigationController = UINavigationController(), _ settingNav: UINavigationController = UINavigationController(), _ walletNav: UINavigationController = UINavigationController()) {
        cardNav.tabBarItem  = UITabBarItem(
            title: "", image: UIImage.icCard.sd_tintedImage(with: .white),
            selectedImage: UIImage.icCard.sd_tintedImage(with: .c00C6FB))
        settingNav.tabBarItem =  UITabBarItem(
            title: "", image: UIImage.icSetting.sd_tintedImage(with: .white),
            selectedImage: UIImage.icSetting.sd_tintedImage(with: .c00C6FB))
        walletNav.tabBarItem =  UITabBarItem(
            title: "", image: UIImage(named: ""),
            selectedImage: UIImage(named: ""))
       
        walletNav.tabBarItem.isEnabled = true
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
//                settingNav.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)
//                cardNav.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 70)
//                walletNav.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            } else {
//                settingNav.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 70)
//                cardNav.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)
//                walletNav.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            }
        //}
        
    }
    
    fileprivate func controllersSetup() {
        
        let cardNav = UINavigationController(rootViewController: cardVC)
        cardNav.setNavigationBarHidden(true, animated: true)
        
        let settingNav = UINavigationController(rootViewController: settingsVC)
        settingNav.setNavigationBarHidden(true, animated: true)
        
        let walletNav = UINavigationController(rootViewController: walletDashboard)
        walletNav.setNavigationBarHidden(true, animated: true)
        self.tabBarItemSetup(cardNav, settingNav, walletNav)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let controllers = [cardNav, walletNav, settingNav]
        self.viewControllers = controllers
        self.tabBar.unselectedItemTintColor = .white
        
        self.selectedViewController?.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.selectedIndex = 1
    }
    
    func customTabSetup() {
        
        let backgroundImage = UIImage.ivTab
        let backgroundLayer = CALayer()
        backgroundLayer.contents = backgroundImage.cgImage
        
        if UIDevice.current.hasNotch {
            let newTabBarHeight = tabBar.frame.size.height - 10
            var newFrame = tabBar.frame
            newFrame.size.height = newTabBarHeight
            newFrame.origin.y = screenHeight - newTabBarHeight
            
            /// Background layer frame
            backgroundLayer.frame = tabBar.bounds
            backgroundLayer.bounds.size.width = screenWidth - 28
            backgroundLayer.bounds.size.height = 57
            backgroundLayer.frame.origin.x = 14
            backgroundLayer.frame.origin.y = -7
            tabBar.layer.insertSublayer(backgroundLayer, at: 0)
            
            tabBar.frame = newFrame
        } else {
            let newTabBarHeight = tabBar.frame.size.height + 30
            var newFrame = tabBar.frame
            newFrame.size.height = newTabBarHeight
            newFrame.origin.y = screenHeight - newTabBarHeight
            
            /// Background layer frame
            backgroundLayer.frame = tabBar.bounds
            backgroundLayer.bounds.size.width = screenWidth - 28
            backgroundLayer.bounds.size.height = 57
            backgroundLayer.frame.origin.x = 14
            backgroundLayer.frame.origin.y = 15
            tabBar.layer.insertSublayer(backgroundLayer, at: 0)
            
            tabBar.frame = newFrame
        }
        
    }
    
}
// MARK: UITabBarControllerDelegate method
extension TabBarViewController : UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            let selectedIndex = tabBarController.selectedIndex
            if selectedIndex == 1 {
                // Selected the second tab (index 1)
                if secondTabAlreadySelected {
                    // Show a popup, you can replace this with your popup logic
                    showPopup()

                    // Optionally, you can also deselect the current tab to prevent the tab bar icon from staying highlighted
                    secondTabAlreadySelected = false
                    self.selectedIndex = -1

                } else {
                    secondTabAlreadySelected = true
                }
            } else {
                secondTabAlreadySelected = false
            }
        }

    func showPopup() {
        let viewToNavigate = CoinTransferPopUp()
        viewToNavigate.delegate = self
        viewToNavigate.modalTransitionStyle = .coverVertical
        viewToNavigate.modalPresentationStyle = .overFullScreen
        self.present(viewToNavigate, animated: true)
        // Optionally, you can also deselect the current tab to prevent the tab bar icon from staying highlighted
               
    }
}

// MARK: Dismiss presented screen and push forward
extension TabBarViewController: PushViewControllerDelegate {
    
    func pushViewController(_ controller: UIViewController) {
           if let navController = self.selectedViewController as? UINavigationController {
               // If the selected view controller is a navigation controller, push onto its stack
               navController.pushViewController(controller, animated: true)
           } else {
               // Otherwise, if there's no navigation controller, push onto the tab bar controller
               self.navigationController?.pushViewController(controller, animated: true)
           }
       }
}

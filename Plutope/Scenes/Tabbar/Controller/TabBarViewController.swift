//
//  TabBarViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 14/06/23.
//
import UIKit
import SDWebImage
import Combine
import WalletConnectUtils
import ReownWalletKit
class TabBarViewController: UITabBarController {

    // let cardVC = CardViewController()
    var cardVC = UIViewController()  // CardHomeViewController()
    var settingsVC = UIViewController()
    var walletDashboard = UIViewController()
    var secondTabAlreadySelected = false
    var selectedTabIndices: [Int] = []
    private var switchButton: UIButton!
    let app: Application
    
    let interactor : MainInteractor
  //  let importAccount: ImportAccount
    let configurationService: ConfigurationService
    private var disposeBag = Set<AnyCancellable>()
    init(interactor: MainInteractor,app:Application,configurationService: ConfigurationService) {

     // Assign default values to properties
    //    defer { setupInitialState() }
        self.app = app
      //  self.importAccount = importAccount
        self.configurationService = app.configurationService
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func onImport() {
        guard let account = ImportAccount(input: WalletData.shared.myWallet?.privateKey ?? "") else { return }
        self.importAccount(account)
        print("importAccount =", self.importAccount(account))
    }

    func importAccount(_ importAccount: ImportAccount) {
        let accountStorage = AccountStorage(defaults: UserDefaults.standard)
        accountStorage.importAccount = importAccount
        
        print("importAccount =", accountStorage.importAccount ?? "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //if let importAccount = app.accountStorage.importAccount {
            onImport()
        //} else {
          //  importAccount(ImportAccount.new())
       // }
        UserDefaults.standard.set(false, forKey: DefaultsKey.newUser)
     
        let accountStorage = AccountStorage(defaults: UserDefaults.standard)
        self.delegate = self

        guard let importAccount = accountStorage.importAccount else { return }
        walletDashboard = WalletDashboardViewController(importAccount: importAccount, app: app,mainInteractor: interactor,configurationService: app.configurationService)
        settingsVC = SettingsViewController(importAccount: importAccount)
        cardVC = CardHomeViewController()

        controllersSetup()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabbarDesignSetups()
        setupCustomView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIDevice.current.hasNotch {
                    tabBar.frame.size.height = 83 // Example height for notched devices
                } else {
                    tabBar.frame.size.height = 50 // Default height for non-notched devices
                }

        tabBar.frame.origin.y = view.frame.height - tabBar.frame.height
        positionCustomButton()
    }
     
    func setupCustomView() {
        switchButton = UIButton(type: .custom)
        switchButton.backgroundColor = .clear
        switchButton.tintColor = .clear
        if traitCollection.userInterfaceStyle == .dark {
            switchButton.setImage(UIImage(named: "offswitchDark")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            switchButton.setImage(UIImage(named: "onSwitchDark")?.withRenderingMode(.alwaysOriginal), for: .selected)
        } else {
            switchButton.setImage(UIImage(named: "offSwitch")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            switchButton.setImage(UIImage(named: "onSwitch")?.withRenderingMode(.alwaysOriginal), for: .selected)
        }
        switchButton.addTarget(self, action: #selector(customButtonTapped(_:)), for: .touchUpInside)

        // Add swipe gestures
        addSwipeGestures(to: switchButton)

        self.tabBar.addSubview(switchButton)
        
    }
    private func addSwipeGestures(to button: UIButton) {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeLeft.direction = .left
        button.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeRight.direction = .right
        button.addGestureRecognizer(swipeRight)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
//        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//            if traitCollection.userInterfaceStyle == .dark {
//
//            } else {
//
//            }
//        }
    }

    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            // Swipe left: Set image to "onSwitch" and select the button
            if traitCollection.userInterfaceStyle == .dark {
                switchButton.setImage(UIImage(named: "onSwitchDark")?.withRenderingMode(.alwaysOriginal), for: .selected)
            } else {
                switchButton.setImage(UIImage(named: "onSwitch")?.withRenderingMode(.alwaysOriginal), for: .selected)
            }
            
            switchButton.isSelected = true
            self.selectedIndex = 0
        case .right:
            // Swipe right: Set image to "offSwitch" and deselect the button
            if traitCollection.userInterfaceStyle == .dark {
                switchButton.setImage(UIImage(named: "offswitchDark")?.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                switchButton.setImage(UIImage(named: "offSwitch")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
            switchButton.isSelected = false
            self.selectedIndex = 1
        default:
            break
        }
        print("Swipe detected! Selected index: \(self.selectedIndex)")
    }
    func positionCustomButton() {
        if UIDevice.current.hasNotch {
            switchButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                switchButton.widthAnchor.constraint(equalToConstant: 125),
                switchButton.heightAnchor.constraint(equalToConstant: 50),
                switchButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
                switchButton.bottomAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.bottomAnchor, constant: 5) // Adjusts for both notched and non-notched devices
            ])
        } else {
            switchButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                switchButton.widthAnchor.constraint(equalToConstant: 125),
                switchButton.heightAnchor.constraint(equalToConstant: 50),
                switchButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
                switchButton.bottomAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.bottomAnchor, constant: 1) // Adjusts for both notched and non-notched devices
            ])
        }
    }
    @objc func customButtonTapped(_ sender: UIButton) {
        HapticFeedback.generate(.light)
        sender.isSelected.toggle()
        self.selectedIndex = sender.isSelected ? 0 : 1
        print("Custom button tapped!", self.selectedIndex)
        switch self.selectedIndex {
        case 0:
           
            if traitCollection.userInterfaceStyle == .dark {
                switchButton.setImage(UIImage(named: "onSwitchDark")?.withRenderingMode(.alwaysOriginal), for: .selected)
            } else {
                switchButton.setImage(UIImage(named: "onSwitch")?.withRenderingMode(.alwaysOriginal), for: .selected)
            }
            
            switchButton.isSelected = true
            self.selectedIndex = 0
        case 1:
            if traitCollection.userInterfaceStyle == .dark {
                switchButton.setImage(UIImage(named: "offswitchDark")?.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                switchButton.setImage(UIImage(named: "offSwitch")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            switchButton.isSelected = false
            self.selectedIndex = 1
        default:
            break
        }
        
    }
    fileprivate func controllersSetup() {
        let cardNav = UINavigationController(rootViewController: cardVC)
        cardNav.setNavigationBarHidden(true, animated: true)
        let settingNav = UINavigationController(rootViewController: settingsVC)
        settingNav.setNavigationBarHidden(true, animated: true)
        let walletNav = UINavigationController(rootViewController: walletDashboard)
        walletNav.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewControllers = [cardNav, walletNav]
        self.selectedViewController = walletNav
        self.selectedIndex = 1
        walletNav.tabBarItem.isEnabled = false
        cardNav.tabBarItem.isEnabled = false
    }

    fileprivate func tabbarDesignSetups() {
        self.tabBar.isTranslucent = true
        self.tabBar.tintColor = UIColor.clear
        self.tabBar.backgroundColor = UIColor.clear
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
                   // showPopup()

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

extension TabBarViewController {
//    func setupInitialState() {
//        
//        guard let importAccount = app.accountStorage.importAccount else { return }
//      
//       configurationService.configure(importAccount: importAccount)
//     
//        interactor.sessionProposalPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [unowned self] session in
//                let viewController: UIViewController = SessionProposalModule.create(app: app, importAccount: importAccount, proposal: session.proposal, context: session.context)
//                self.navigationController?.present(viewController, animated: true)
//
//            }
//            .store(in: &disposeBag)
//       interactor.sessionRequestPublisher
//           .receive(on: DispatchQueue.main)
//           .sink { [unowned self] request, context in
//               
//               let viewController: UIViewController = SessionRequestModule.create(app: app, sessionRequest: request, importAccount: importAccount, sessionContext: context)
//               self.navigationController?.present(viewController, animated: true)
////                        .presentFullScreen(from: self, transparentBackground: false)
//           }.store(in: &disposeBag)
//        
//        interactor.authenticateRequestPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [unowned self] result in
//                let requestedChains: Set<Blockchain> = Set(result.request.payload.chains.compactMap { Blockchain($0) })
//                let supportedChains: Set<Blockchain> = [Blockchain("eip155:1")!, Blockchain("eip155:137")!,Blockchain("eip155:66")!,Blockchain("eip155:56")!,Blockchain("eip155:97")!,Blockchain("eip155:10")!,Blockchain("eip155:42161")!,Blockchain("eip155:43114")!,Blockchain("eip155:8453")!]
//                // Check if there's an intersection between the requestedChains and supportedChains
//                let commonChains = requestedChains.intersection(supportedChains)
//                guard !commonChains.isEmpty else {
//                    AlertPresenter.present(message: "No common chains", type: .error)
//                    return
//                }
//                let viewController: UIViewController =  AuthRequestModule.create(app: app, request: result.request, importAccount: importAccount, context: result.context)
//                self.navigationController?.present(viewController, animated: true)
//             
//            }
//            .store(in: &disposeBag)
//       
////            interactor.requestPublisher
////                .receive(on: DispatchQueue.main)
////                .sink { [unowned self] result in
////                    AuthRequestModule.create(app: app, request: result.request, importAccount: importAccount, context: result.context)
////                        .presentFullScreen(from: self, transparentBackground: true)
////                }
////                .store(in: &disposeBag)
//   }
}

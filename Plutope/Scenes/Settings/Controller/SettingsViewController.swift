//
//  SettingsViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
import Combine
import WalletConnectSign
//import Auth

class SettingsViewController: UIViewController, Reusable {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tbvSetting: UITableView!
    @IBOutlet weak var btnHome: UIButton!
    var primaryWallet: Wallets?
    var isPushed = false
    var activeToken: [ActiveTokens]? = []
    let importAccount: ImportAccount
    let interactor: MainInteractor
    var app: Application
    private let configurationService: ConfigurationService
//    var app: Application
    var disposeBag = Set<AnyCancellable>()
    var arrSettigngData: [GroupSettingData] = [
        GroupSettingData(group: [ .wallets, .currency, .languages, .refreal]),
        GroupSettingData(group: [ .security, .contacts,.walletConnect]),
//        GroupSettingData(group: [ .security, .contacts,.refreal]),
//       GroupSettingData(group: [ .security, .contacts,.walletConnect]),
        GroupSettingData(group: [ .helpCenter, .aboutPlutope])
    ]
    
    weak var primaryWalletDelegate: PrimaryWalletDelegate?
    weak var updatedWalletWalletDelegate: UpdatedWalletWalletDelegate?
    weak var currencyUpdateDelegate: CurrencyUpdateDelegate?
    init(importAccount: ImportAccount,interactor: MainInteractor? = nil,app:Application? = nil,configurationService: ConfigurationService? = nil) {

     // Assign default values to properties
        defer { setupInitialState() }
        self.app = app ?? Application()
        self.importAccount = importAccount
        self.configurationService = configurationService ?? ConfigurationService()
        self.interactor = interactor ?? MainInteractor()
        
        super.init(nibName: nil, bundle: nil)
   }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupInitialState() {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     //   zendeskInit()
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.settings, comment: ""), btnBackHidden: false)
        /// Table Register
        tableRegister()
        /// Long tap Action
       // let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapped))
       // btnHome.addGestureRecognizer(longTapGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: Notification.Name("LanguageDidChange"), object: nil, queue: .main) { (notification) in
            (self.headerView.subviews.first as? NavigationView)?.lblTitle.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.settings, comment: "")
        }
        tbvSetting.reloadData()
        tbvSetting.restore()
    }
    
    @IBAction func actionHome(_ sender: Any) {
        HapticFeedback.generate(.light)
        //        let viewToNavigate = CoinTransferPopUp()
        //        viewToNavigate.delegate = self
        //        viewToNavigate.modalTransitionStyle = .coverVertical
        //        viewToNavigate.modalPresentationStyle = .overFullScreen
        //        self.present(viewToNavigate, animated: true)
        self.tabBarController?.selectedIndex = 1
        
    }
    
    /// Table Register
    func tableRegister() {
        tbvSetting.delegate = self
        tbvSetting.dataSource = self
        tbvSetting.register(SettingViewCell.nib, forCellReuseIdentifier: SettingViewCell.reuseIdentifier)
    }
    /// Selector method
    @objc func longTapped() {
        HapticFeedback.generate(.light)
        self.tabBarController?.selectedIndex = 1
        
    }
    
}
// MARK: Dismiss presented screen and push forward
extension SettingsViewController: PushViewControllerDelegate {
    
    func pushViewController(_ controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: PrimaryWalletDelegate
extension SettingsViewController: PrimaryWalletDelegate {
    
    func setPrimaryWallet(primaryWallet: Wallets?) {
        
        if let navigationController = self.navigationController {
            for viewController in navigationController.viewControllers {
                if let walletDash = viewController as? WalletDashboardViewController {
                    self.primaryWalletDelegate = walletDash
                    self.primaryWalletDelegate?.setPrimaryWallet(primaryWallet: primaryWallet)
                    self.tabBarController?.selectedIndex = 1
                    break
                }
            }
        }
        
        
//        if let walletDash = (self.tabBarController?.viewControllers?[1] as? UINavigationController)?.topViewController as? WalletDashboardViewController {
//            self.primaryWalletDelegate = walletDash
//            self.primaryWalletDelegate?.setPrimaryWallet(primaryWallet: primaryWallet)
//            self.tabBarController?.selectedIndex = 1
//        }
        
    }
    
}
extension SettingsViewController : UpdatedWalletWalletDelegate {
    func setUpdatedWallet(primaryWallet: Wallets?) {
        if let navigationController = self.navigationController {
            for viewController in navigationController.viewControllers {
                if let walletDash = viewController as? WalletDashboardViewController {
                    self.updatedWalletWalletDelegate = walletDash
                    self.updatedWalletWalletDelegate?.setUpdatedWallet(primaryWallet: primaryWallet)
                    self.tabBarController?.selectedIndex = 1
                    break
                }
            }
        }
    }
}

extension SettingsViewController : DismissLanguageDelegate {
    func dismissPopup() {
        tbvSetting.reloadData()
        tbvSetting.restore()
    }
    
}

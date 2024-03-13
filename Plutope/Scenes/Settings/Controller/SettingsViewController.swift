//
//  SettingsViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
import Combine
import WalletConnectSign
import Auth

class SettingsViewController: UIViewController, Reusable {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tbvSetting: UITableView!
    @IBOutlet weak var btnHome: UIButton!
    let interactor: MainInteractor
    let importAccount: ImportAccount
    var app: Application
    var disposeBag = Set<AnyCancellable>()
    private let configurationService: ConfigurationService
    var isPushed = false
    init(importAccount: ImportAccount,interactor: MainInteractor? = nil,app:Application? = nil,configurationService: ConfigurationService? = nil) {

     // Assign default values to properties
        defer { setupInitialState() }
        self.app = app ?? Application()
        self.importAccount = importAccount
        self.configurationService = configurationService ?? ConfigurationService()  // Assuming ConfigurationService has a default initializer
        self.interactor = interactor ?? MainInteractor()
        
        super.init(nibName: nil, bundle: nil)
   }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var arrSettigngData: [GroupSettingData] = [
        GroupSettingData(group: [ .wallets, .currency, .languages]),
      //  GroupSettingData(group: [ .security, .contacts]),
       GroupSettingData(group: [ .security, .contacts,.walletConnect]),
        GroupSettingData(group: [ .helpCenter, .aboutPlutope])
    ]
    
    weak var primaryWalletDelegate: PrimaryWalletDelegate?
    weak var currencyUpdateDelegate: CurrencyUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.settings, comment: ""), btnBackHidden: true)
        /// Table Register
        tableRegister()
        /// Long tap Action
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapped))
        btnHome.addGestureRecognizer(longTapGesture)
        
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
        
        if let walletDash = (self.tabBarController?.viewControllers?[1] as? UINavigationController)?.topViewController as? WalletDashboardViewController {
            self.primaryWalletDelegate = walletDash
            self.primaryWalletDelegate?.setPrimaryWallet(primaryWallet: primaryWallet)
            self.tabBarController?.selectedIndex = 1
        }
        
    }
    
}
extension SettingsViewController {
    // MARK: - Private functions
  
         func setupInitialState() {
            configurationService.configure(importAccount: importAccount)
          
            interactor.sessionProposalPublisher
                .receive(on: DispatchQueue.main)
                .sink { [unowned self] session in
                    SessionProposalModule.create(app: app, importAccount: importAccount, proposal: session.proposal, context: session.context)
                        .push(from: self)
                }
                .store(in: &disposeBag)
            
            interactor.sessionRequestPublisher
                .receive(on: DispatchQueue.main)
                .sink { [unowned self] request, context in
                    SessionRequestModule.create(app: app, sessionRequest: request, importAccount: importAccount, sessionContext: context)
                        .presentFullScreen(from: self, transparentBackground: false)
                }.store(in: &disposeBag)
            
            interactor.requestPublisher
                .receive(on: DispatchQueue.main)
                .sink { [unowned self] result in
                    AuthRequestModule.create(app: app, request: result.request, importAccount: importAccount, context: result.context)
                        .presentFullScreen(from: self, transparentBackground: true)
                }
                .store(in: &disposeBag)
        }
}

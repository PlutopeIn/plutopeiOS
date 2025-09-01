//
//  CardHomeViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 19/03/24.
//

import UIKit
import Web3
import Combine
class CardHomeViewController: UIViewController {

    @IBOutlet var myView: UIView!
    @IBOutlet weak var lblMsg1: UILabel!
    @IBOutlet weak var lblMsg2: UILabel!
    @IBOutlet weak var ibCard: UIImageView!
//    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var lblSupport: UILabel!
    @IBOutlet weak var btnNewCard: GradientButton!
    @IBOutlet weak var btnHaveCard: GradientButton!
    
//    let importAccount: ImportAccount
    let interactor: MainInteractor
    var app: Application
    private let configurationService: ConfigurationService
//    var app: Application
    var disposeBag = Set<AnyCancellable>()
    init(interactor: MainInteractor? = nil,app:Application? = nil,configurationService: ConfigurationService? = nil) {

     // Assign default values to properties
        defer { setupInitialState() }
        self.app = app ?? Application()
        
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
    fileprivate func uiSetUp() {

        self.lblMsg1.font = AppFont.violetRegular(30).value
        self.lblMsg2.font = AppFont.regular(15).value
 
        let btnHaveCardTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.logIn, comment: "")
        let btnHaveCardAttributes: [NSAttributedString.Key: Any] = [
            .font: AppFont.violetRegular(18).value, // Replace "YourFontName" with your custom font name and 17 with desired font size
            .foregroundColor: UIColor.systemBackground // Adapts to light/dark mode
        ]
        let btnHaveCardAttributedTitle = NSAttributedString(string: btnHaveCardTitle, attributes: btnHaveCardAttributes)

        // Set the attributed title for the button
        btnHaveCard.setAttributedTitle(btnHaveCardAttributedTitle, for: .normal)
        btnHaveCard.backgroundColor = UIColor.label

        
        let btnNewCardTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.dontHaveCard, comment: "")
        let btnNewCardAttributes: [NSAttributedString.Key: Any] = [
            .font: AppFont.violetRegular(18).value, // Replace "YourFontName" with your custom font name and 17 with desired font size
            .foregroundColor: UIColor.systemBackground // Adapts to light/dark mode
        ]
        let btnNewCardAttributTitle = NSAttributedString(string: btnNewCardTitle, attributes: btnNewCardAttributes)

        // Set the attributed title for the button
        btnNewCard.setAttributedTitle(btnNewCardAttributTitle, for: .normal)
        btnNewCard.backgroundColor = UIColor.label
        
        self.lblSupport.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.support, comment: "")
        lblMsg1.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cardhomeMsg1, comment: "")
        lblMsg2.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cardhomeMsg2, comment: "")
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation header
       
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: ""), btnBackHidden: true,btnRightImage: UIImage(named: "ic_support"),btnRightAction: {
            self.showWebView(for: URLs.faqURl, onVC: self, title:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.faq, comment: ""))
        })
        tabBarController?.tabBar.isHidden = false
        uiSetUp()
        /// Long tap Action
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapped))

    }
    @MainActor
    func showWebView(for url: String, onVC: UIViewController, title: String) {
        let webController = WebViewController()
        webController.webViewURL = url
        webController.webViewTitle = title
        let navVC = UINavigationController(rootViewController: webController)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
        onVC.present(navVC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.addObserver(forName: Notification.Name("LanguageDidChange"), object: nil, queue: .main) { (notification) in
            (self.headerView.subviews.first as? NavigationView)?.lblTitle.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: "")
            self.uiSetUp()
        }
        if UserDefaults.standard.value(forKey: loginApiToken) != nil {
            let cardMainVC = CardDashBoardViewController()
            cardMainVC.delegate = self
//            cardMainVC.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(cardMainVC, animated: false)
        }
       
    }
    /// Selector method
    @objc func longTapped() {
        HapticFeedback.generate(.light)
        self.tabBarController?.selectedIndex = 1
 
    }
    @IBAction func btnHaveCardAction(_ sender: Any) {
        HapticFeedback.generate(.light)
            let loginVC = LoginViewController()
            
            self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func btnNewCardAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let registerVC = RegisterCardViewController()
                registerVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(registerVC, animated: true)
    }

}

extension CardHomeViewController : BackToRootDelegate {
    func backktoRootScreen() {
        self.tabBarController?.selectedIndex = 1
    }
    
}

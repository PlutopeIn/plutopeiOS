//
//  WalletSetUpViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import UIKit
import Lottie
import WalletConnectNetworking
import Combine
class WalletSetUpViewController: UIViewController, Reusable {
    
    @IBOutlet weak var lottiView: LottieAnimationView!
    @IBOutlet weak var btnImport: UIButton!
    @IBOutlet weak var btnCreateNewWallet: UIStackView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblWalletSetup: UILabel!
    @IBOutlet weak var lblEnterFreedom: UILabel!
    @IBOutlet weak var btnCreateNewWallets: UIButton!
    
    var isFromWallets = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Navigation header
        defineHeader(headerView: headerView, titleText: "", btnBackHidden: isFromWallets ? false : true)
        UserDefaults.standard.set(true, forKey: DefaultsKey.newUser)
        
//        self.btnImport.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.importUsingSecretPhrase, comment: ""), for: .normal)
        
        let btnImportTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.importUsingSecretPhrase, comment: "")
        let btnImportfont = AppFont.violetRegular(18).value
        let btnImportAttributes: [NSAttributedString.Key: Any] = [
            .font: btnImportfont
        ]

        let btnImportAttributedTitle = NSAttributedString(string: btnImportTitle, attributes: btnImportAttributes)
        self.btnImport.setAttributedTitle(btnImportAttributedTitle, for: .normal)
        self.btnCreateNewWallets.titleLabel?.font = AppFont.violetRegular(18.0).value
//        self.btnCreateNewWallets.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.createAnewwallet, comment: ""), for: .normal)
        
        let title = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.createnewwallet, comment: "")
        let font = AppFont.violetRegular(18).value
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]

        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        self.btnCreateNewWallets.setAttributedTitle(attributedTitle, for: .normal)
        self.lblWalletSetup.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.walletsetup, comment: "")
        self.lblEnterFreedom.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.enterthefinancialfreedom, comment: "")
        
        /// Animation Properties
        lottiView.loopMode = .loop
        lottiView.animationSpeed = 2
        lottiView.contentMode = .scaleAspectFill
        
        lblWalletSetup.font = AppFont.violetRegular(32).value
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  lottiView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // lottiView.stop()
    }
    
    @IBAction func actionCreateNewWallet(_ sender: Any) {
        HapticFeedback.generate(.light)
        UserDefaults.standard.set(false, forKey: DefaultsKey.isRestore)
        
        if UserDefaults.standard.object(forKey: DefaultsKey.appPasscode) == nil {
            let viewToNavigate = LegalViewController()
            self.navigationController?.pushViewController(viewToNavigate, animated: true)
        } else {
            let viewToNavigate = SecretPhraseBackupViewController()
            self.navigationController?.pushViewController(viewToNavigate, animated: true)
        }
    }
    
    @IBAction func actionImport(_ sender: Any) {
        HapticFeedback.generate(.light)
        UserDefaults.standard.set(true, forKey: DefaultsKey.isRestore)
        
        if UserDefaults.standard.object(forKey: DefaultsKey.appPasscode) == nil {
            let viewToNavigate = LegalViewController()
            self.navigationController?.pushViewController(viewToNavigate, animated: true)
        } else {
            let viewToNavigate = RestoreWalletViewController()
            self.navigationController?.pushViewController(viewToNavigate, animated: true)
        }
        
    }
}

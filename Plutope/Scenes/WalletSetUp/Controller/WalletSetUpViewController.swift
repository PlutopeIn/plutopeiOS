//
//  WalletSetUpViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import UIKit
import Lottie

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
        
        self.btnImport.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.importUsingSecretRecoveryPhrase, comment: ""), for: .normal)
        self.btnCreateNewWallets.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.createAnewwallet, comment: ""), for: .normal)
        self.lblWalletSetup.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.walletsetup, comment: "")
        self.lblEnterFreedom.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.enterthefinancialfreedom, comment: "")
        
        /// Animation Properties
        lottiView.loopMode = .loop
        lottiView.animationSpeed = 2
        lottiView.contentMode = .scaleAspectFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lottiView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lottiView.stop()
    }
    
    @IBAction func actionCreateNewWallet(_ sender: Any) {
        
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

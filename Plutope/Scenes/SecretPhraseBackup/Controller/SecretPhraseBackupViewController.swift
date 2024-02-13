//
//  SecretPhraseBackupViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//

import UIKit
import Lottie

class SecretPhraseBackupViewController: UIViewController, Reusable {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblSecretPhraseBackup: UILabel!
    @IBOutlet weak var lblSecretPhraseBackupDetail: UILabel!
    @IBOutlet weak var btnBackUpManually: UIButton!
    @IBOutlet weak var animationView: LottieAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation header
        defineHeader(headerView: headerView, titleText: "")
        self.lblSecretPhraseBackup.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.secretphrasebackup, comment: "")
        self.btnBackUpManually.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.backupmanually, comment: ""), for: .normal)
        self.lblSecretPhraseBackupDetail.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.yourSecretPhraseIsMasterkeytoyourWallet, comment: "")
        
        
        /// Animation Properties
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.contentMode = .scaleAspectFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationView.stop()
    }
    
    @IBAction func actionBackUpManually(_ sender: Any) {
        let viewToNavigate = BackupWalletViewController()
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    
    @IBAction func actionBackupToCloud(_ sender: Any) {
        let viewToNavigate = NameYourBackupViewController()
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
}

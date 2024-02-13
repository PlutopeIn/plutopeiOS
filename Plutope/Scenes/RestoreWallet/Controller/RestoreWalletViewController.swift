//
//  RestoreWalletViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 16/06/23.
//
import UIKit
import Lottie
import UniformTypeIdentifiers

class RestoreWalletViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var ivRestore: UIImageView!
    @IBOutlet weak var lblRestoreWallet: UILabel!
    @IBOutlet weak var lblRestoreWallet12Words: UILabel!
    @IBOutlet weak var btnRestoreWithSecret: UIButton!
    @IBOutlet weak var btnRestoreWithiCloud: UIButton!
    
    fileprivate func uiSetup() {
        self.lblRestoreWallet.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.restoreyourwallet, comment: "")
        self.lblRestoreWallet12Words.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.restoreyourwalletwiththe12wordsecretphrase, comment: "")
        self.btnRestoreWithSecret.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.restorewithsecretphrase, comment: ""), for: .normal)
        self.btnRestoreWithiCloud.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.restorewithiCloud, comment: ""), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Navigation header
        defineHeader(headerView: headerView, titleText: "")
        ivRestore.contentMode = UIDevice.current.hasNotch ? .center: .scaleAspectFit
        
        /// Animation Properties
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.contentMode = .scaleAspectFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// UISetUp
        uiSetup()
        animationView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationView.stop()
    }
    
    @IBAction func actionRestoreWithiCloud(_ sender: Any) {

        let viewToNavigate = SelectWalletBackUpViewController()
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
        
    }
    
    @IBAction func actionRestorePhrase(_ sender: Any) {
        let viewToNavigate = ImportWalletViewController()
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
}

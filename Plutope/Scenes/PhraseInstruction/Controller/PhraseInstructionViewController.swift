//
//  PhraseInstructionViewController.swift
//  Plutope
//
//  Created by Priyanka on 05/06/23.
//
import UIKit
class PhraseInstructionViewController: UIViewController, Reusable {
    
    weak var delegate: PushViewControllerDelegate?
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblNeverShare: UILabel!
    @IBOutlet weak var lblYour12Words: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: ""), for: .normal)
        self.lblNeverShare.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.nevershareyoursecretphrasewithanyone, comment: "")
        self.lblYour12Words.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.yourSecretPhraseIsOnlyWayToRecoveryourWallet, comment: "")
      
    }
    @IBAction func actionContinue(_ sender: Any) {
        
        self.dismiss(animated: true) {
            guard let proto = self.delegate else {return}
            proto.pushViewController(ConfirmEncryptionPasscodeViewController())
        }
        
    }
}

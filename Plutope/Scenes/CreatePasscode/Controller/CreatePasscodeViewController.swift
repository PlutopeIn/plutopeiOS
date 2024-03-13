//
//  CreatePasscodeViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
class CreatePasscodeViewController: UIViewController, Reusable {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var clvKeyboard: UICollectionView!
    @IBOutlet weak var lblPassCodeTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet var viewSecuredText: [UIImageView]!
    var isFrom = ""
    var isEnterPasscode = false
    var passcode: String?
    var isFromSecurity: Bool = false
    var verifyPassDelegate: PasscodeVerifyDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Set the title based on the screen context
       
       if self.isFrom == "Biometric" {
            lblPassCodeTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.enterpasscode, comment: "")
        } else {
            lblPassCodeTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.createpasscode, comment: "")
        }
        
        lblDescription.text = isEnterPasscode ? "": LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addsanextralayerofsecuritywhenusingtheapp, comment: "")
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: "", btnBackHidden: isEnterPasscode ? true : false)
        
        /// Keyboard Register
        keyboardRegister()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearPasscode()
    }
    /// Keyboard Register
    func keyboardRegister() {
        clvKeyboard.delegate = self
        clvKeyboard.dataSource = self
        clvKeyboard.register(KeyboardViewCell.nib, forCellWithReuseIdentifier: KeyboardViewCell.reuseIdentifier)
    }
    
}

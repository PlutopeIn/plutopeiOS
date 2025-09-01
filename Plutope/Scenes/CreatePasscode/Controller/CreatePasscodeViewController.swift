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
        lblPassCodeTitle.font = AppFont.violetRegular(32).value
        lblDescription.font = AppFont.regular(14).value
        
        let dynamicLightBlueColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.75) : UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
              }
        lblDescription.textColor = dynamicLightBlueColor
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

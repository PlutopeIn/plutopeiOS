//
//  ConfirmPasscodeViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
class ConfirmPasscodeViewController: UIViewController, Reusable {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var viewSecureText: [UIImageView]!
    @IBOutlet weak var clvKeyboard: UICollectionView!
    @IBOutlet weak var lblConfirmPassword: UILabel!
    @IBOutlet weak var lblAddsExtra: UILabel!
    
    var createPasscode: String = String()
    var passcode: String?
    var isFromSecurity: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblConfirmPassword.font = AppFont.violetRegular(32).value
        lblAddsExtra.font = AppFont.regular(14).value
        let dynamicLightBlueColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.75) : UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
              }
        lblAddsExtra.textColor = dynamicLightBlueColor
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: "")
        self.lblConfirmPassword.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirmpasscode, comment: "")
        self.lblAddsExtra.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addsanextralayerofsecuritywhenusingtheapp, comment: "")
        
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

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
        
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: "")
        self.lblConfirmPassword.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirmpasscode, comment: "")
        self.lblAddsExtra.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addsanextralayerofsecuritywhenusingtheapp, comment: "")
        
        /// Keyboard Register
        keyboardRegister()
       
    }
    /// Keyboard Register
    func keyboardRegister() {
        clvKeyboard.delegate = self
        clvKeyboard.dataSource = self
      
        clvKeyboard.register(KeyboardViewCell.nib, forCellWithReuseIdentifier: KeyboardViewCell.reuseIdentifier)
    }
    
}

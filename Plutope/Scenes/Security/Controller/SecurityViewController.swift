//
//  SecurityViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 20/06/23.
//
import UIKit
class SecurityViewController: UIViewController, Reusable {
    @IBOutlet weak var tbvSecurity: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    var arrSecurityData: [SecurityData] = [
        SecurityData(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.applock, comment: ""), isSwitch: true),
        SecurityData(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lockmethod, comment: ""), isSwitch: false),
        SecurityData(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transactionsigning, comment: ""), isSwitch: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Navigation header
       
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.security, comment: ""))
//        UserDefaults.standard.setValue(true, forKey: DefaultsKey.isTransactionSignin)
        /// Table Register
        tableRegister()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tbvSecurity.reloadData()
        tbvSecurity.restore()
    }
    
    /// Table Register
    func tableRegister() {
        tbvSecurity.delegate = self
        tbvSecurity.dataSource = self
        tbvSecurity.register(SecurityViewCell.nib, forCellReuseIdentifier: SecurityViewCell.reuseIdentifier)
    }
    
}

//
//  LockMethodViewController.swift
//  Plutope
//
//  Created by Mitali Desai on 07/07/23.
//

import UIKit

class LockMethodViewController: UIViewController, Reusable {
    @IBOutlet weak var tbvLockMethod: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    var arrMethodData: [SecurityData] = [
        SecurityData(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.passcode, comment: ""), isSwitch: false),
        SecurityData(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.touchID, comment: ""), isSwitch: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Navigation header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lockmethod, comment: ""))
        
        /// Table Register
        tableRegister()
    }
    
    /// Table Register
    func tableRegister() {
        tbvLockMethod.delegate = self
        tbvLockMethod.dataSource = self
        tbvLockMethod.register(SecurityViewCell.nib, forCellReuseIdentifier: SecurityViewCell.reuseIdentifier)
    }
    
}

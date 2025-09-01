//
//  CardSettingsViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 23/05/24.
//

import UIKit

class CardSettingsViewController: UIViewController {

    @IBOutlet weak var tbvSettings: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    var selectedCurrency = ""
    var arrSettigngData: [CardGroupSettingData] = [
//        CardGroupSettingData(group: [.primarycurrency,.changePassword,.changeEmail])
        CardGroupSettingData(group: [.changePassword,.changeEmail])
    ]
    lazy var myCardViewModel: MyCardViewModel = {
        MyCardViewModel { _ ,message in
        }
    }()
    weak var currencyUpdateDelegate: CurrencyUpdateDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.settings, comment: ""), btnBackHidden: false)
        /// Table Register
        tableRegister()
    }
    /// Table Register
    func tableRegister() {
        tbvSettings.delegate = self
        tbvSettings.dataSource = self
        tbvSettings.register(SettingViewCell.nib, forCellReuseIdentifier: SettingViewCell.reuseIdentifier)
    }
    func changePrimaryCurrency() {
        DGProgressView.shared.showLoader(to: view)
        myCardViewModel.changeCurrencyAPINew(currencies: self.selectedCurrency) { resStatus, message in
            if resStatus == 1 {
                DGProgressView.shared.hideLoader()
//                self.showToast(message: "Primary currency changed", font: AppFont.regular(15).value)
                self.tbvSettings.reloadData()
                self.tbvSettings.restore()
                } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: message, font: AppFont.regular(15).value)
            }
        }
    }
}

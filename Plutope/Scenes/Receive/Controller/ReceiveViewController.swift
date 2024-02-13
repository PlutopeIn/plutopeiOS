//
//  ReceiveViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
class ReceiveViewController: UIViewController, Reusable {
    
    @IBOutlet weak var txtSearch: customTextField!
    @IBOutlet weak var tbvReceiveCoinList: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    var coinDetail: Token?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation Header
        //defineHeader(headerView: headerView, titleText: StringConstants.receive)
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receive, comment: ""))
     
        /// Table register
        tableRegister()
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                txtSearch.textAlignment = .right
            } else {
                txtSearch.textAlignment = .left
            }
            
        }
    /// Table register
    func tableRegister() {
        tbvReceiveCoinList.delegate = self
        tbvReceiveCoinList.dataSource = self
        tbvReceiveCoinList.register(PurchasedCoinViewCell.nib, forCellReuseIdentifier: PurchasedCoinViewCell.reuseIdentifier)
    }
}

//
//  ENSConfirmationPopupViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 05/01/24.
//

import UIKit
import BigInt
protocol ConfirmEnsBuyDelegate : AnyObject {
    func confirmEnsBuy()
}

class ENSConfirmationPopupViewController: UIViewController {

    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCoinAmount: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblAssets: UILabel!
    @IBOutlet weak var lblFromAddress: UILabel!
    @IBOutlet weak var btnConfirm: GradientButton!
    @IBOutlet weak var lblToAddress: UILabel!
    @IBOutlet weak var lblAssetsText: UILabel!
    @IBOutlet weak var lblToText: UILabel!
    @IBOutlet weak var lblFromText: UILabel!
    var gasfee = ""
    var coinDetail : Token?
    var tokenAmount = ""
    var tokentype = ""
    var tokenPrice = ""
    var assets = ""
    var fromAddress = ""
    var toAddress = ""
   
    weak var delegate: ConfirmEnsBuyDelegate?
    var stringWithoutPrefix = ""
      
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transfer, comment: ""))
         /// uiSetup
        uiSetUp()
        
        lblAssets.text = assets
        lblPrice.text = "≈ \(tokenPrice)"
        lblFromAddress.text = fromAddress
        lblToAddress.text = toAddress
        let tValue: BigInt =  UnitConverter.hexStringToBigInteger(hex: tokenAmount)  ?? BigInt(2500000)
        
        let amount = UnitConverter.convertWeiToEther("\(tValue)",18)
        lblCoinAmount.text = "-\(amount ?? "")"
        lblType.text = "\(tokentype)"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblToText.textAlignment = (LocalizationSystem.sharedInstance.getLanguage() == "ar") ? .right : .left
        lblFromText.textAlignment = (LocalizationSystem.sharedInstance.getLanguage() == "ar") ? .right : .left
        lblAssetsText.textAlignment = (LocalizationSystem.sharedInstance.getLanguage() == "ar") ? .right : .left
        
            }
    fileprivate func uiSetUp() {
        self.btnConfirm.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirm, comment: ""), for: .normal)
        self.lblAssetsText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.asset, comment: "")
        self.lblFromText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")
        self.lblToText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")
    }
    
    @IBAction func btnConfirmAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {
            self.delegate?.confirmEnsBuy()
        })
    }
}

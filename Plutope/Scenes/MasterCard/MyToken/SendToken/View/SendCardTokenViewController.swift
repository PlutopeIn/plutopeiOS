//
//  SendCardTokenViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/06/24.
//

import UIKit

class SendCardTokenViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var lblWworldwide: UILabel!
    @IBOutlet weak var lblInstant: UILabel!
    @IBOutlet weak var lblNoFee: UILabel!
    @IBOutlet weak var viewWallet: UIView!
    @IBOutlet weak var viewPhone: UIView!
    
    @IBOutlet weak var lblViaPhoneNo: UILabel!
    
    @IBOutlet weak var lblRecipier: UILabel!
    @IBOutlet weak var lblToAwallet: UILabel!
    @IBOutlet weak var lblEnterAn: UILabel!
    var arrWallet : Wallet?
    var tokenId = ""
    var tokenName = ""
    var isFromDashboard = false
//    weak var delegate : GotoSendDashboardDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        defineHeader(headerView: headerView, titleText:LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.send,comment: "") , btnBackHidden: false)
        lblViaPhoneNo.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sendviaPhone,comment: "")
        
        lblToAwallet.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.sendviaWallet,comment: "")
        lblRecipier.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.tophoneNoMsg,comment: "")
        lblEnterAn.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.toAddressMsg,comment: "")
        lblNoFee.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.noFee,comment: "")
        lblInstant.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.instantly,comment: "")
        
        lblWworldwide.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.worldwide,comment: "")
        
        if arrWallet?.allowOperations?.contains("PAYIN_CRYPTO") ?? false {
            self.viewWallet.isHidden = false
        } else {
            self.viewWallet.isHidden = true
        }
        viewPhone.addTapGesture {
            HapticFeedback.generate(.light)
            let sendByPhonenumberVC = SendCardTokenDetailViewController()
            sendByPhonenumberVC.walletArr = self.arrWallet
            sendByPhonenumberVC.sendVia = "phone"
            sendByPhonenumberVC.titleValue = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.SendbyPhoneNumber,comment: "")
            sendByPhonenumberVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(sendByPhonenumberVC, animated: true)
        }
        viewWallet.addTapGesture {
            HapticFeedback.generate(.light)
            let sendByPhonenumberVC = SendCardTokenDetailViewController()
            sendByPhonenumberVC.walletArr = self.arrWallet
            sendByPhonenumberVC.sendVia = "walletAddress"
            sendByPhonenumberVC.titleValue = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.Sendbywallet,comment: "")
            sendByPhonenumberVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(sendByPhonenumberVC, animated: true)
        }
        
        lblViaPhoneNo.font = AppFont.violetRegular(14.02).value
        lblToAwallet.font = AppFont.violetRegular(14.02).value
        lblRecipier.font = AppFont.regular(12.27).value
        lblEnterAn.font = AppFont.regular(12.27).value
        lblInstant.font = AppFont.regular(10).value
        lblNoFee.font = AppFont.regular(10).value
        lblWworldwide.font = AppFont.regular(10).value
    }

}

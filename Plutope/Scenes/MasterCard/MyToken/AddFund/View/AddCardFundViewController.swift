//
//  AddCardFundViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/06/24.
//

import UIKit

class AddCardFundViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var lblInstant: UILabel!
    @IBOutlet weak var lblreceiveCry: UILabel!
    @IBOutlet weak var lblExternal: UILabel!
    @IBOutlet weak var lblBuyCrypto: UILabel!
    @IBOutlet weak var lblBankcard: UILabel!
    @IBOutlet weak var viewWallet: UIView!
    @IBOutlet weak var viewPhone: UIView!
    var arrWallet : Wallet?
    var tokenId = ""
    var tokenName = ""
    var isFrom = ""
    var isFromDashboard = false
    var arrCardList : [PayInCard] = []
    var arrWalletList : [Wallet] = []
    var arrCurrencyList : [String] = []
    var priceDataValueArr : [PriceDataValues] = []
    var priceDataValueSring : String = ""
    var cardRequestId : Int?
    var arrPayInOtherData : PayInOtherDataList?
    lazy var myCardViewModel: MyCardViewModel = {
        MyCardViewModel { _ ,_ in
        }
    }()
    lazy var myTokenViewModel: MyTokenViewModel = {
        MyTokenViewModel { _ ,_ in
        }
    }()
    lazy var bankCardPayInViewModel: BankCardPayInViewModel = {
        BankCardPayInViewModel { _ ,_ in
        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        defineHeader(headerView: headerView, titleText:LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addFunds,comment: "") , btnBackHidden: false)
        if isFromDashboard == true {
            viewWallet.isHidden = false
        } else {
            
            if !(arrWallet?.allowOperations?.contains("PAYIN_CRYPTO") ?? false) {
                viewWallet.isHidden = true
            } else {
                viewWallet.isHidden = false
            }
        }
        if isFromDashboard == true {
            viewWallet.addTapGesture {
                HapticFeedback.generate(.light)
                let cardReceiveVC = CardReceiveViewController()
                cardReceiveVC.walletAddress = self.arrWallet?.address ?? ""
                cardReceiveVC.walletArr = self.arrWallet
                cardReceiveVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(cardReceiveVC, animated: true)
            }
            viewPhone.addTapGesture {
                HapticFeedback.generate(.light)
                let cardBuyVC = BuyCardDashboardViewController()
                // cardReceiveVC.walletAddress = self.arrWallet?.address ?? ""
                cardBuyVC.arrWallet = self.arrWallet
               // cardBuyVC.isFrom = self.isFrom
                cardBuyVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(cardBuyVC, animated: true)
            }
        } else {
            viewWallet.addTapGesture {
                HapticFeedback.generate(.light)
                let cardReceiveVC = CardReceiveViewController()
                cardReceiveVC.walletAddress = self.arrWallet?.address ?? ""
                cardReceiveVC.walletArr = self.arrWallet
                cardReceiveVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(cardReceiveVC, animated: true)
            }
            viewPhone.addTapGesture {
                HapticFeedback.generate(.light)
                let cardBuyVC = BuyCardDashboardViewController()
                //cardReceiveVC.walletAddress = self.arrWallet?.address ?? ""
                cardBuyVC.arrWallet = self.arrWallet
                cardBuyVC.isFrom = self.isFrom
                self.navigationController?.pushViewController(cardBuyVC, animated: true)
            }
        }
        lblBankcard.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.bankCard,comment: "")
        lblBuyCrypto.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.buyCryptoWithYourBankCard,comment: "")
        lblExternal.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.externalWallet,comment: "")
        lblreceiveCry.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.receiveCryptoFromAnotherWallet,comment: "")
        lblInstant.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.instantly,comment: "")
        
        lblBankcard.font = AppFont.violetRegular(14.02).value
        lblExternal.font = AppFont.violetRegular(14.02).value
        lblBuyCrypto.font = AppFont.regular(12.27).value
        lblreceiveCry.font = AppFont.regular(12.27).value
        lblInstant.font = AppFont.regular(10).value
    }
}

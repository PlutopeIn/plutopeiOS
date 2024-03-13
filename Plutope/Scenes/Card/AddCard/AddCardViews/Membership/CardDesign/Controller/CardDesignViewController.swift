//
//  CardDesignViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/08/23.
//

import UIKit

class CardDesignViewController: UIViewController , Reusable {

    @IBOutlet weak var tbvHeight: NSLayoutConstraint!
    @IBOutlet weak var btnContinue: GradientButton!
    @IBOutlet weak var tbvWallets: UITableView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblWallet: UILabel!
    
    var receivedPlanPrice: String?
    var price = ""
    var onNextButtonTapped: ((_ data: String) -> Void)?
    var walletDataArr = [CardDesignWallets]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: ""), for: .normal)
        self.lblWallet.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallet, comment: "")
        registerTableview()
        if let data = receivedPlanPrice {
            lblPrice.text = "\(data)"
            self.price = data
            print("Received data: \(data)")
        }
        
        /*walletDataArr = [
            CardDesignWallets(title: StringConstants.wallets, values: [WalletValues(title: StringConstants.USDollar, img: UIImage.icUSA),WalletValues(title: StringConstants.PoundSterling, img: UIImage.icUK),WalletValues(title: StringConstants.Euro, img: UIImage.icEuropeanUnion)]),
            CardDesignWallets(title: StringConstants.Crypto, values: [WalletValues(title: StringConstants.BitCoin, img: UIImage.icBnb)])]*/
        walletDataArr = [
            CardDesignWallets(title:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.wallets, comment: ""), values: [WalletValues(title: StringConstants.USDollar, img: UIImage.icUSA),WalletValues(title: StringConstants.PoundSterling, img: UIImage.icUK),WalletValues(title: StringConstants.Euro, img: UIImage.icEuropeanUnion)]),
            CardDesignWallets(title:  LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.crypto, comment: ""), values: [WalletValues(title: StringConstants.BitCoin, img: UIImage.icBnb)])]
        
    }
    /// Collection Register
    private func registerTableview() {
        tbvWallets.register(CardWalletTableViewCell.nib, forCellReuseIdentifier: CardWalletTableViewCell.reuseIdentifier)
        tbvWallets.delegate = self
        tbvWallets.dataSource = self
       
    }
    @IBAction func btnContinueAction(_ sender: GradientButton) {
        
        onNextButtonTapped?(price)
    }
}

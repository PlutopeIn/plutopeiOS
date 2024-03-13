//
//  PreviewSwapViewController.swift
//  Plutope
//
//  Created by Mitali Desai on 24/08/23.
//

import UIKit

protocol ConfirmSwapDelegate : AnyObject {
    func confirmSwap()
}

class PreviewSwapViewController: UIViewController {
    
    @IBOutlet weak var lblQuoteText: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblProviderFee: UILabel!
    @IBOutlet weak var lblNetworkFee: UILabel!
    @IBOutlet weak var lblNetworkFeeText: UILabel!
    @IBOutlet weak var lblSlippage: UILabel!
    @IBOutlet weak var lblSlippageText: UILabel!
    @IBOutlet weak var lblQoute: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblFromText: UILabel!
    @IBOutlet weak var lblGetCoinType: UILabel!
    @IBOutlet weak var lblGetCoinAmount: UILabel!
    @IBOutlet weak var lblPayCoinType: UILabel!
    @IBOutlet weak var lblPayCoinAmount: UILabel!
    @IBOutlet weak var ivGetCoin: UIImageView!
    @IBOutlet weak var ivPayCoin: UIImageView!
    @IBOutlet weak var btnConfirmSwap: UIButton!
    @IBOutlet weak var viewFee: UIView!
   
    @IBOutlet weak var viewQuote: UIView!
    var swapQouteDetail: [Routers] = []
    var previewSwapDetail: PreviewSwap?
    weak var delegate: ConfirmSwapDelegate?
    var isFrom = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        /// Navigation Header
       
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: ""))
        
        self.lblFromText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")
        self.lblNetworkFeeText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.networkfee, comment: "")
        self.lblSlippageText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.maxslipage, comment: "")
        self.btnConfirmSwap.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirmswap, comment: ""), for: .normal)
        
        self.lblQuoteText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.quots, comment: "")
       
        self.btnConfirmSwap.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirmswap, comment: ""), for: .normal)
        
        /// setSwapDetail
        setSwapDetail()
    }
    
    private func setSwapDetail() {
        guard let swapData = swapQouteDetail.first else {
            return
        }
        if previewSwapDetail?.payCoinDetail?.chain?.coinType == CoinType.bitcoin {
            let payPrice = ((Double(previewSwapDetail?.payAmount ?? "") ?? 0.0) * (Double(previewSwapDetail?.payCoinDetail?.price ?? "") ?? 0.0))
            let payPriceValue =  WalletData.shared.formatDecimalString("\(payPrice)", decimalPlaces: 8)
            let payAmount = WalletData.shared.formatDecimalString("\(previewSwapDetail?.payAmount ?? "")", decimalPlaces: 10)
            lblPayCoinAmount.text = "\(payAmount) \(previewSwapDetail?.payCoinDetail?.symbol ?? "")"
            ivPayCoin.sd_setImage(with: URL(string: previewSwapDetail?.payCoinDetail?.logoURI ?? ""))
            lblPayCoinType.text = "\(self.previewSwapDetail?.payCoinDetail?.type ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(payPriceValue))"

            let getPrice = ((Double(previewSwapDetail?.getAmount ?? "") ?? 0.0) * (Double(previewSwapDetail?.getCoinDetail?.price ?? "") ?? 0.0))
            let getPriceValue =  WalletData.shared.formatDecimalString("\(getPrice)", decimalPlaces: 8)
            let getAmount = WalletData.shared.formatDecimalString("\(previewSwapDetail?.getAmount ?? "")", decimalPlaces: 10)
            lblGetCoinAmount.text = "\(getAmount) \(previewSwapDetail?.getCoinDetail?.symbol ?? "")"
            ivGetCoin.sd_setImage(with: URL(string: previewSwapDetail?.getCoinDetail?.logoURI ?? ""))
            lblGetCoinType.text = "\(self.previewSwapDetail?.getCoinDetail?.type ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(getPriceValue))"
           // self.viewFee.isHidden = true
            lblFrom.text = previewSwapDetail?.payCoinDetail?.chain?.walletAddress ?? ""
           // self.viewQuote.isHidden = true
        } else {
            let payPrice = ((Double(previewSwapDetail?.payAmount ?? "") ?? 0.0) * (Double(previewSwapDetail?.payCoinDetail?.price ?? "") ?? 0.0))
            let payPriceValue =  WalletData.shared.formatDecimalString("\(payPrice)", decimalPlaces: 2)
            let payAmount = WalletData.shared.formatDecimalString("\(previewSwapDetail?.payAmount ?? "")", decimalPlaces: 6)
            lblPayCoinAmount.text = "\(payAmount) \(previewSwapDetail?.payCoinDetail?.symbol ?? "")"
            ivPayCoin.sd_setImage(with: URL(string: previewSwapDetail?.payCoinDetail?.logoURI ?? ""))
            lblPayCoinType.text = "\(self.previewSwapDetail?.payCoinDetail?.type ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(payPriceValue))"
            let getPrice = ((Double(previewSwapDetail?.getAmount ?? "") ?? 0.0) * (Double(previewSwapDetail?.getCoinDetail?.price ?? "") ?? 0.0))
            let getPriceValue =  WalletData.shared.formatDecimalString("\(getPrice)", decimalPlaces: 2)
            let getAmount = WalletData.shared.formatDecimalString("\(previewSwapDetail?.getAmount ?? "")", decimalPlaces: 6)
            lblGetCoinAmount.text = "\(getAmount) \(previewSwapDetail?.getCoinDetail?.symbol ?? "")"
            ivGetCoin.sd_setImage(with: URL(string: previewSwapDetail?.getCoinDetail?.logoURI ?? ""))
            lblGetCoinType.text = "\(self.previewSwapDetail?.getCoinDetail?.type ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(getPriceValue))"
            
            if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
                let allCoin = allToken.filter { $0.address == "" && $0.type == self.previewSwapDetail?.payCoinDetail?.type && $0.symbol == self.previewSwapDetail?.payCoinDetail?.chain?.symbol ?? "" }
                let fee = (Int(swapData.tx?.gas ?? "") ?? 0) * (Int(swapData.tx?.gasPrice ?? "") ?? 0)
                let convertedValue = UnitConverter.convertWeiToEther(String(fee),previewSwapDetail?.payCoinDetail?.chain?.decimals ?? 0) ?? ""
                let gasPrice = ((Double(convertedValue) ?? 0.0) * (Double(allCoin.first?.price ?? "") ?? 0.0))
                let estimateValue = WalletData.shared.formatDecimalString("\(gasPrice)", decimalPlaces: 2)
                lblNetworkFee.text = "\(convertedValue) \(previewSwapDetail?.payCoinDetail?.chain?.symbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(estimateValue))"
            }
            lblFrom.text = previewSwapDetail?.payCoinDetail?.chain?.walletAddress ?? ""
            lblQoute.text = previewSwapDetail?.quote
            lblSlippage.text = "0.1%"
        }
    }
    @IBAction func btnConfirmSwapAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.confirmSwap()
//            guard let sceneDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
//            guard let viewController = sceneDelegate.window?.rootViewController else { return }
//            AppPasscodeHelper().handleAppPasscodeIfNeeded(in: viewController, completion: { status in
//                if status {
//                    self.delegate?.confirmSwap()
//                }
//            })
        }
    }
}

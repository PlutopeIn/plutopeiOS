//
//  PreviewSwap1ViewController.swift
//  Plutope
//
//  Created by Mitali Desai on 24/08/23.
//

import UIKit

protocol ConfirmSwap1Delegate : AnyObject {
    func confirmSwap1(isFrom:String,swappingFee:String)
}

class PreviewSwap1ViewController: UIViewController {
    
    @IBOutlet weak var viewQuote: UIView!
    @IBOutlet weak var viewFee: UIView!
    @IBOutlet weak var viewSwapperFee: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblNetworkFee: UILabel!
    @IBOutlet weak var lblNetworkFeeText: UILabel!
    @IBOutlet weak var lblSlippage: UILabel!
    @IBOutlet weak var lblSlippageText: UILabel!
    @IBOutlet weak var lblQoute: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblFromText: UILabel!
    @IBOutlet weak var lblGetCoinType: UILabel!
    @IBOutlet weak var lblGetCoinAmount: UILabel!
    @IBOutlet weak var lblQuoteText: UILabel!
    @IBOutlet weak var lblPayCoinType: UILabel!
    @IBOutlet weak var lblPayCoinAmount: UILabel!
    @IBOutlet weak var lblSwapperFee: UILabel!
 
    @IBOutlet weak var lblSwapperFeeText: UILabel!
    @IBOutlet weak var ivGetCoin: UIImageView!
    @IBOutlet weak var ivPayCoin: UIImageView!
    @IBOutlet weak var btnConfirmSwap: UIButton!
    var isFrom = ""
    var gasfee = ""
    var swapQouteDetail: [Routers] = []
    var previewSwapDetail: PreviewSwap?
    var swappingFee = ""
    weak var delegate: ConfirmSwap1Delegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: ""))
        
        self.lblFromText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")
      
        self.lblNetworkFeeText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.networkfee, comment: "")
        self.lblSlippageText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.maxslipage, comment: "")
        self.lblSwapperFeeText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swapperfee, comment: "")
        self.btnConfirmSwap.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirmswap, comment: ""), for: .normal)
        
        // setSwapDetail
        setSwapDetail()
    }
    // setSwapDetail
    func setSwapDetail() {
        
        if previewSwapDetail?.payCoinDetail?.chain?.coinType == CoinType.bitcoin {
            lblPayCoinAmount.text = "\(previewSwapDetail?.payAmount ?? "") \(previewSwapDetail?.payCoinDetail?.symbol ?? "")"
            ivPayCoin.sd_setImage(with: URL(string: previewSwapDetail?.payCoinDetail?.logoURI ?? ""))
            
            lblGetCoinAmount.text = "\(previewSwapDetail?.getAmount ?? "") \(previewSwapDetail?.getCoinDetail?.symbol ?? "")"
            ivGetCoin.sd_setImage(with: URL(string: previewSwapDetail?.getCoinDetail?.logoURI ?? ""))
            lblPayCoinType.text = self.previewSwapDetail?.payCoinDetail?.type ?? ""
            lblGetCoinType.text = self.previewSwapDetail?.getCoinDetail?.type ?? ""
            self.viewFee.isHidden = true
            lblFrom.text = previewSwapDetail?.payCoinDetail?.chain?.walletAddress ?? ""
            self.viewQuote.isHidden = true
        } else {
        if isFrom == "rango" {
            self.viewSwapperFee.isHidden = false
        } else {
            self.viewSwapperFee.isHidden = true
        }
        lblPayCoinAmount.text = "\(previewSwapDetail?.payAmount ?? "") \(previewSwapDetail?.payCoinDetail?.symbol ?? "")"
        ivPayCoin.sd_setImage(with: URL(string: previewSwapDetail?.payCoinDetail?.logoURI ?? ""))
        
        lblGetCoinAmount.text = "\(previewSwapDetail?.getAmount ?? "") \(previewSwapDetail?.getCoinDetail?.symbol ?? "")"
        ivGetCoin.sd_setImage(with: URL(string: previewSwapDetail?.getCoinDetail?.logoURI ?? ""))
        lblPayCoinType.text = self.previewSwapDetail?.payCoinDetail?.type ?? ""
        lblGetCoinType.text = self.previewSwapDetail?.getCoinDetail?.type ?? ""
        if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
            let allCoin = allToken.filter { $0.address == "" && $0.type == self.previewSwapDetail?.payCoinDetail?.type && $0.symbol == self.previewSwapDetail?.payCoinDetail?.chain?.symbol ?? "" }
            let tokenamount = Double(previewSwapDetail?.payAmount ?? "") ?? 0.0
            self
                .previewSwapDetail?.payCoinDetail?.callFunction.getGasFee(previewSwapDetail?.payCoinDetail?.chain?.walletAddress, tokenAmount: tokenamount, completion: { status, msg, gasPrice,gasLimit,nonce,data in
                    if status {
                        print(msg ?? "")
                        self.gasfee = msg ?? ""
                        let fee = self.gasfee
                        let convertedValue = UnitConverter.convertWeiToEther(fee,self.previewSwapDetail?.payCoinDetail?.chain?.decimals ?? 0) ?? ""
                        let gasPrice = ((Double(convertedValue) ?? 0.0) * (Double(allCoin.first?.price ?? "") ?? 0.0))
                        let originalString = convertedValue
                        if Double(originalString) != nil {
                            let formattedString = WalletData.shared.formatDecimalString("\(originalString)", decimalPlaces: 10)
                            print(formattedString)
                            DispatchQueue.main.async {
                                // DGProgressView.shared.hideLoader()
                                let priceValue = WalletData.shared.formatDecimalString("\(gasPrice)", decimalPlaces: 2)
                                self.lblNetworkFee.text = "\(formattedString) \(self.previewSwapDetail?.payCoinDetail?.chain?.symbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(priceValue))"
                            }
                        }
                        let swapPrice = ((Double(self.swappingFee) ?? 0.0) * (Double(allCoin.first?.price ?? "") ?? 0.0))
                        let originalSwapString = self.swappingFee
                        if let originalSwapNumber = Double(originalSwapString) {
                            let formattedSwapString = WalletData.shared.formatDecimalString("\(originalSwapNumber)", decimalPlaces: 10)
                            //let formattedSwapString = String(format: "%.8f", originalSwapNumber)
                            print(formattedSwapString)
                            
                            DispatchQueue.main.async {
                                //  DGProgressView.shared.hideLoader()
                                let sawpValue = WalletData.shared.formatDecimalString("\(swapPrice)", decimalPlaces: 4)
                                self.lblSwapperFee.text = "\(formattedSwapString) \(self.previewSwapDetail?.payCoinDetail?.chain?.symbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(sawpValue))"
                            }
                        }
                    }
                })
        }
        
        lblFrom.text = previewSwapDetail?.payCoinDetail?.chain?.walletAddress ?? ""
        lblQoute.text = previewSwapDetail?.quote
        lblSlippage.text = "0.1%"
    }  // else
        
    }
    @IBAction func btnConfirmSwapAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.confirmSwap1(isFrom: self.isFrom, swappingFee: self.swappingFee)
//            guard let sceneDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
//            guard let viewController = sceneDelegate.window?.rootViewController else { return }
//            AppPasscodeHelper().handleAppPasscodeIfNeeded(in: viewController, completion: { status in
//                if status {
//                    self.delegate?.confirmSwap1(isFrom: self.isFrom, swappingFee: self.swappingFee)
//                }
//            })
        }
    }
}

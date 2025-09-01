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
    @IBOutlet weak var lblNetworkFee: UILabel!
    @IBOutlet weak var lblNetworkFeeText: UILabel!
    @IBOutlet weak var lblSlippage: UILabel!
    @IBOutlet weak var lblSlippageText: UILabel!
    @IBOutlet weak var lblQoute: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblFromText: UILabel!
    @IBOutlet weak var btnConfirmSwap: UIButton!
    @IBOutlet weak var viewFee: UIView!
    
    @IBOutlet weak var ivGetCoin: UIImageView!
    @IBOutlet weak var ivPayCoin: UIImageView!
    @IBOutlet weak var lblPaySymbol: UILabel!
    @IBOutlet weak var lblGetSymbol: UILabel!
    /// pay Coin
    @IBOutlet weak var lblCoinName: UILabel!
    @IBOutlet weak var lblPayCoinBalance: UILabel!
    @IBOutlet weak var lblPayCoinValue: DesignableLabel!
    @IBOutlet weak var lblGetCoinValue: DesignableLabel!
    /// Get Coin Outlets
   
    @IBOutlet weak var lblGetCoinName: UILabel!
  
   
    @IBOutlet weak var lblType1: DesignableLabel!
    @IBOutlet weak var lblType2: DesignableLabel!
    @IBOutlet weak var lblGetCoinBalance: UILabel!
   
    @IBOutlet weak var viewQuote: UIView!
    var swapQouteDetail: [Routers] = []
    var previewSwapDetail: PreviewSwap?
    weak var delegate: ConfirmSwapDelegate?
    var isFrom = ""
  
    var gasfee = ""
    var swappingFee = ""
    var outputAmount = ""
    var networkFee = ""
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
//        guard let swapData = swapQouteDetail.first else {
//            return
//        }
        if previewSwapDetail?.payCoinDetail?.chain?.coinType == CoinType.bitcoin {
            let payPrice = ((Double(previewSwapDetail?.payAmount ?? "") ?? 0.0) * (Double(previewSwapDetail?.payCoinDetail?.price ?? "") ?? 0.0))
            let payPriceValue =  WalletData.shared.formatDecimalString("\(payPrice)", decimalPlaces: 5)
            let payAmount = WalletData.shared.formatDecimalString("\(previewSwapDetail?.payAmount ?? "")", decimalPlaces: 10)
            lblPayCoinValue.text = "\(payAmount) \(previewSwapDetail?.payCoinDetail?.symbol ?? "")"
            lblPayCoinBalance.text = "\(payPriceValue) \(WalletData.shared.primaryCurrency?.sign ?? "")"
            lblCoinName.text = "\(previewSwapDetail?.payCoinDetail?.symbol ?? "")"
            ivPayCoin.sd_setImage(with: URL(string: previewSwapDetail?.payCoinDetail?.logoURI ?? ""))
            lblType1.text = "\(self.previewSwapDetail?.payCoinDetail?.type ?? "")"
            lblType2.text = "\(self.previewSwapDetail?.getCoinDetail?.type ?? "")"
            lblPaySymbol.text = "\(self.previewSwapDetail?.payCoinDetail?.name ?? "")"
            lblGetSymbol.text = "\(self.previewSwapDetail?.getCoinDetail?.name ?? "")"
            let getPrice = ((Double(previewSwapDetail?.getAmount ?? "") ?? 0.0) * (Double(previewSwapDetail?.getCoinDetail?.price ?? "") ?? 0.0))
            let getPriceValue =  WalletData.shared.formatDecimalString("\(getPrice)", decimalPlaces: 5)
            let getAmount = WalletData.shared.formatDecimalString("\(previewSwapDetail?.getAmount ?? "")", decimalPlaces: 4)
            lblGetCoinName.text = "\(previewSwapDetail?.getCoinDetail?.symbol ?? "")"
            ivGetCoin.sd_setImage(with: URL(string: previewSwapDetail?.getCoinDetail?.logoURI ?? ""))
            lblGetCoinValue.text = "\(getAmount) \(previewSwapDetail?.getCoinDetail?.symbol ?? "")"
            lblGetCoinBalance.text = "\(getPriceValue) \(WalletData.shared.primaryCurrency?.sign ?? "")"
            lblFrom.text = previewSwapDetail?.payCoinDetail?.chain?.walletAddress ?? ""
           // self.viewQuote.isHidden = true
        } else {
            let payPrice = ((Double(previewSwapDetail?.payAmount ?? "") ?? 0.0) * (Double(previewSwapDetail?.payCoinDetail?.price ?? "") ?? 0.0))
            let payPriceValue =  WalletData.shared.formatDecimalString("\(payPrice)", decimalPlaces: 5)
            let payAmount = WalletData.shared.formatDecimalString("\(previewSwapDetail?.payAmount ?? "")", decimalPlaces: 6)
            lblPayCoinValue.text = "\(payAmount) \(previewSwapDetail?.payCoinDetail?.symbol ?? "")"
            lblPayCoinBalance.text = "\(payPriceValue) \(WalletData.shared.primaryCurrency?.sign ?? "")"
            lblCoinName.text = "\(previewSwapDetail?.payCoinDetail?.symbol ?? "")"
            lblGetCoinName.text = "\(previewSwapDetail?.getCoinDetail?.symbol ?? "")"
            ivPayCoin.sd_setImage(with: URL(string: previewSwapDetail?.payCoinDetail?.logoURI ?? ""))
            lblType1.text = "\(self.previewSwapDetail?.payCoinDetail?.type ?? "")"
            lblType2.text = "\(self.previewSwapDetail?.getCoinDetail?.type ?? "")"
            lblPaySymbol.text = "\(self.previewSwapDetail?.payCoinDetail?.name ?? "")"
            lblGetSymbol.text = "\(self.previewSwapDetail?.getCoinDetail?.name ?? "")"
            let getPrice = ((Double(previewSwapDetail?.getAmount ?? "") ?? 0.0) * (Double(previewSwapDetail?.getCoinDetail?.price ?? "") ?? 0.0))
            let getPriceValue =  WalletData.shared.formatDecimalString("\(getPrice)", decimalPlaces: 5)
            let getAmount = WalletData.shared.formatDecimalString("\(previewSwapDetail?.getAmount ?? "")", decimalPlaces: 10)
            lblGetCoinValue.text = "\(getAmount) \(previewSwapDetail?.getCoinDetail?.symbol ?? "")"
            lblGetCoinBalance.text = " \(getPriceValue) \(WalletData.shared.primaryCurrency?.sign ?? "")"
            ivGetCoin.sd_setImage(with: URL(string: previewSwapDetail?.getCoinDetail?.logoURI ?? ""))
            let tokenamount = Double(previewSwapDetail?.payAmount ?? "") ?? 0.0
            if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
//                let allCoin = allToken.filter { $0.address == "" && $0.type == self.previewSwapDetail?.payCoinDetail?.type && $0.symbol == self.previewSwapDetail?.payCoinDetail?.chain?.symbol ?? "" }
                // 1. Get required values
//                let chainName = previewSwapDetail?.payCoinDetail?.chain?.name ?? ""
//                let payCoinType = previewSwapDetail?.payCoinDetail?.type
//                let payChainSymbol = previewSwapDetail?.paySymbol
//                let specificChains = ["Base", "Arbitrum One", "OP Mainnet"]
//
//                // 2. Filter tokens safely
//                let allCoin: [Token] = allToken.filter { token in
//                    guard token.address == "",
//                          token.type == payCoinType,
//                          token.symbol == payChainSymbol else {
//                        return false
//                    }
//
//                    if specificChains.contains(chainName) {
//                        return token.chain?.name == chainName
//                    }
//
//                    return true
//                }
//
//                print("Filtered allCoin:", allCoin.map { $0.symbol ?? "-" })
//
//                // 3. Unwrap selected token
//                guard let selectedToken = allCoin.first else {
//                    print("No matching token found")
//                    return
//                }
                let chainName = previewSwapDetail?.payCoinDetail?.chain?.name ?? ""
                let payCoinType = previewSwapDetail?.payCoinDetail?.type
                let payChainSymbol = previewSwapDetail?.paySymbol?.uppercased()
                let specificChains = ["Base", "Arbitrum One", "OP Mainnet"]

                print("chainName:", chainName)
                print("payCoinType:", payCoinType ?? "-")
                print("payChainSymbol:", previewSwapDetail?.payCoinDetail?.chain?.symbol.uppercased() ?? "-")

                let allCoin: [Token]

                if specificChains.contains(chainName) {
                    // Stricter filtering for specific chains
                    allCoin = allToken.filter { token in
                        return token.address == "" &&
                               token.type == payCoinType &&
                               token.symbol?.uppercased() == "ETH" &&
                               token.chain?.name == chainName
                    }
                } else {
                    // Looser filtering for other chains
                     allCoin = allToken.filter { $0.address == "" && $0.type == self.previewSwapDetail?.payCoinDetail?.type && $0.symbol == self.previewSwapDetail?.payCoinDetail?.chain?.symbol ?? "" }
                }

                print("Filtered allCoin:", allCoin.map { $0.symbol ?? "-" })

                guard let selectedToken = allCoin.first else {
                    print("No matching token found")
                    return
                }
                self
                    .previewSwapDetail?.payCoinDetail?.callFunction.getGasFee(previewSwapDetail?.payCoinDetail?.chain?.walletAddress, tokenAmount: tokenamount, completion: { status, msg, gasPrice,gasLimit,nonce,data in
                        if status {
                            print(msg ?? "")
                            self.gasfee = msg ?? ""
                            let fee = self.gasfee
                            let convertedValue = UnitConverter.convertWeiToEther(fee,self.previewSwapDetail?.payCoinDetail?.chain?.decimals ?? 0) ?? ""
                            let gasPrice = ((Double(convertedValue) ?? 0.0) * (Double(selectedToken.price ?? "") ?? 0.0))
                            let originalString = convertedValue
                            if Double(originalString) != nil {
                                let formattedString = WalletData.shared.formatDecimalString("\(originalString)", decimalPlaces: 10)
                                print(formattedString)
                                DispatchQueue.main.async {
                                    DGProgressView.shared.hideLoader()
                                    let priceValue = WalletData.shared.formatDecimalString("\(gasPrice)", decimalPlaces: 5)
                                    self.lblNetworkFee.text = "\(formattedString) \(selectedToken.symbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(priceValue))"
                                }
                            }
                        }
                    })
            }
            lblFrom.text = previewSwapDetail?.payCoinDetail?.chain?.walletAddress ?? ""
            lblQoute.text = previewSwapDetail?.quote
            lblSlippage.text = "0.1%"
        }
    }
    @IBAction func btnConfirmSwapAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.dismiss(animated: true) {
            self.delegate?.confirmSwap()

        }
    }
}

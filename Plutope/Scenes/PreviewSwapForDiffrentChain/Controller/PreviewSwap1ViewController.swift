//
//  PreviewSwap1ViewController.swift
//  Plutope
//
//  Created by Mitali Desai on 24/08/23.
//

import UIKit
import BigInt

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
    @IBOutlet weak var lblQuoteText: UILabel!
    @IBOutlet weak var lblSwapperFee: UILabel!
    @IBOutlet weak var lblPaySymbol: UILabel!
    @IBOutlet weak var lblGetSymbol: UILabel!
    /// pay Coin 
    @IBOutlet weak var lblCoinName: UILabel!
    @IBOutlet weak var lblPayCoinBalance: DesignableLabel!
    @IBOutlet weak var lblPayCoinValue: UILabel!
    @IBOutlet weak var lblGetCoinValue: UILabel!
    /// Get Coin Outlets
   
    @IBOutlet weak var lblGetCoinName: UILabel!
   
    @IBOutlet weak var lblType1: DesignableLabel!
    @IBOutlet weak var lblType2: DesignableLabel!
    @IBOutlet weak var lblGetCoinBalance: DesignableLabel!
   
    @IBOutlet weak var lblSwapperFeeText: UILabel!
    @IBOutlet weak var ivGetCoin: UIImageView!
    @IBOutlet weak var ivPayCoin: UIImageView!
    @IBOutlet weak var btnConfirmSwap: UIButton!
    var isFrom = ""
    var gasfee = ""
    var swapQouteDetail: [Routers] = []
    var previewSwapDetail: PreviewSwap?
    var swappingFee = ""
    var outputAmount = ""
    var networkFee = ""
    weak var delegate: ConfirmSwap1Delegate?
    var paySymbol = ""
    var decimalsValue = 0
    lazy var viewModel: SwappingViewModel = {
        SwappingViewModel { _, message in
            DGProgressView.shared.hideLoader()
        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: ""))
        
        self.lblFromText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")
        self.lblQuoteText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.quots, comment: "")
        self.lblSwapperFeeText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swapperfee, comment: "")
        self.lblNetworkFeeText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.networkfee, comment: "")
        self.lblSlippageText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.maxslipage, comment: "")
        self.lblSwapperFeeText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swapperfee, comment: "")
        self.btnConfirmSwap.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirmswap, comment: ""), for: .normal)
        
        self.lblNetworkFee.font = AppFont.violetRegular(13.81).value
        self.lblNetworkFeeText.font = AppFont.violetRegular(13.81).value
        self.lblSlippage.font = AppFont.violetRegular(13.81).value
        self.lblSlippageText.font = AppFont.violetRegular(13.81).value
        self.lblQoute.font = AppFont.violetRegular(13.81).value
        self.lblFrom.font = AppFont.violetRegular(13.81).value
        self.lblFromText.font = AppFont.violetRegular(13.81).value
        self.lblQuoteText.font = AppFont.violetRegular(13.81).value
        self.lblSwapperFee.font = AppFont.violetRegular(13.81).value
        self.lblSwapperFeeText.font = AppFont.violetRegular(13.81).value
        self.lblPaySymbol.font = AppFont.regular(11).value
        self.lblGetSymbol.font = AppFont.regular(11).value
        self.lblCoinName.font = AppFont.regular(11).value
        self.lblPayCoinBalance.font = AppFont.regular(11).value
        self.lblPayCoinValue.font = AppFont.regular(11).value
        self.lblGetCoinValue.font = AppFont.regular(11).value
        self.lblGetCoinName.font = AppFont.regular(11).value
        self.lblType1.font = AppFont.regular(8.5).value
        self.lblType2.font = AppFont.regular(8.5).value
        self.lblGetCoinBalance.font = AppFont.regular(11).value
        
        // setSwapDetail
        setSwapDetail()
    }
    // setSwapDetail
    fileprivate func btcSwapDetails() {
        let payPrice = ((Double(previewSwapDetail?.payAmount ?? "") ?? 0.0) * (Double(previewSwapDetail?.payCoinDetail?.price ?? "") ?? 0.0))
        let payPriceValue =  WalletData.shared.formatDecimalString("\(payPrice)", decimalPlaces: 5)
        let payAmount = WalletData.shared.formatDecimalString("\(previewSwapDetail?.payAmount ?? "")", decimalPlaces: 4)
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
        self.viewFee.isHidden = true
        lblFrom.text = previewSwapDetail?.payCoinDetail?.chain?.walletAddress ?? ""
        self.viewQuote.isHidden = true
        DGProgressView.shared.hideLoader()
    }
    
    func setSwapDetail() {
        DGProgressView.shared.showLoader(to: view)
        if previewSwapDetail?.payCoinDetail?.chain?.coinType == CoinType.bitcoin {
            btcSwapDetails()
        } else {
            print("previewSwaperfee",self.swappingFee)
//        if isFrom == "rango" {
//            if  self.swappingFee == "0" || self.swappingFee == "" || self.swappingFee.isEmpty {
//                print("Swaperfee not showing")
//                self.viewSwapperFee.isHidden = true
//            } else {
//                
//                self.viewSwapperFee.isHidden = false
//            }
////            self.viewSwapperFee.isHidden = false
//        } else {
            self.viewSwapperFee.isHidden = true
//        }
            let payPrice = ((Double(previewSwapDetail?.payAmount ?? "") ?? 0.0) * (Double(previewSwapDetail?.payCoinDetail?.price ?? "") ?? 0.0))
            let payPriceValue =  WalletData.shared.formatDecimalString("\(payPrice)", decimalPlaces: 5)
            let payAmount = WalletData.shared.formatDecimalString("\(previewSwapDetail?.payAmount ?? "")", decimalPlaces: 10)
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
            if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {

//                // 1. Get required values
//                let chainName = previewSwapDetail?.payCoinDetail?.chain?.name ?? ""
//                let payCoinType = previewSwapDetail?.payCoinDetail?.type
//                let payChainSymbol = previewSwapDetail?.paySymbol
//                let specificChains = ["Base", "Arbitrum One", "OP Mainnet"]
//                print("chainName",chainName)
//                print("payCoinType",payCoinType)
//                print("payChainSymbol",payChainSymbol)
//                print("specificChains",specificChains)
//               
//                // 2. Filter tokens safely
//                let allCoin: [Token] = allToken.filter { token in
//                    guard token.address == "",
//                          token.type == payCoinType,
//                          token.symbol == payChainSymbol?.uppercased() else {
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
//                let allCoin = allToken.filter { $0.address == "" && $0.type == self.previewSwapDetail?.payCoinDetail?.type && $0.symbol == self.previewSwapDetail?.payCoinDetail?.chain?.symbol ?? "" }
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
                // 4. Get token amount
                let tokenAmount = Double(previewSwapDetail?.payAmount ?? "") ?? 0.0

                if self.isFrom == "rango" {
                    rangoSwap(selectedToekn: selectedToken)
                }
                else {
                // 5. Call gas fee function
                previewSwapDetail?.payCoinDetail?.callFunction.getGasFee(
                    previewSwapDetail?.payCoinDetail?.chain?.walletAddress,
                    tokenAmount: tokenAmount,
                    completion: { status, msg, gasPrice, gasLimit, nonce, data in

                        if status {
                            DGProgressView.shared.hideLoader()
                            self.gasfee = msg ?? ""
                            let gasFeeValue = self.gasfee
                            let convertedGas = UnitConverter.convertWeiToEther(gasFeeValue, self.previewSwapDetail?.payCoinDetail?.chain?.decimals ?? 0) ?? ""
                            let tokenPrice = Double(selectedToken.price ?? "") ?? 0.0
                            let gasPriceValue = (Double(convertedGas) ?? 0.0) * tokenPrice

//                            if self.isFrom == "rango" {
//                                let networkValue = ((Double(self.networkFee) ?? 0.0) * tokenPrice)
//                                if let originalNetworkFeeNumber = Double(self.networkFee) {
//                                    let formattedNetworkFee = WalletData.shared.formatDecimalString("\(originalNetworkFeeNumber)", decimalPlaces: 10)
//                                    let formattedNetworkValue = WalletData.shared.formatDecimalString("\(networkValue)", decimalPlaces: 2)
//
//                                    DispatchQueue.main.async {
//                                        self.lblNetworkFee.text = "\(formattedNetworkFee) \(selectedToken.symbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(formattedNetworkValue))"
//                                    }
//                                }
//                            } else {
                                if let gasDouble = Double(convertedGas) {
                                    let formattedGas = WalletData.shared.formatDecimalString("\(gasDouble)", decimalPlaces: 10)
                                    let formattedPrice = WalletData.shared.formatDecimalString("\(gasPriceValue)", decimalPlaces: 4)

                                    DispatchQueue.main.async {
                                        self.lblNetworkFee.text = "\(formattedGas) \(selectedToken.symbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(formattedPrice))"
                                    }
                                }
//                            }

                            // 6. Display Swapper Fee
//                            if let originalSwapNumber = Double(self.swappingFee) {
//                                let swapPrice = originalSwapNumber * tokenPrice
//                                let formattedSwapFee = WalletData.shared.formatDecimalString("\(originalSwapNumber)", decimalPlaces: 8)
//                                let formattedSwapPrice = WalletData.shared.formatDecimalString("\(swapPrice)", decimalPlaces: 3)
//
//                                DispatchQueue.main.async {
//                                    self.lblSwapperFee.text = "\(formattedSwapFee) \(selectedToken.symbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(formattedSwapPrice))"
//                                }
//                            }
                        } else {
                            DGProgressView.shared.hideLoader()
                        }
                        
                    })
                    }
                
            }

        
        lblFrom.text = previewSwapDetail?.payCoinDetail?.chain?.walletAddress ?? ""
        lblQoute.text = previewSwapDetail?.quote
        lblSlippage.text = "0.1%"
        
    }
        
    }
    
    func rangoSwap(selectedToekn:Token) {
        
        var decimaamountToTransfer = ""
        previewSwapDetail?.payCoinDetail?.callFunction.getDecimal(completion: { decimal in
            print("decimal",decimal ?? 0.0)
            decimaamountToTransfer = decimal ?? ""
            var amountToPay: BigInt = 0
            DispatchQueue.main.async { [self] in
                if let doubleValue = Double(decimaamountToTransfer) {
                    // Successfully converted the string to a double
                    print("Double value: \(doubleValue)")
                    amountToPay = UnitConverter.convertToWei(Double(previewSwapDetail?.payAmount ?? "") ?? 0.0, Double(doubleValue))
                } else {
                    // Conversion failed, handle the error or provide a default value
                    print("Failed to convert the string to a double")
                }
                let amount = "\(amountToPay)"
                viewModel.apiRangoSwapping(address: WalletData.shared.myWallet?.address ?? "", fromToken: (previewSwapDetail?.payCoinDetail)!, toToken:(previewSwapDetail?.getCoinDetail)!,  fromAmount: amount,fromWalletAddress:previewSwapDetail?.payCoinDetail?.chain?.walletAddress ?? "",toWalletAddress:previewSwapDetail?.getCoinDetail?.chain?.walletAddress ?? "") { status, swaperr, data in
                    if status {
                        do {
                            let jsonResponse = try JSONSerialization.data(withJSONObject: data ?? [:])
                            let swapData = try JSONDecoder().decode(RangoSwapingData.self, from: jsonResponse)
                            let tx = swapData.tx
                            _ = tx?.txTo ?? ""
                            _ = tx?.approveTo
                            _ = tx?.approveData ?? ""
                            _ = tx?.txData ?? ""
                            let firstItem = swapData.route
                            let routerResult = firstItem?.outputAmount
                            let errorCode = swapData.resultType
                            
                            if errorCode == "OK" {
                                var decimalAmount = ""
                                self.previewSwapDetail?.getCoinDetail?.callFunction.getDecimal(completion: { decimal in
                                    print("decimalValue",decimal ?? 0.0)
                                    decimalAmount = decimal ?? ""
                                    let number: Int64? = Int64(decimalAmount)
                                    let amountToGet = UnitConverter.convertWeiToEther(routerResult ?? "",Int(number ?? 0)) ?? ""
                                   
                                    if let fees = firstItem?.fee {
                                        // Calculate the sum of the "amount" values
                                        let sum = fees.reduce(Decimal(0)) { total, feeItem in
                                            var feesAmount: Decimal = 0
                                            
                                            if feeItem.expenseType == "FROM_SOURCE_WALLET" && feeItem.name == "Swapper Fee" {
                                                feesAmount = Decimal(string: feeItem.amount ?? "") ?? 0
                                                print("feeItem.amount1",feeItem.amount ?? "")
                                                if let tokenDecimals = feeItem.token?.decimals {
                                                    self.decimalsValue = tokenDecimals
                                                }
                                            } else {
                                                feesAmount = 0
                                            }
                                            return total + feesAmount
                                        }
                                        print("Sum of amounts: \(sum)")
                                        let swapperFees = UnitConverter.convertWeiToEther("\(sum )", Int(self.decimalsValue)) ?? ""
                                        print("swapperFee =", swapperFees)
                                        
                                        if  swapperFees == "0.0" || swapperFees == "0" || swapperFees.isEmpty {
                                                       print("Swaperfee not showing")
                                                       self.viewSwapperFee.isHidden = true
                                                   } else {
                                       
                                                       self.viewSwapperFee.isHidden = false
                                                   }
                                        let sum1 = fees.reduce(Decimal(0)) { networkfeeTotal ,feeItem in
                                            
                                            var networkFesAmount: Decimal = 0
                                            if feeItem.expenseType == "FROM_SOURCE_WALLET" && feeItem.name == "Network Fee" {
                                                networkFesAmount = Decimal(string: feeItem.amount ?? "") ?? 0
                                                print("feeItem.amount",feeItem.amount ?? "")
                                                
                                                if let tokenDecimals = feeItem.token?.decimals {
                                                    self.decimalsValue =    tokenDecimals
                                                }
                                            } else {
                                                networkFesAmount = 0
                                            }
                                            
                                            return networkfeeTotal + networkFesAmount
                                        }
                                        
                                        let networkFee =  UnitConverter.convertWeiToEther("\(sum1 )", Int(self.decimalsValue)) ?? ""
                                        self.networkFee = networkFee
                                        
                                        let formattedString = WalletData.shared.formatDecimalString("\(networkFee)", decimalPlaces: 10)
                                        print("networkFee",formattedString)
                                        let tokenPrice = Double(selectedToekn.price ?? "") ?? 0.0
                                        let gasPriceValue = (Double(formattedString) ?? 0.0) * tokenPrice
                                        let formattedPrice = WalletData.shared.formatDecimalString("\(gasPriceValue)", decimalPlaces: 5)

                                        DispatchQueue.main.async {
                                            self.lblNetworkFee.text = "\(formattedString) \(selectedToekn.symbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(formattedPrice))"
                                        }
                                        
                                        DGProgressView.shared.hideLoader()
                                                // ✅ Format swapper fee
                                                print("self.swapperFee", swapperFees)
                                        let formattedSwapperString = WalletData.shared.formatDecimalString("\(swapperFees)", decimalPlaces: 8)
                                        let gasSwapPriceValue = (Double(formattedSwapperString) ?? 0.0) * tokenPrice
                                        let formattedSwapPrice = WalletData.shared.formatDecimalString("\(gasSwapPriceValue)", decimalPlaces: 5)
                                                DispatchQueue.main.async {
                                                    self.lblSwapperFee.text = "\(formattedSwapperString) \(selectedToekn.symbol ?? "")(\(WalletData.shared.primaryCurrency?.sign ?? "")\(formattedSwapPrice))"
                                                }
                                    }
                                })
                            }
                        } catch(let error) {
                            print(error)
                           // self.btnSwap.HideLoader()
                            DGProgressView.shared.hideLoader()
                        }
                        
                        
                    } else {
                        DispatchQueue.main.async {
                            self.showToast(message: swaperr, font: .systemFont(ofSize: 15))
//                            self.btnSwap.HideLoader()
                            DGProgressView.shared.hideLoader()
                        }
                    }
                    
                }
            }
        })
    }
    @IBAction func btnConfirmSwapAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.dismiss(animated: true) {
            self.delegate?.confirmSwap1(isFrom: self.isFrom, swappingFee: self.swappingFee)

        }
    }
}

//
//  SwapViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit

class  SwapViewController: UIViewController, Reusable {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnSwapcoins: UIButton!
    @IBOutlet weak var btnSwap: GradientButton!
    
    @IBOutlet weak var btnMax: UIButton!
    @IBOutlet weak var viewProvider: UIView!
    /// Custome progress view outlets
    @IBOutlet var viewProgress: [UIView]!
    @IBOutlet weak var lblSuccessFail: UILabel!
    @IBOutlet weak var lblSwapping: UILabel!
    @IBOutlet weak var lblInitiate: UILabel!
    /// Pay Coin Outlets
    @IBOutlet weak var ivPayCoin: UIImageView!
    @IBOutlet weak var lblCoinName: UILabel!
    @IBOutlet weak var lblPayCoinBalance: UILabel!
    @IBOutlet weak var txtPay: LoadingTextField!
    /// Get Coin Outlets
    @IBOutlet weak var ivGetCoin: UIImageView!
    @IBOutlet weak var lblGetCoinName: UILabel!
    @IBOutlet weak var lblGetCoinBalance: UILabel!
    @IBOutlet weak var txtGet: LoadingTextField!
    @IBOutlet weak var lblEstimateAmount: UILabel!
    @IBOutlet weak var lblGetMoney: UILabel!
    @IBOutlet weak var lblPayMoney: UILabel!
    @IBOutlet weak var lblType1: DesignableLabel!
    @IBOutlet weak var lblType2: DesignableLabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblBalance2: UILabel!
    @IBOutlet weak var lblYouPay: UILabel!
    @IBOutlet weak var lblYouGet: UILabel!
    @IBOutlet weak var lblViewQuote: UILabel!
    @IBOutlet weak var lblbestQuotTitle: UILabel!
    var maxIndex = -1
    var pairData: [ExchangePairsData] = []
    var payCoinDetail: Token?
    var getCoinDetail: Token?
    var tokensList: [Token]? = []
    var swapQouteDetail: [Routers] = []
    var rangoSwapQouteDetail: Route?
    var transactionID: String? = ""
 //   var toNetwork = ["eth"]
    var toNetwork = ["eth","bsc","matic","btc"]
    weak var updatebalDelegate: RefreshDataDelegate?
    var isOkx = false
    var allProviders = [SwapProviders]()
    var provider: SwapCrypto.SwapCryptoDomain = .changeNow()
    var apiCount = 0
    var bestPrice = 0.0
    var gasPrice = ""
    var gasLimit = ""
    var bestQuote = ""
    var providerName = ""
    var supportedProviders = [SwapCrypto.SwapCryptoDomain]()
    var primaryCurrency: Currencies?
    var swapperFee = ""
    var index = 0
    var fromCurrency,fromNetwork: String?
    var encryptedKey = ""
    var decryptedKey = ""
 
    lazy var viewModel: SwappingViewModel = {
        SwappingViewModel { _, message in
            DGProgressView.shared.hideLoader()
//            self.setOkxToken()
        }
    }()
    lazy var registerUserViewModel: RegisterUserViewModel = {
        RegisterUserViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
        }
    }()
    lazy var sendViewModel: SendBTCCoinViewModel = {
        SendBTCCoinViewModel { _ , _ in
        }
    }()
  
    fileprivate func uiSetUp() {
        self.btnSwap.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.previewswap, comment: ""), for: .normal)
        self.lblInitiate.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.initiated, comment: "")
        self.lblSwapping.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swapping, comment: "")
        self.lblSuccessFail.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.success, comment: "")
        self.lblBalance.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.balance, comment: "")
        self.lblBalance2.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.balance, comment: "")
        self.lblYouGet.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.youget, comment: "")
        self.lblYouPay.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.youPay, comment: "")
        self.btnMax.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.max, comment: ""), for: .normal)
        self.lblbestQuotTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.usingBestQuot, comment: "")
        self.lblViewQuote.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.viewQuots, comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPay.delegate = self
        self.supportedProviders = (self.payCoinDetail?.chain!.swapProviders)!
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: ""))
        uiSetUp()
        let privateKey = WalletData.shared.walletBTC?.privateKey ?? ""
       // let privateKey = "cRxJ9jx3cUBGpY9teQPAJ541Cp4LJscY5agNgxTPv4PfZCeN4SJB"
        let encryptionManager = EncryptionManager()
        if let encrypted = encryptionManager.encrypt(privateKey: privateKey) {
            print("Encrypted: \(encrypted)")
            self.encryptedKey = encrypted
            if let decrypted = encryptionManager.decrypt(encryptedPrivateKey: encrypted) {
                print("Decrypted: \(decrypted)")
                self.decryptedKey =  decrypted
            }
        }
        /// Retrieve token list from the database
        self.tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
        /// Provider Action
        viewProvider.addTapGesture(target: self, action: #selector(providerTapped))
   //     getBestPriceFromAllProvider(swapProviders: supportedProviders)
        viewProvider.isHidden = true
        if payCoinDetail?.type != Chain.oKC.tokenStandard {
            getExchangePairs()
        } else {
            /// Filter tokens list for KIP20 type and exclude the selected payCoinDetail
            tokensList = tokensList?.filter { $0.type == Chain.oKC.tokenStandard && $0 != payCoinDetail}
            if let availableTokens = tokensList, !availableTokens.isEmpty {
                self.getCoinDetail = availableTokens[0]
                self.setCoinDetail()
            }
        }
    }
    /// Will open provider list
    @objc func providerTapped(_ sender: UITapGestureRecognizer) {
        let viewToNavigate = SwapProvidersViewController()
        viewToNavigate.coinDetail = self.payCoinDetail
        var sortedProviders = allProviders.sorted(by: { provider1, provider2 in
            let price1 = Double(provider1.bestPrice ?? "") ?? 0.0
            let price2 = Double(provider2.bestPrice ?? "") ?? 0.0
            return price1 > price2
        })
        sortedProviders = sortedProviders.filter { (Double($0.bestPrice ?? "") ?? 0.0) > 0 }
        viewToNavigate.arrProviderList = sortedProviders
        viewToNavigate.bestPrice  = self.bestPrice
        viewToNavigate.fromCurruncySymbol = self.getCoinDetail?.symbol
        viewToNavigate.delegate = self
        viewToNavigate.swapperFee = self.swapperFee
        viewToNavigate.modalTransitionStyle = .crossDissolve
        viewToNavigate.modalPresentationStyle = .overFullScreen
        self.present(viewToNavigate, animated: true)
    }
    
    /// getBestPriceFromAllProvider
     func getBestPriceFromAllProvider(swapProviders: [SwapCrypto.SwapCryptoDomain]) {
       
        /// Update Provider name with the name from the provider
         viewProvider.isHidden = true
         let pay = Double(self.txtPay.text ?? "") ?? 0.0
         let payPrice = (Double(self.payCoinDetail?.price ?? "") ?? 0.0)
         let payableAmount = pay * payPrice
         if self.txtPay.text == "" {
             self.lblPayMoney.text = ""
         } else {
             let value = payableAmount
             let formattedValue = WalletData.shared.formatDecimalString("\(value)", decimalPlaces: 4)
             self.lblPayMoney.text = "\(WalletData.shared.primaryCurrency?.sign ?? "") \(formattedValue)"
         }
         txtGet.showLoading()
         allProviders.removeAll()
                 for idx in 0..<swapProviders.count {
                if swapProviders[idx] == .okx() {
                    allProviders.append(SwapProviders(name: StringConstants.okx, bestPrice: ""))

                } else if swapProviders[idx] == .changeNow() {
                    allProviders.append(SwapProviders(name: StringConstants.changeNow, bestPrice: ""))

                } else if swapProviders[idx] == .rango() {
                         allProviders.append(SwapProviders(name: StringConstants.rangoSwap, bestPrice: ""))
           }
        }
        if allProviders.count != 0 {
            callAPIsAfterTaskCompletion()
        }
    
    }
    func getBestPriceFromAllBestPrices() {
       print("allProviders",allProviders)
        if let highestPriceProvider = allProviders.max(by: { (Double($0.bestPrice ?? "") ?? 0.0) < Double($1.bestPrice ?? "") ?? 0.0 }) {
            if Double(highestPriceProvider.bestPrice ?? "") ?? 0.0 <= 0 {
                self.txtGet.hideLoading()
                viewProvider.isHidden = true
            } else {
                providerName = highestPriceProvider.name ?? ""
                let formattedPrice = WalletData.shared.formatDecimalString("\(highestPriceProvider.bestPrice ?? "")", decimalPlaces: 10)
                DispatchQueue.main.async {
                    self.viewProvider.isHidden = false
                    self.txtGet.hideLoading()
                    self.txtGet.text = formattedPrice
                    self.bestPrice = Double(formattedPrice) ?? 0.0
                    self.bestQuote = formattedPrice
                    let get = Double(self.txtGet.text ?? "") ?? 0.0
                    let getPrice = (Double(self.getCoinDetail?.price ?? "") ?? 0.0)
                    let getAmount = get * getPrice
                    if self.txtGet.text == "" {
                        self.lblGetMoney.text = ""
                    } else if (Double(self.txtGet.text ?? "") ?? 0.0) == 0.0 {
                        self.showToast(message:"Provider not found!", font: AppFont.regular(15).value)
                     } else {
                        let value = getAmount
                        let formattedValue = WalletData.shared.formatDecimalString("\(value)", decimalPlaces: 4)
                        self.lblGetMoney.text = "≈\(WalletData.shared.primaryCurrency?.sign ?? "") \(formattedValue)"
                    }
                    let estimatePrice = (Double(formattedPrice) ?? 0.0) / (Double(self.txtPay.text ?? "") ?? 0.0)
                    let estimatePriceTruncatedValue = WalletData.shared.formatDecimalString("\(estimatePrice)", decimalPlaces: 8)
                    self.lblEstimateAmount.text = "1 \(self.payCoinDetail?.symbol ?? "") ≈ \(estimatePriceTruncatedValue) \(self.getCoinDetail?.symbol ?? "")"
                }
            }
        } else {
            viewProvider.isHidden = true
            self.txtGet.hideLoading()
            showToast(message:"Provider not found!", font: AppFont.regular(15).value)
            print("No providers found")
        }
    }
    // set okx token if token is not swap in change now
    func setOkxToken() {
        isOkx = true
        let tokensList = tokensList?.filter { $0.type == payCoinDetail?.type }
        
        if self.tokensList?.count != 0 {
            getCoinDetail = tokensList?.first
            setCoinDetail()
        }
        
    }
    /// getExchangePairs
    private func getExchangePairs() {
        DGProgressView.shared.showLoader(to: self.view)
        var fromNetwork: String? {
            switch payCoinDetail?.chain {
                
            case .ethereum :
                return "eth"
            case .binanceSmartChain :
                return "bsc"
            case .oKC:
                return "okc"
            case .polygon:
                return "matic"
            case .bitcoin:
                return "btc"
            case .none:
                return ""
            }
        }
        self.getExchangePairsToken(fromCurrency: payCoinDetail?.symbol?.lowercased() ?? "", fromNetwork: fromNetwork ?? "", toNetwork: toNetwork[0])
    }
    
    // setCoinDetail
    func setCoinDetail() {
        DispatchQueue.main.async {
            
            /// Pay coin detail
            self.ivPayCoin.sd_setImage(with:  URL(string: self.payCoinDetail?.logoURI ?? ""))
            self.lblCoinName.text = self.payCoinDetail?.symbol
            self.lblType1.text = self.payCoinDetail?.type
            let paybalance = Double(self.payCoinDetail?.balance ?? "") ?? 0.0
            self.lblPayCoinBalance.text = "\( WalletData.shared.formatDecimalString("\(paybalance)", decimalPlaces: 8))"
            self.txtPay.text = ""
            let pay = Double(self.txtPay.text ?? "") ?? 0.0
            let payPrice = (Double(self.payCoinDetail?.price ?? "") ?? 0.0)
            let payableAmount = pay * payPrice
            let value = payableAmount
            let formattedValue = WalletData.shared.formatDecimalString("\(value)", decimalPlaces: 2)
            if self.txtPay.text == "" {
                self.lblPayMoney.text = ""
            } else {
                self.lblPayMoney.text = "\(WalletData.shared.primaryCurrency?.sign ?? "") \(formattedValue)"
            }
            /// Get coin detail
            self.ivGetCoin.sd_setImage(with:  URL(string: self.getCoinDetail?.logoURI ?? ""))
            self.lblGetCoinName.text = self.getCoinDetail?.symbol
            let getbalance = Double(self.getCoinDetail?.balance ?? "") ?? 0.0
            let formattedString1 = WalletData.shared.formatDecimalString("\(getbalance)", decimalPlaces: 8)
            self.lblGetCoinBalance.text = "\(formattedString1)"
            self.lblType2.text = self.getCoinDetail?.type
            self.txtGet.text = ""
            let get = Double(self.txtGet.text ?? "") ?? 0.0
            let getPrice = (Double(self.getCoinDetail?.price ?? "") ?? 0.0)
            let getAmount = get * getPrice
            if self.txtGet.text == "" {
                self.lblGetMoney.text = ""
            } else if (Double(self.txtGet.text ?? "") ?? 0.0) == 0.0 {
                self.showToast(message:"Provider not found!", font: AppFont.regular(15).value)
             } else {
                let value = getAmount
                let formattedValue = WalletData.shared.formatDecimalString("\(value)", decimalPlaces: 2)
                self.lblGetMoney.text = "≈\(WalletData.shared.primaryCurrency?.sign ?? "") \(formattedValue)"
            }
            // if (Double(self.payCoinDetail?.price ?? "") ?? 0.0) > (Double(self.getCoinDetail?.price ?? "") ?? 0.0) {
                let estimatePrice = (Double(self.payCoinDetail?.price ?? "") ?? 0.0) / (Double(self.getCoinDetail?.price ?? "") ?? 0.0)
            let estimatePriceStringValue = String(estimatePrice)
            
            let estimateValue = WalletData.shared.formatDecimalString("\(estimatePriceStringValue)", decimalPlaces: 8)
            let estimatePriceTruncatedValue = estimateValue
                self.lblEstimateAmount.text = "1 \(self.payCoinDetail?.symbol ?? "") ≈ \(estimatePriceTruncatedValue) \(self.getCoinDetail?.symbol ?? "")"
            for views in self.viewProgress {
                views.backgroundColor = .c75769D
            }
            self.lblSuccessFail.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.success, comment: "")
            self.lblSuccessFail.textColor = .c75769D
            self.checkChains()
        }
    }
    @IBAction func actionSwapCoins(_ sender: Any) {
        
        UIView.animate(withDuration: 0.6, animations: {
            self.btnSwapcoins.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: { _ in
            UIView.animate(withDuration: 0.6) {
                self.btnSwapcoins.transform = CGAffineTransform.identity
            }
        })
        
        let payableCoin = getCoinDetail
        let getableCoin = payCoinDetail
        getCoinDetail = getableCoin
        payCoinDetail = payableCoin
        setCoinDetail()
        
    }
    
    private func checkChains() {
        btnSwap.setTitle( LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.previewswap, comment: ""), for: .normal)
    }
    
    @IBAction func actionSwap(_ sender: Any) {
        self.registerUserViewModel.setWalletActiveAPI(walletAddress: WalletData.shared.myWallet?.address ?? "") { resStatus, message in
           // if resStatus == 1 {
                print(message)
            //}
        }
        if payCoinDetail?.chain?.coinType == CoinType.bitcoin {
            if txtPay.text ?? "" == "" {
                showToast(message: ToastMessages.payAmountRequired, font: AppFont.regular(15).value)
                return
            }
            if (Double(txtPay.text ?? "") ?? 0.0) >= Double(payCoinDetail?.balance ?? "") ?? 0.0 {
                showToast(message: ToastMessages.lowBalance(payCoinDetail?.symbol ?? ""), font: AppFont.regular(15).value)
                return
            }
            if (Double(txtGet.text ?? "") ?? 0.0) == 0.0 {
                /// showToast(message: ToastMessages.lowBalance(getCoinDetail?.symbol ?? ""), font: AppFont.regular(15).value)
                showToast(message:"Provider not found!", font: AppFont.regular(15).value)
                return
            }
            if (Double(txtPay.text ?? "") ?? 0.0) > 0.0 {
                
                let formattedPrice = WalletData.shared.formatDecimalString("\(self.bestQuote)", decimalPlaces: 10)
                switch provider {
                case .changeNow :
                    let swapPreviewVC = PreviewSwap1ViewController()
                    let previewSwapDetail = PreviewSwap(payCoinDetail: self.payCoinDetail,getCoinDetail: self.getCoinDetail,payAmount: txtPay.text ?? "",getAmount: formattedPrice, quote: self.lblEstimateAmount.text ?? "")
                    swapPreviewVC.previewSwapDetail = previewSwapDetail
                    swapPreviewVC.delegate = self
                    swapPreviewVC.isFrom = "changeNow"
                    swapPreviewVC.swappingFee = ""
                    self.navigationController?.present(swapPreviewVC, animated: true)
                case .okx:
                    break
                case .rango:
                    break
                }
            } else {
                self.showToast(message: ToastMessages.insufficientAmount, font: AppFont.regular(15).value)
            }

        } else {
        if txtPay.text ?? "" == "" {
            showToast(message: ToastMessages.payAmountRequired, font: AppFont.regular(15).value)
            return
        }
        if (Double(txtPay.text ?? "") ?? 0.0) >= Double(payCoinDetail?.balance ?? "") ?? 0.0 {
            showToast(message: ToastMessages.lowBalance(payCoinDetail?.symbol ?? ""), font: AppFont.regular(15).value)
            return
        }
        if (Double(txtGet.text ?? "") ?? 0.0) == 0.0 {
            /// showToast(message: ToastMessages.lowBalance(getCoinDetail?.symbol ?? ""), font: AppFont.regular(15).value)
            showToast(message:"Provider not found!", font: AppFont.regular(15).value)
            return
        }
        if (Double(txtPay.text ?? "") ?? 0.0) > 0.0 {
            
            let formattedPrice = WalletData.shared.formatDecimalString("\(self.bestQuote)", decimalPlaces: 10)
           swapperFeeValidation(formattedPrice: formattedPrice)
           
        } else {
            self.showToast(message: ToastMessages.insufficientAmount, font: AppFont.regular(15).value)
        }
    }// else
    }
    @IBAction func btnSelectGetTokenAction(_ sender: Any) {
        let coinListVC = CoinListViewController()
        coinListVC.isPayCoin = false
        coinListVC.isOkx = self.isOkx
        coinListVC.fromCurrency = payCoinDetail?.symbol?.lowercased()
        var fromNetwork: String? {
            switch payCoinDetail?.chain {
                
            case .ethereum :
                return "eth"
            case .binanceSmartChain :
                return "bsc"
            case .oKC:
                return "okc"
            case .polygon:
                return "matic"
            case .bitcoin:
                return "btc"
            case .none:
                return ""
           
            }
        }
        coinListVC.fromNetwork = fromNetwork
        coinListVC.payCoinDetail = self.payCoinDetail
        coinListVC.swapDelegate = self
        self.navigationController?.present(coinListVC, animated: true)
        
    }
    
    @IBAction func btnSelectPayTokenAction(_ sender: Any) {
        let coinListVC = CoinListViewController()
        coinListVC.isPayCoin = true
        coinListVC.isOkx = self.isOkx
        coinListVC.swapDelegate = self
        self.navigationController?.present(coinListVC, animated: true)
    }
    
    @IBAction func btnMaxAction(_ sender: UIButton) {
        let paybalance = Double(self.payCoinDetail?.balance ?? "") ?? 0.0
        self.txtPay.text = "\( WalletData.shared.formatDecimalString("\(paybalance)", decimalPlaces: 15))"
        textFieldDidChangeSelection(self.txtPay)
    }
}

// MARK: SwappingCoinDelegate
extension SwapViewController: SwappingCoinDelegate {
    
    func selectPayCoin(_ coinDetail: Token?) {
        guard coinDetail != getCoinDetail else {
            showToast(message: ToastMessages.samecoinError, font: AppFont.regular(15).value)
            return
        }
        
        /// setup for kip20 tokens
        if coinDetail?.type == Chain.oKC.tokenStandard {
            
            // Retrieve token list from the database
            self.tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
            
            // Filter tokens list for KIP20 type and exclude the selected payCoinDetail
            self.tokensList = tokensList?.filter { $0.type == Chain.oKC.tokenStandard && $0 != payCoinDetail}
            
            if let availableTokens = tokensList, !availableTokens.isEmpty {
                // Set the getCoinDetail based on available tokens
                if availableTokens.first == coinDetail {
                    self.getCoinDetail = availableTokens.last
                } else {
                    self.getCoinDetail = availableTokens.first
                }
                self.setCoinDetail()
            }
            
        }
        
        self.payCoinDetail = coinDetail
        setCoinDetail()
    }
    
    func selectGetCoin(_ coinDetail: Token?) {
        guard coinDetail != payCoinDetail else {
            showToast(message: ToastMessages.samecoinError, font: AppFont.regular(15).value)
            return
        }
        
        self.getCoinDetail = coinDetail
        setCoinDetail()
    }
}

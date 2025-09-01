//
//  SwapViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
struct QuickSwapData {
    var coinImage :UIImage
    var coinName : String
}
// swiftlint:disable type_body_length
class  SwapViewController: UIViewController, Reusable {
    @IBOutlet weak var lblHalf: UILabel!
    
    @IBOutlet weak var btnGet: UIButton!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var lblAll: UILabel!
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var ivViewQuote: UIImageView!
    @IBOutlet weak var lblBestPriceTitle: UILabel!
    @IBOutlet weak var lblPaySymbol: UILabel!
    @IBOutlet weak var lblGetSymbol: UILabel!
    @IBOutlet weak var lblCustomSwap: UILabel!
    @IBOutlet weak var clvQuickSwap: UICollectionView!
    @IBOutlet weak var lblChooseProvider: UILabel!
    @IBOutlet weak var lblQuickSwap: UILabel!
    @IBOutlet weak var lblProviderSwapperFee: UILabel!
    @IBOutlet weak var lblProviderBestPrice: UILabel!
    @IBOutlet weak var ivProvider: UIImageView!
    
    @IBOutlet weak var lblBestProvider: UILabel!
    
    @IBOutlet weak var viewFindProvider: UIView!
    @IBOutlet weak var lblFindProvider: UILabel!
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
    var cachedSwapperFee = ""
    var maxIndex = -1
    var pairData: [ExchangePairsData] = []
    var payCoinDetail: Token?
    var getCoinDetail: Token?
    var tokensList: [Token]? = []
    var swapQouteDetail: [Routers] = []
    var rangoSwapQouteDetail: Route?
    var rangoSwapExchangeDetail : Routes?
    var amountToGet = ""
    var transactionID: String? = ""
    var toNetwork = ["eth","bsc","pol","btc"]
    weak var updatebalDelegate: RefreshDataDelegate?
    var isOkx = false
    var allProviders = [SwapProviders]()
    var provider = ""
    var apiCount = 0
    var bestPrice = 0.0
    var gasPrice = ""
    var gasLimit = ""
    var bestQuote = ""
    var providerName = ""
    var primaryCurrency: Currencies?
    var swapperFee = ""
    var newSwapperFee = ""
    var networkFee = ""
    var index = 0
    var fromCurrency,fromNetwork: String?
    var encryptedKey = ""
    var decryptedKey = ""
    var decimalsValue = 0
    var isFrom = ""
    var walletAddress = ""
    var transHex = ""
    var requestId = "" 
    var swapQuoteArr = [SwapMeargedDataList]()
    var providers = [SwapMeargedDataList]()
    var okSwapQouteDetails: RouterResults?
    var rangoSwapQouteDetails: SwapRoutes?
    var providerImage = ""
    var quickSwapDataValueArr  = [QuickSwapData]()
    var primaryWallet: Wallets?
    var payInAddress = ""
    var id = ""
    var message = ""
    var status = ""
    var payCoinSymbol = ""
    var getCoinSymbol = ""
    var quickSwapPairList: [(Token?, Token?)] = []
    var trendingTokenPairs: [(String, String)] = [
           ("ETH", "BTC"),
           ("ETH", "BNB"),
           ("BNB", "POL"),
           ("POL", "AVAX"),
           ("ETH", "POL")
       ]
    var enabledTokenList: [Token] = []
    lazy var viewModel: SwappingViewModel = {
        SwappingViewModel { _, message in
            DGProgressView.shared.hideLoader()
          
        }
    }()
    lazy var registerUserViewModel: RegisterUserViewModel = {
        RegisterUserViewModel { _ ,message in
          //  self.showToast(message: message, font: .systemFont(ofSize: 15))
        }
    }()
    lazy var sendViewModel: SendBTCCoinViewModel = {
        SendBTCCoinViewModel { _ , _ in
        }
    }()
    // Method encapsulating the QuickSwap logic
    func quickSwapData() {
        // Step 1: Retrieve token data from database
        self.tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
        var allWalletTokens = DatabaseHelper.shared.retrieveData("WalletTokens") as? [WalletTokens]
        
        allWalletTokens = allWalletTokens?.filter { $0.wallet_id == self.primaryWallet?.wallet_id }
        
        enabledTokenList = tokensList?.filter { ($0.address?.isEmpty ?? true) && ($0.isEnabled )} ?? []
       // print("Filtered Enabled Tokens: ", enabledTokenList.map { $0.symbol ?? "Unknown" })
        
        // Step 2: Generate the quick swap pairs from the trendingTokenPairs
        quickSwapPairList = generateQuickSwapPairs(from: trendingTokenPairs, in: enabledTokenList)
        
        // Step 3: Refresh the collection view with new data
         clvQuickSwap.reloadData()
    }

    func generateQuickSwapPairs(from tokenPairs: [(String, String)], in tokenList: [Token]) -> [(Token, Token)] {
        var swapPairs: [(Token, Token)] = []
        
        for pair in tokenPairs {
            print("Searching for pair: \(pair.0) and \(pair.1)")
            
            let token1 = tokenList.first {
                $0.symbol?.caseInsensitiveCompare(pair.0) == .orderedSame &&
                ($0.symbol != "ETH" || ($0.type == "ERC20" && $0.tokenId != "optimism")) // Ensure ETH is ERC20 & not OpMainNet
            }
            
            let token2 = tokenList.first {
                $0.symbol?.caseInsensitiveCompare(pair.1) == .orderedSame &&
                ($0.symbol != "ETH" || ($0.type == "ERC20" && $0.tokenId != "optimism")) // Same check for ETH
            }
            
            if let token1 = token1, let token2 = token2 {
                swapPairs.append((token1, token2))
                print(" Found Pair: \(token1.symbol ?? "Unknown") - \(token2.symbol ?? "Unknown")")
            } else {
                print(" Pair Not Found: \(pair.0) - \(pair.1)")
            }
        }
        
        return swapPairs
    }

    fileprivate func retrieveTokenList() {
        /// Retrieve token list from the database
      
        self.tokensList = (DatabaseHelper.shared.retrieveData("Token") as? [Token])?
            .filter { token in
                token.tokenId != "PLT".lowercased() &&  // Exclude PLT token
                token.address != "0x0000000000000000000000000000000000001010" && // Exclude specific address
                token.symbol != "BNRY"
            }
        let allWalletTokens = (DatabaseHelper.shared.retrieveData("WalletTokens") as? [WalletTokens] ?? [])
            .filter { $0.wallet_id == self.primaryWallet?.wallet_id }
        var filteredTokens: [Token] = []
        self.tokensList?.forEach { token in
            // Exclude unwanted tokens
            guard token.address != "0x0000000000000000000000000000000000001010",
                  token.symbol?.uppercased() != "BNRY"
            else {
                return
            }

           filteredTokens.append(token)
           // print("filteredTokens",filteredTokens)
        }

        // Final sorting: Prioritize "PLT" first, then sort by balance
        var finalTokens = filteredTokens
        finalTokens.sort {
            if $0.tokenId?.lowercased() == "plt" { return true }
            if $1.tokenId?.lowercased() == "plt" { return false }
            return (Double($0.balance ?? "0") ?? 0) > (Double($1.balance ?? "0") ?? 0)
        }
        // Store results and update UI
        self.tokensList = finalTokens
       // print("tokensList",tokensList)
    }
    
    fileprivate func tokenListSetUp() {
        if payCoinDetail?.type == Chain.oKC.tokenStandard {
            tokensList = tokensList?.filter { $0.type == Chain.oKC.tokenStandard && $0 != payCoinDetail }

            if let availableTokens = tokensList, !availableTokens.isEmpty {
                if availableTokens.count > 1 && availableTokens[0] == payCoinDetail {
                    self.getCoinDetail = availableTokens[1]
                } else {
                    self.getCoinDetail = availableTokens[0]
                }
                self.setCoinDetail()
            }
        } else {
            tokensList = tokensList?.filter { $0 != payCoinDetail }

            if let availableTokens = tokensList, !availableTokens.isEmpty {
                if availableTokens.count > 1 && availableTokens[0] == payCoinDetail {
                    self.getCoinDetail = availableTokens[1]
                } else {
                    self.getCoinDetail = availableTokens[0]
                }
               // print(" self.getCoinDetail",self.getCoinDetail)
                self.setCoinDetail()
            }
        }
    }

    
    fileprivate func tapGestureActions() {
        
        lblAll.addTapGesture {
            HapticFeedback.generate(.light)
            let paybalance = self.payCoinDetail?.balance?.asDouble
            print("✅ Converted:", paybalance)
            if paybalance == 0.0 {
                self.txtPay.text = "0"
                self.txtGet.text = ""
                self.lblGetMoney.text = ""
                self.lblPayMoney.text = ""
                self.showToast(message:LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowBalanceError, comment: "") , font: AppFont.regular(12).value)
            } else {
                self.txtPay.text = "\( WalletData.shared.formatDecimalString("\(paybalance ?? 0.0)", decimalPlaces: 15))"
                self.textFieldDidChangeSelection(self.txtPay)
            }
        }
        lblHalf.addTapGesture {
            HapticFeedback.generate(.light)
            let paybalance = self.payCoinDetail?.balance?.asDouble
            print("✅ Converted:", paybalance)
//            let paybalance = Double(self.payCoinDetail?.balance ?? "") ?? 0.0
            if paybalance == 0.0 {
                self.txtPay.text = "0"
                self.txtGet.text = ""
                self.lblGetMoney.text = ""
                self.lblPayMoney.text = ""
                self.showToast(message:LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.lowBalanceError, comment: "") , font: AppFont.regular(12).value)
            } else {
                let halfBalance = (paybalance ?? 0.0) / 2
                self.txtPay.text = "\( WalletData.shared.formatDecimalString("\(halfBalance)", decimalPlaces: 15))"
                self.textFieldDidChangeSelection(self.txtPay)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPay.delegate = self
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: ""))
        let privateKey = WalletData.shared.walletBTC?.privateKey ?? ""
        let encryptionManager = EncryptionManager()
        if let encrypted = encryptionManager.encrypt(privateKey: privateKey) {
            print("Encrypted: \(encrypted)")
            self.encryptedKey = encrypted
            if let decrypted = encryptionManager.decrypt(encryptedPrivateKey: encrypted) {
                print("Decrypted: \(decrypted)")
                self.decryptedKey =  decrypted
            }
        }
        if primaryWallet == nil {
            let allWallet = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
            primaryWallet = allWallet?.first(where: { $0.isPrimary })
        }
        quickSwapData()
        uiSetUp()
        loadNibs()
        retrieveTokenList()
        tapGestureActions()
        tokenListSetUp()
        
    }
    func loadNibs() {
        clvQuickSwap.register(QuickSwapViewCell.nib, forCellWithReuseIdentifier: QuickSwapViewCell.reuseIdentifier)
        clvQuickSwap.delegate = self
        clvQuickSwap.dataSource = self

    }
    /// Will open provider list
    @objc func providerTapped(_ sender: UITapGestureRecognizer) {
        HapticFeedback.generate(.light)
        let viewToNavigate = SwapProvidersViewController()
        viewToNavigate.coinDetail = self.payCoinDetail
        viewToNavigate.getCoinDetail = self.getCoinDetail
        var sortedProviders = self.swapQuoteArr.sorted(by: { provider1, provider2 in
            let price1 = Double(provider1.quoteAmount ?? "") ?? 0.0
            let price2 = Double(provider2.quoteAmount ?? "") ?? 0.0
            return price1 > price2
        })
        sortedProviders = sortedProviders.filter { (Double($0.quoteAmount ?? "") ?? 0.0) > 0 }
        viewToNavigate.swapArrProviderList = sortedProviders
        viewToNavigate.bestPrice  = self.bestPrice
        viewToNavigate.fromCurruncySymbol = self.getCoinDetail?.symbol
        viewToNavigate.delegate = self
        viewToNavigate.swapperFee = self.swapperFee
        viewToNavigate.providerImage = self.providerImage
        viewToNavigate.providerName = self.providerName
        viewToNavigate.modalTransitionStyle = .crossDissolve
        viewToNavigate.modalPresentationStyle = .overFullScreen
        self.present(viewToNavigate, animated: true)
    }
    
    func getBestPriceFromAllBestPrices() {
        // Filter out any providers with a missing or invalid quoteAmount
        let validQuotes = self.swapQuoteArr.filter {
                guard let quoteAmountString = $0.quoteAmount, let quoteAmount = Double(quoteAmountString) else {
                    return false
                }
                return quoteAmount > 0
            }

            // Check if there are any valid quotes
            guard !validQuotes.isEmpty else {
                self.btnGet.isUserInteractionEnabled = true
                self.btnPay.isUserInteractionEnabled = true
                self.lblHalf.isUserInteractionEnabled = true
                self.lblAll.isUserInteractionEnabled = true
                self.btnSwapcoins.isUserInteractionEnabled = true
                self.txtGet.hideLoading()
                self.lblFindProvider.text = "Provider not found!"
                self.viewProvider.isHidden = true
                self.lblChooseProvider.isHidden = true
                return
            }

        // Find the provider with the highest quoteAmount
        let highestPriceProvider = validQuotes.max {
            (Double($0.quoteAmount ?? "") ?? 0.0) < (Double($1.quoteAmount ?? "") ?? 0.0)
        }

        DispatchQueue.main.async {
            self.providerName = highestPriceProvider?.providerName ?? ""
            var formattedPrice = ""

            if self.providerName == "rangoexchange" {
                
                let semaphore = DispatchSemaphore(value: 0)
                self.getCoinDetail?.callFunction.getDecimal(completion: { decimal in
                    let decimalAmount = decimal ?? ""
                    let number: Int64? = Int64(decimalAmount)
                    let amountToGet = UnitConverter.convertWeiToEther(highestPriceProvider?.quoteAmount ?? "", Int(number ?? 0)) ?? ""
                    formattedPrice = WalletData.shared.formatDecimalString("\(amountToGet)", decimalPlaces: 12)
                    semaphore.signal()
                })
                semaphore.wait()
            } else {
                formattedPrice = WalletData.shared.formatDecimalString("\(highestPriceProvider?.quoteAmount ?? "")", decimalPlaces: 12)
            }
            self.btnGet.isUserInteractionEnabled = true
            self.btnPay.isUserInteractionEnabled = true
            self.lblHalf.isUserInteractionEnabled = true
            self.lblAll.isUserInteractionEnabled = true
            self.btnSwapcoins.isUserInteractionEnabled = true
            self.viewProvider.isHidden = false
            self.lblChooseProvider.isHidden = false
            self.lblBestProvider.text = highestPriceProvider?.name

            if self.providerName == "rangoexchange" {
                //self.lblProviderSwapperFee.isHidden = false
                self.lblProviderSwapperFee.text = "\(self.swapperFee)"
            } else {
               // self.lblProviderSwapperFee.isHidden = true
            }

            let imgUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.images + (highestPriceProvider?.image ?? "")
            self.ivProvider.sd_setImage(with: URL(string: imgUrl))
            self.txtGet.hideLoading()
            
            self.txtGet.text = formattedPrice
            self.bestPrice = Double(formattedPrice) ?? 0.0
            self.lblProviderBestPrice.text = "\(self.bestPrice)"
            self.bestQuote = formattedPrice

            let get = Double(self.txtGet.text ?? "") ?? 0.0
            let getPrice = (Double(self.getCoinDetail?.price ?? "") ?? 0.0)
            let getAmount = get * getPrice

            if self.txtGet.text == "" {
                self.lblGetMoney.text = ""
            } else {
                self.lblFindProvider.text = ""
                let value = getAmount
                let formattedValue = WalletData.shared.formatDecimalString("\(value)", decimalPlaces: 10)
                self.lblGetMoney.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(formattedValue)"
            }
            
            if (Double(self.getCoinDetail?.price ?? "") ?? 0.0) == 0.0 || (Double(self.payCoinDetail?.price ?? "") ?? 0.0 == 0.0) {
                self.lblEstimateAmount.isHidden = true
            } else {
                self.lblEstimateAmount.isHidden = false
                let estimatePrice = (Double(formattedPrice) ?? 0.0) / (Double(self.txtPay.text ?? "") ?? 0.0)
                let estimatePriceTruncatedValue = WalletData.shared.formatDecimalString("\(estimatePrice)", decimalPlaces: 15)
                self.lblEstimateAmount.text = "1 \(self.payCoinDetail?.symbol ?? "") = \(estimatePriceTruncatedValue) \(self.getCoinDetail?.symbol ?? "")"
                self.payCoinSymbol = self.payCoinDetail?.symbol ?? ""
                self.getCoinSymbol = self.getCoinDetail?.symbol ?? ""
            }
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

    @IBAction func actionSwapCoins(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.viewProvider.isHidden = true
        self.lblChooseProvider.isHidden = true
        UIView.animate(withDuration: 0.6, animations: {
            self.btnSwapcoins.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: { _ in
            UIView.animate(withDuration: 0.6) {
                self.btnSwapcoins.transform = CGAffineTransform.identity
            }  })
        let payableCoin = getCoinDetail
        let getableCoin = payCoinDetail
        getCoinDetail = getableCoin
        payCoinDetail = payableCoin
        setCoinDetail()
    }
     func checkChains() {
        btnSwap.setTitle( LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.previewswap, comment: ""), for: .normal)
    }
    @IBAction func actionSwap(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.registerUserViewModel.setWalletActiveAPI(walletAddress: WalletData.shared.myWallet?.address ?? "") { resStatus, message in
                print(message)
        }
        print("swapNew", self.cachedSwapperFee)
       
         let  payDoubleScientificNotationString = txtPay.text ?? ""
         let payDoubleValue = convertScientificToDouble(scientificNotationString: payDoubleScientificNotationString)
        let payBalanceDoubleScientificNotationString = payCoinDetail?.balance ?? ""
        let payBalance = convertScientificToDouble(scientificNotationString: payBalanceDoubleScientificNotationString)
        if payCoinDetail?.chain?.coinType == CoinType.bitcoin {
            if txtPay.text ?? "" == "" {
                showToast(message: ToastMessages.payAmountRequired, font: AppFont.regular(15).value)
                return
            }
            if (payDoubleValue ?? 0.0) > (payBalance ?? 0.0) {
                showToast(message: ToastMessages.lowBalance(payCoinDetail?.symbol ?? ""), font: AppFont.regular(15).value)
                return
            }
            if txtGet.text ?? "" == "" {
                showToast(message:"Provider not found!", font: AppFont.regular(15).value)
                return
            }
            if (payDoubleValue ?? 0.0) > 0.0 {
                let formattedPrice = WalletData.shared.formatDecimalString("\(self.bestQuote)", decimalPlaces: 10)
                switch provider {
                case "changenow" :
                    let swapPreviewVC = PreviewSwap1ViewController()
                    let previewSwapDetail = PreviewSwap(payCoinDetail: self.payCoinDetail,getCoinDetail: self.getCoinDetail,payAmount: txtPay.text ?? "",getAmount: formattedPrice, quote: self.lblEstimateAmount.text ?? "",paySymbol: self.payCoinSymbol,getSymbol: self.getCoinSymbol)
                    swapPreviewVC.previewSwapDetail = previewSwapDetail
                    swapPreviewVC.delegate = self
                    swapPreviewVC.isFrom = "changeNow"
                    swapPreviewVC.swappingFee = ""
                    self.navigationController?.present(swapPreviewVC, animated: true)
                case "okx":
                    break
                case "rangoexchange":
                    break
                case "exodus":
                    break
                default:
                    break
                }  } else {
                self.showToast(message: ToastMessages.insufficientAmount, font: AppFont.regular(15).value)
            } } else {
        if txtPay.text ?? "" == "" {
            showToast(message: ToastMessages.payAmountRequired, font: AppFont.regular(15).value)
            return
        }
        if (payDoubleValue ?? 0.0) > (payBalance ?? 0.0) {
            showToast(message: ToastMessages.lowBalance(payCoinDetail?.symbol ?? ""), font: AppFont.regular(15).value)
            return
        }
        if txtGet.text ?? "" == "" {
            showToast(message:"Provider not found!", font: AppFont.regular(15).value)
            return
        }
        if (payDoubleValue ?? 0.0) > 0.0 {
            let formattedPrice = WalletData.shared.formatDecimalString("\(self.bestQuote)", decimalPlaces: 10)
           swapperFeeValidation(formattedPrice: formattedPrice)
//            selectProvider(formattedPrice,self.providerName)
        } else {
            self.showToast(message: ToastMessages.insufficientAmount, font: AppFont.regular(15).value)
        }}// else
    }
    @IBAction func btnSelectGetTokenAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtGet.text = ""
        txtPay.text = ""
        lblPayMoney.text = ""
        lblGetMoney.text = ""
        viewProvider.isHidden = true
        lblChooseProvider.isHidden = true
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
                return "pol"
            case .bitcoin:
                return "btc"
            case .opMainnet:
                return "op"
            case .avalanche:
                return "AVAX"
            case .arbitrum:
                return "arb"
            case.base:
                return "Base"
//            case .tron:
//                return "TRON"
//            case .solana:
//                return "Solana"
            case .none:
                return ""
            
            }        }
        coinListVC.isFrom = "swap"
        coinListVC.fromNetwork = fromNetwork
        coinListVC.payCoinDetail = self.payCoinDetail
        coinListVC.swapDelegate = self
        self.navigationController?.present(coinListVC, animated: true)
    }
    
    @IBAction func btnSelectPayTokenAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        txtGet.text = ""
        txtPay.text = ""
        lblPayMoney.text = ""
        lblGetMoney.text = ""
        viewProvider.isHidden = true
        lblChooseProvider.isHidden = true
        let coinListVC = CoinListViewController()
        coinListVC.isPayCoin = true
        coinListVC.isFrom = "swap"
        coinListVC.isOkx = self.isOkx
        coinListVC.swapDelegate = self
        self.navigationController?.present(coinListVC, animated: true)
    }
    @IBAction func btnMaxAction(_ sender: UIButton) {
        HapticFeedback.generate(.light)
        if self.payCoinDetail?.chain?.coinType == CoinType.bitcoin {
            let paybalance = Double(self.payCoinDetail?.balance ?? "") ?? 0.0
            self.txtPay.text = "\( WalletData.shared.formatDecimalString("\(paybalance)", decimalPlaces: 15))"
        } else {
            self.txtPay.text = "\(self.payCoinDetail?.balance ?? "")"
        }
            textFieldDidChangeSelection(self.txtPay)
        
    }
}

// swiftlint:enable type_body_length
// MARK: SwappingCoinDelegate
extension SwapViewController: SwappingCoinDelegate {
    func selectPayCoin(_ coinDetail: Token?) {
        guard coinDetail != getCoinDetail else {
            showToast(message: ToastMessages.samecoinError, font: AppFont.regular(15).value)
            return
        }
        /// setup for kip20 tokens
        if coinDetail?.type == Chain.oKC.tokenStandard {
            self.tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
            self.tokensList = tokensList?.filter { $0.type == Chain.oKC.tokenStandard && $0 != payCoinDetail}
            if let availableTokens = tokensList, !availableTokens.isEmpty {
                if availableTokens.first == coinDetail {
                    self.getCoinDetail = availableTokens.last
                } else {
                    self.getCoinDetail = availableTokens.first
                }
                self.setCoinDetail()
            }}
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

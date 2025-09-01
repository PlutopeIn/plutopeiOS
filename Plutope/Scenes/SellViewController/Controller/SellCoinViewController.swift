//
//  SellCoinViewController.swift
//  Plutope
//
//  Created by Mitali Desai on 17/07/23.
//

import UIKit

class SellCoinViewController: UIViewController {
    
    @IBOutlet weak var ivInfo: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var clvKeyboard: UICollectionView!
    @IBOutlet weak var viewProvider: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblExceedbal: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblCoinQuantity: LoadingLabel!
    @IBOutlet weak var lblProviderName: UILabel!
    @IBOutlet weak var ivProvider: UIImageView!
    @IBOutlet weak var btnSelectedCurrency: UIButton!
    @IBOutlet weak var btnNext: GradientButton!
    @IBOutlet weak var lblThirdParty: UILabel!
    @IBOutlet weak var lblBestPrice: UILabel!
    
    @IBOutlet weak var lblBal: LoadingLabel!
    var coinDetail: Token?
    var apiCount = 0
    var isOnMeta = false
    var allProviders = [BuyProviders]()
    var provider: SellCrypto.Domain = .onRamp()
    // Define a completion handler type for API calls
    typealias APICompletionHandler = (Bool, [String: Any]?) -> Void
    var selectedCurrency: Currencies?
    var url: String?
    lazy var viewModel: ProviderViewModel = {
        ProviderViewModel { _, message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
            self.checkAllAPIsCompleted()
            DGProgressView.shared.hideLoader()
        }
    }()
    var supportedProviders = [SellCrypto.Domain]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.supportedProviders = (self.coinDetail?.chain!.sellProviders)!
      
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: "Sell \(coinDetail?.symbol ?? "")")
        
        self.btnNext.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.next, comment: ""), for: .normal)
        self.lblThirdParty.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.thirdpartyprovider, comment: "")
        self.lblBestPrice.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.bestprice, comment: "")
        
        /// Provider Action
        viewProvider.addTapGesture(target: self, action: #selector(providerTapped))
        
        /// Keyboard Register
        keyboardRegister()
        
        selectedCurrency = WalletData.shared.primaryCurrency
        btnSelectedCurrency.setTitle(selectedCurrency?.symbol ?? "", for: .normal)
        lblCurrency.text = coinDetail?.symbol ?? ""
        
        /// Present Info warnig before sell asset
        ivInfo.addTapGesture {
            HapticFeedback.generate(.light)
            let presentInfoVc = PushNotificationViewController()
            presentInfoVc.alertData = .sellCryptoWarning
            presentInfoVc.modalTransitionStyle = .crossDissolve
            presentInfoVc.modalPresentationStyle = .overFullScreen
            self.present(presentInfoVc, animated: true, completion: nil)
        }
        
        getAllProvider(providers: (self.coinDetail?.chain!.sellProviders)!)
    }
    
    /// getBestPriceFromAllProvider
    fileprivate func getAllProvider(providers: [SellCrypto.Domain]) {
        lblCoinQuantity.showLoading()
        viewProvider.isHidden = true
        
        /// Update Provider name with the name from the provider
        lblPrice.text = "10"
        
//        for idx in 0..<providers.count {
//            if providers[idx] == .onMeta() {
//                allProviders.append(BuyProviders(imageUrl: UIImage.providerOnMeta, name: StringConstants.onMeta, bestPrice: ""))
//                
//            } else if providers[idx] == .changeNow() {
//                allProviders.append(BuyProviders(imageUrl: UIImage.providerChangeNow, name: StringConstants.changeNow, bestPrice: ""))
//                
//            } else if providers[idx] == .onRamp() {
//                allProviders.append(BuyProviders(imageUrl: UIImage.providerRamp, name: StringConstants.onRamp, bestPrice: ""))
//                
//            }
//        }
       
        if Double(coinDetail?.balance ?? "") ?? 0.0 > 0 {
            let roundedValue = Double(coinDetail?.balance ?? "0") ?? 0.0
            let roundVal = WalletData.shared.formatDecimalString("\(roundedValue)", decimalPlaces: 7)
            // lblBal.text = "Balance: " + String(format: "%.7f", roundedValue)
            lblBal.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.balance, comment: "") + roundVal
        } else {
            // lblBal.text = "Balance: " + "0.00"
            lblBal.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.balance, comment: "") + "0.00"
        }
        if (Double(coinDetail?.balance ?? "") ?? 0.0) < (Double(lblPrice.text ?? "") ?? 0.0) {
            lblExceedbal.isHidden = false
            lblCoinQuantity.hideLoading()
            lblCoinQuantity.text = "Not available!"
            self.btnNext.alpha = 0.5
            self.btnNext.isUserInteractionEnabled = false
        } else {
            self.btnNext.alpha = 1
            self.btnNext.isUserInteractionEnabled = true
            lblExceedbal.isHidden = true
            callAPIsAfterTaskCompletion()
        }
    }
    
    func getBestPriceFromAllBestPrices() {
        
        if let highestPriceProvider = allProviders.max(by: { (Double($0.bestPrice ?? "") ?? 0.0) < Double($1.bestPrice ?? "") ?? 0.0 }) {
            if Double(highestPriceProvider.bestPrice ?? "") ?? 0.0 <= 0 {
                lblCoinQuantity.hideLoading()
                lblCoinQuantity.text = "Not available!"
                viewProvider.isHidden = true
                print("Price not available for the provider")
            } else {
                lblCoinQuantity.hideLoading()
                viewProvider.isHidden = false
                lblProviderName.text = highestPriceProvider.name
                
                let formattedPrice = WalletData.shared.formatDecimalString("\(highestPriceProvider.bestPrice ?? "")", decimalPlaces: 6)
               // let formattedPrice = String(format: "%.6f", Double(highestPriceProvider.bestPrice ?? "") ?? 0.0)
                lblCoinQuantity.text = "~\(selectedCurrency?.sign ?? "")\(formattedPrice)"
                ivProvider.image = highestPriceProvider.imageUrl
                switch highestPriceProvider.name {
                case StringConstants.onMeta:
                    self.provider = .onMeta()
                case StringConstants.changeNow:
                    self.provider = .changeNow()
                case StringConstants.onRamp:
                    self.provider = .onRamp()
                    // case StringConstants.meld:
                    // self.provider = .meld()
                default:
                    break
                }
            }
            
        } else {
            lblCoinQuantity.hideLoading()
            lblCoinQuantity.text = "Not available!"
            viewProvider.isHidden = true
            print("No providers found")
        }
    }
    
    /// Will open provider list
    @objc func providerTapped(_ sender: UITapGestureRecognizer) {
        HapticFeedback.generate(.light)
        let viewToNavigate = ProvidersViewController()
        viewToNavigate.coinDetail = self.coinDetail
        var sortedProviders = allProviders.sorted(by: { provider1, provider2 in
            let price1 = Double(provider1.bestPrice ?? "") ?? 0.0
            let price2 = Double(provider2.bestPrice ?? "") ?? 0.0
            return price1 > price2
        })
        sortedProviders = sortedProviders.filter { (Double($0.bestPrice ?? "") ?? 0.0) > 0 }
        viewToNavigate.arrProviderList = sortedProviders
        viewToNavigate.delegate = self
        viewToNavigate.selectedCurrency = self.selectedCurrency
        viewToNavigate.providerType = .sell
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    
    /// Keyboard Register
    func keyboardRegister() {
        clvKeyboard.delegate = self
        clvKeyboard.dataSource = self
        
        clvKeyboard.register(KeyboardViewCell.nib, forCellWithReuseIdentifier: KeyboardViewCell.reuseIdentifier)
    }
    @IBAction func actionCurrency(_ sender: Any) {
        HapticFeedback.generate(.light)
        let viewToNavigate = CurrencyViewController()
        viewToNavigate.delegate = self
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    
    /// actionNext
    @IBAction func actionNext(_ sender: Any) {
        HapticFeedback.generate(.light)
        // guard let priceval = Double(lblPrice.text ?? ""), priceval <= minimumAmount,
        guard let price = lblPrice.text,
              let walletAddress = coinDetail?.chain?.walletAddress,
              let currencyToBuy = coinDetail?.symbol?.lowercased(),
              let chainId = coinDetail?.chain?.chainId,
              let networkType = coinDetail?.type else { return }
        
        switch provider {
        case .onRamp:
            url = SellCrypto.buildURL(for: .onRamp(coinCode: currencyToBuy, walletAddress: walletAddress, coinAmount: price, networkType: networkType))
            // case .meld:
            // url = SellCrypto.buildURL(for: .meld(countryCode: "IN", sourceAmount: price, sourceCurrencyCode: currencyToBuy, destinationCurrencyCode: "\(WalletData.shared.primaryCurrency?.symbol ?? "")", walletAddress: walletAddress, pubKey: ""))
        case .changeNow:
            var fromCurrency : String? {
                if coinDetail?.address != "" {
                    switch coinDetail?.chain {
                    case .polygon:
                        return "\(currencyToBuy)pol"
                    case .binanceSmartChain:
                        return "\(currencyToBuy)bsc"
                    case .ethereum:
                        return "\(currencyToBuy)"
                    case .oKC:
                        return ""
                    default:
                        return ""
                    }
                } else {
                    switch coinDetail?.chain {
                    case .polygon:
                        return "\(currencyToBuy)mainnet"
                    case .binanceSmartChain:
                        return "\(currencyToBuy)bsc"
                    case .ethereum:
                        return "\(currencyToBuy)"
                    case .oKC:
                        return ""
                    default:
                        return ""
                    }

                }
            }
            url = SellCrypto.buildURL(for: .changeNow(from: fromCurrency, toAddress: "\(self.selectedCurrency?.symbol ?? "")", fiatMode: true, amount: price, recipientAddress: walletAddress))
        case .onMeta:
            self.isOnMeta = true
            let fiatAmount = "\((Double(price) ?? 0.0) * (Double(coinDetail?.price ?? "") ?? 0.0))"
            let apiKey = APIKey.onMeta
            url = SellCrypto.buildURL(for: .onMeta(apiKey: apiKey, walletAddress: walletAddress, fiatAmount: fiatAmount, chainId: chainId, tokenAddress: coinDetail?.address ?? "",tokenSymbol: currencyToBuy.uppercased()))
        }
        
        if let url = url {
            self.showWebView(for: url, onVC: self, title: "Sell \(coinDetail?.symbol ?? "")")
        }
    }
    @MainActor
    func showWebView(for url: String, onVC: UIViewController, title: String) {
        let webController = WebViewController()
        webController.webViewURL = url
        webController.webViewTitle = title
        webController.isOnMeta = self.isOnMeta
        self.navigationController?.pushViewController(webController, animated: true)
    }
}

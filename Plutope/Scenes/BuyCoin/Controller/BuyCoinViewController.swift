//
//  BuyCoinViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
import SafariServices

class BuyCoinViewController: UIViewController, Reusable {
    
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var clvKeyboard: UICollectionView!
    @IBOutlet weak var viewProvider: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblCoinQuantity: LoadingLabel!
    @IBOutlet weak var lblProviderName: UILabel!
    @IBOutlet weak var ivProvider: UIImageView!
    @IBOutlet weak var btnSelectedCurrency: UIButton!
    @IBOutlet weak var btnNext: GradientButton!
    @IBOutlet weak var lblBestPrice: UILabel!
    @IBOutlet weak var lblThirdParty: UILabel!
    var isApiResponseReceived = false
    var headerTitle: String?
    var apiDispatchGroups = DispatchGroup()
    lazy var coinDetail: Token? = nil
    var isOnMeta = false
    var allProviders = [BuyProviders]()
    var provider: BuyCrypto.Domain = .onRamp()
    var apiCount = 0
    var url: String?
    
    // Define a completion handler type for API calls
    typealias APICompletionHandler = (Bool, [String: Any]?) -> Void
    var selectedCurrency: Currencies?
    
    lazy var viewModel: ProviderViewModel = {
        ProviderViewModel { _, message in
          //  self.showToast(message: message, font: .systemFont(ofSize: 15))
            self.checkAllAPIsCompleted()
            DGProgressView.shared.hideLoader()
        }
    }()
    var supportedProviders = [BuyCrypto.Domain]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnNext.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.next, comment: ""), for: .normal)
        self.lblThirdParty.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.thirdpartyprovider, comment: "")
        self.lblBestPrice.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.bestprice, comment: "")
        
        self.supportedProviders = (self.coinDetail?.chain!.buyProviders)!
        
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: headerTitle ?? "")
        
        /// Keyboard Register
        keyboardRegister()
       //  txtPrice.delegate = self
        /// Provider Action
        viewProvider.addTapGesture(target: self, action: #selector(providerTapped))
        
        selectedCurrency = WalletData.shared.primaryCurrency
        btnSelectedCurrency.setTitle(selectedCurrency?.symbol ?? "", for: .normal)
        lblCurrency.text = selectedCurrency?.sign ?? ""
        getBestPriceFromAllProvider(buyProviders: supportedProviders)
        
    }
    
    /// getBestPriceFromAllProvider
     func getBestPriceFromAllProvider(buyProviders: [BuyCrypto.Domain]) {
        lblCoinQuantity.showLoading()
        viewProvider.isHidden = true
        
        /// Update Provider name with the name from the provider
     
        //  lblPrice.text = "2500"
         txtPrice.text = "2500"

        for idx in 0..<buyProviders.count {
            /// temporary hide onMeta code
                if buyProviders[idx] == .onMeta() {
                    allProviders.append(BuyProviders(imageUrl: UIImage.providerOnMeta, name: StringConstants.onMeta, bestPrice: ""))

                } else if buyProviders[idx] == .meld() {
                    allProviders.append(BuyProviders(imageUrl: UIImage.providerMeld, name: StringConstants.meld, bestPrice: ""))
                    
                } else if buyProviders[idx] == .changeNow() {
                    allProviders.append(BuyProviders(imageUrl: UIImage.providerChangeNow, name: StringConstants.changeNow, bestPrice: ""))
                    
                } else if buyProviders[idx] == .onRamp() {
                    allProviders.append(BuyProviders(imageUrl: UIImage.providerRamp, name: StringConstants.onRamp, bestPrice: ""))
                } else if buyProviders[idx] == .alchemy() {
                    
                } else if buyProviders[idx] == .unlimit() {
                    allProviders.append(BuyProviders(imageUrl: UIImage.providerUnLimit, name: StringConstants.unLimit, bestPrice: ""))
                }
        }
         
         if self.selectedCurrency?.symbol == "INR" {
             print("Selected Currency Symbol: \(self.selectedCurrency?.symbol ?? "nil")")
             allProviders = allProviders.filter { provider in
                 if provider.name != "Change Now" {
                     return true
                 } else {
                     return false
                 }
             }
             print("Filtered Providers: \(self.allProviders)")
         }
       
        if allProviders.count == 0 {
            lblCoinQuantity.hideLoading()
            lblCoinQuantity.text = "Not available!"
        } else {
            callAPIsAfterTaskCompletion()
        }
    
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        makeAPICallIfValid()
    }
    
    func getBestPriceFromAllBestPrices() {
       
        if let highestPriceProvider = allProviders.max(by: { (Double($0.bestPrice ?? "") ?? 0.0) < Double($1.bestPrice ?? "") ?? 0.0 }) {
            DispatchQueue.main.async {
                if Double(highestPriceProvider.bestPrice ?? "") ?? 0.0 <= 0 {
                    self.lblCoinQuantity.hideLoading()
                    self.lblCoinQuantity.text = "Not available!"
                    self.viewProvider.isHidden = true
                    print("Price not available for the provider")
                } else {
                    self.lblCoinQuantity.hideLoading()
                    self.viewProvider.isHidden = false
                   // self.isApiResponseReceived = true
                    self.lblProviderName.text = highestPriceProvider.name
                    let formattedPrice = WalletData.shared.formatDecimalString("\(highestPriceProvider.bestPrice ?? "")", decimalPlaces: 6)
                    //  let formattedPrice = String(format: "%.6f", Double(highestPriceProvider.bestPrice ?? "") ?? 0.0)
                    self.lblCoinQuantity.text = "~\(formattedPrice) \(self.coinDetail?.symbol ?? "")"
                    self.ivProvider.image = highestPriceProvider.imageUrl
                    switch highestPriceProvider.name {
                        /// temporary hide onMeta code
                    case StringConstants.onMeta:
                        self.provider = .onMeta()
                    case StringConstants.changeNow:
                        self.provider = .changeNow()
                    case StringConstants.onRamp:
                        self.provider = .onRamp()
                    case StringConstants.meld:
                        self.provider = .meld()
                    case StringConstants.unLimit:
                        self.provider = .unlimit()
                    default:
                        break
                    }
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
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    
    /// Keyboard Register
    func keyboardRegister() {
        clvKeyboard.delegate = self
        clvKeyboard.dataSource = self
        
        clvKeyboard.register(KeyboardViewCell.nib, forCellWithReuseIdentifier: KeyboardViewCell.reuseIdentifier)
    }
    
    @IBAction func actionCurrency(_ sender: Any) {
        let viewToNavigate = CurrencyViewController()
        viewToNavigate.delegate = self
        self.navigationController?.pushViewController(viewToNavigate, animated: true)
    }
    @IBAction func actionNext(_ sender: Any) {
       
        //        guard let priceval = Double(lblPrice.text ?? ""), priceval <= minimumAmount,
        if viewProvider.isHidden {
            self.btnNext.alpha = 0.5
            self.btnNext.isUserInteractionEnabled = false
            return
        }
        guard let price = txtPrice.text,
              let walletAddress = coinDetail?.chain?.walletAddress,
              let currencyToBuy = coinDetail?.symbol?.lowercased(),
              let chainId = coinDetail?.chain?.chainId,
              let networkType = coinDetail?.type else { return  }
       
        switch provider {
        case .onRamp:
            url = BuyCrypto.buildURL(for: .onRamp(coinCode: currencyToBuy, walletAddress: walletAddress, fiatAmount: price, networkType: networkType))
        case .meld:
            url = BuyCrypto.buildURL(for: .meld(countryCode: "\((self.selectedCurrency?.symbol ?? "").prefix(2))", sourceAmount: price, sourceCurrencyCode: "\(self.selectedCurrency?.symbol ?? "")", destinationCurrencyCode: currencyToBuy.uppercased(), walletAddress: walletAddress, networkType: "\(networkType )", tokenAddress: coinDetail?.address ))
        case .changeNow:

            if let validCoinDetail = coinDetail {
               let toCurrency = getToCurrency(coinDetail: validCoinDetail , currencyToBuy: currencyToBuy)
                
                url = BuyCrypto.buildURL(for: .changeNow(from: "\(self.selectedCurrency?.symbol ?? "")", toAddress: toCurrency, fiatMode: true, amount: price, recipientAddress: walletAddress))
            } else {
                // coinDetail is nil
            }
           
            /// temporary hide onMeta code 
        case .onMeta:
            self.isOnMeta = true
            let apiKey = APIKey.onMeta
            url = BuyCrypto.buildURL(for: .onMeta(apiKey: apiKey, walletAddress: walletAddress, fiatAmount: price, chainId: chainId, tokenAddress: coinDetail?.address ?? "",tokenSymbol: currencyToBuy))
        case .alchemy:
            break
        case .unlimit:
            let crypto = "\(coinDetail?.symbol ?? "")-\(coinDetail?.type ?? "")"
            let countryCode = self.selectedCurrency?.symbol ?? ""
            url = BuyCrypto.buildURL(for: .unlimit(merchantId: "8d16f1c7-a6d1-46ac-bdf3-621284be889b",destinationCurrencyCode: crypto,fiatAmount: price,countryCode: countryCode))
        }
     
        if let url = url {
            let _ : String = url
            self.showWebView(for: url, onVC: self, title: "Buy \(coinDetail?.symbol ?? "")")
            
    //        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
    //           if #available(iOS 10.0, *) {
    //              UIApplication.shared.open(url, options: [:], completionHandler: nil)
    //           } else {
    //              UIApplication.shared.openURL(url)
    //           }
    //        }
        }
    }
    
    func getToCurrency(coinDetail: Token, currencyToBuy : String) -> String {
        if coinDetail.address != "" {
            switch coinDetail.chain {
            case .polygon:
                return "\(currencyToBuy)matic"
            case .binanceSmartChain:
                return "\(currencyToBuy)bsc"
            case .ethereum:
                return "\(currencyToBuy)"
            case .oKC:
                return ""
            case .bitcoin:
                return "\(currencyToBuy)"
            default:
                return ""
            }
        } else {
            switch coinDetail.chain {
            case .polygon:
                return "\(currencyToBuy)mainnet"
            case .binanceSmartChain:
                return "\(currencyToBuy)bsc"
            case .ethereum:
                return "\(currencyToBuy)"
            case .oKC:
                return ""
            case .bitcoin:
                return "\(currencyToBuy)"
            default:
                return ""
            }

        }
    }
    @MainActor
    func showWebView(for url: String, onVC: UIViewController, title: String) {
        if(self.isOnMeta) {
            
//                    if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
//                       if #available(iOS 10.0, *) {
//                          UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                       } else {
//                          UIApplication.shared.openURL(url)
//                       }
//                    }
            
            if let url = URL(string: url) {
                let safariViewController = SFSafariViewController(url: url)
                let navigationController = UINavigationController(rootViewController: safariViewController)
                navigationController.setNavigationBarHidden(true, animated: false)
                present(navigationController, animated: true, completion: nil)
            }
        } else {
        let webController = WebViewController()
            webController.webViewURL = url
            webController.webViewTitle = title
            webController.isOnMeta = self.isOnMeta
            self.navigationController?.pushViewController(webController, animated: true)
        }
    }
    
}

//extension BuyCoinViewController : UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        performNetworkCall()
//    }
//}

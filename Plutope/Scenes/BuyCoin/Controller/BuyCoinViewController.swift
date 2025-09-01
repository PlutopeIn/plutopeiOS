//
//  BuyCoinViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
import SafariServices
import SDWebImage
import IQKeyboardManagerSwift
class BuyCoinViewController: UIViewController, Reusable {
    
    @IBOutlet weak var lblChooseProvider: UILabel!
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
    @IBOutlet weak var lblBestPriceTitle: UILabel!
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
    var sendAddress = ""
    var sendCoinQuantity = ""
    var isFrom = ""
    var buyQuoteArr = [BuyMeargedDataList]()
    var isAlphyne = false
    var isOnRamper = false
    var isGuardarian = false
    var providerName = ""
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
    lazy var buyCoinQuoteViewModel: BuyCoinQuoteViewModel = {
        BuyCoinQuoteViewModel { _, _ in
          
        }
    }()
    
    var supportedProviders = [BuyCrypto.Domain]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnNext.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.next, comment: ""), for: .normal)
        self.lblThirdParty.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.thirdpartyprovider, comment: "")
        
      //  self.lblBestPrice.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.bestprice, comment: "")
        btnSelectedCurrency.titleLabel?.font = AppFont.regular(16.58).value
        btnNext.titleLabel?.font = AppFont.regular(16.58).value
        lblCurrency.font = AppFont.violetRegular(50).value
        lblCoinQuantity.font = AppFont.violetRegular(22).value
        lblChooseProvider.font = AppFont.violetRegular(24).value
        lblProviderName.font = AppFont.violetRegular(20).value
        lblBestPriceTitle.font = AppFont.regular(14).value
        lblThirdParty.font = AppFont.regular(14).value
        txtPrice.font = AppFont.violetRegular(50).value
        
        self.supportedProviders = (self.coinDetail?.chain!.buyProviders)!
        
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: headerTitle ?? "")
        
        /// Keyboard Register
//        keyboardRegister()
        /// Provider Action
        viewProvider.addTapGesture(target: self, action: #selector(providerTapped))
        self.btnNext.alpha = 0.5
        self.btnNext.isUserInteractionEnabled = false
        selectedCurrency = WalletData.shared.primaryCurrency
        btnSelectedCurrency.setTitle(selectedCurrency?.symbol ?? "", for: .normal)
        lblCurrency.text = selectedCurrency?.sign ?? ""
        getBestPriceFromAllProvider()
        
    }
    func getBestPriceFromAllProvider() {
       lblCoinQuantity.showLoading()
       viewProvider.isHidden = true
       lblChooseProvider.isHidden = true
       
       txtPrice.text = "5200"
        getQuote()
   
   }

    @IBAction func textCharecterChnage(_ sender: UITextField) {
        HapticFeedback.generate(.light)
        self.btnNext.alpha = 0.5
        self.btnNext.isUserInteractionEnabled = false
        makeAPICallIfValid()
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        HapticFeedback.generate(.light)
        makeAPICallIfValid()
    }
    
    func getBestPriceFromAllBestPrices() {
        
        if self.selectedCurrency?.symbol == "INR" {
            print("Selected Currency Symbol: \(self.selectedCurrency?.symbol ?? "nil")")
            self.buyQuoteArr = buyQuoteArr.filter { provider in
                if provider.providerName != "changenow" {
                    return true
                } else {
                    return false
                }
            }
            print("Filtered Providers: \(self.allProviders)")
        }
        let highestPriceProvider = self.buyQuoteArr.first
        guard let bestPrice =  self.buyQuoteArr.first?.amount else { return  }
 
          //  DispatchQueue.main.async {
                if Double(bestPrice) ?? 0.0 <= 0 {
                    self.lblCoinQuantity.hideLoading()
                    self.lblCoinQuantity.text = " Not available! "
                    self.viewProvider.isHidden = true
                    self.lblChooseProvider.isHidden = true
                    print("Price not available for the provider")
                } else {
                    self.lblCoinQuantity.hideLoading()
                    self.btnNext.alpha = 1
                    self.btnNext.isUserInteractionEnabled = true
                    self.viewProvider.isHidden = false
                    self.lblChooseProvider.isHidden = false
                   // self.isApiResponseReceived = true
                    self.lblProviderName.text = highestPriceProvider?.name
                    self.providerName = highestPriceProvider?.providerName ?? ""
                    let formattedPrice = WalletData.shared.formatDecimalString("\(highestPriceProvider?.amount ?? "")", decimalPlaces: 6)
            
                    self.lblCoinQuantity.text = " ~\(formattedPrice) \(self.coinDetail?.symbol ?? "" )"
                    let imgUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion+ServiceNameConstant.BaseUrl.images + (highestPriceProvider?.image ?? "")
                    self.ivProvider.sd_setImage(with: URL(string: imgUrl))
                    self.url = highestPriceProvider?.url
                }
            }
    
    /// Will open provider list
    @objc func providerTapped(_ sender: UITapGestureRecognizer) {
        HapticFeedback.generate(.light)
        let viewToNavigate = ProvidersViewController()
        viewToNavigate.coinDetail = self.coinDetail
        var sortedProviders = self.buyQuoteArr.sorted(by: { provider1, provider2 in
            let price1 = Double(provider1.amount ?? "") ?? 0.0
            let price2 = Double(provider2.amount ?? "") ?? 0.0
            return price1 > price2
        })
        sortedProviders = sortedProviders.filter { (Double($0.amount ?? "") ?? 0.0) > 0 }
        viewToNavigate.buyArrProviderList = sortedProviders
        viewToNavigate.buydelegate = self
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
    @IBAction func actionNext(_ sender: Any) {
        HapticFeedback.generate(.light)
        //        guard let priceval = Double(lblPrice.text ?? ""), priceval <= minimumAmount,
        if viewProvider.isHidden {
            self.btnNext.alpha = 0.5
            self.btnNext.isUserInteractionEnabled = false
            return
        }
        if self.providerName == "alpyne" {
            isAlphyne = true
        } else if self.providerName == "onrampable" {
            isOnRamper = true
        } 
//        else if self.providerName == "guardarian" {
//            isGuardarian = true
//        }
        if let url = url {
            let _ : String = url
            self.showWebView(for: url, onVC: self, title: "Buy \(coinDetail?.symbol ?? "")")
        }
    }
    
    func getToCurrency(coinDetail: Token, currencyToBuy : String) -> String {
        if coinDetail.address != "" {
            switch coinDetail.chain {
            case .polygon:
                return "\(currencyToBuy)pol"
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
        if(self.isAlphyne) {
            if let url = URL(string: url) {
                let safariViewController = SFSafariViewController(url: url)
                let navigationController = UINavigationController(rootViewController: safariViewController)
                navigationController.setNavigationBarHidden(true, animated: false)
                present(navigationController, animated: true, completion: nil)
            }
        }  else if(self.isOnRamper) {
            if let url = URL(string: url) {
                let safariViewController = SFSafariViewController(url: url)
                let navigationController = UINavigationController(rootViewController: safariViewController)
                navigationController.setNavigationBarHidden(true, animated: false)
                present(navigationController, animated: true, completion: nil)
            }
        } 
//        else if (self.isGuardarian) {
//            if let url = URL(string: url) {
//                let safariViewController = SFSafariViewController(url: url)
//                let navigationController = UINavigationController(rootViewController: safariViewController)
//                navigationController.setNavigationBarHidden(true, animated: false)
//                present(navigationController, animated: true, completion: nil)
//            }
//        } 
        else {
        let webController = WebViewController()
            webController.webViewURL = url
            webController.webViewTitle = title
            webController.isOnMeta = self.isOnMeta
            self.navigationController?.pushViewController(webController, animated: true)
        }
    }
    
}

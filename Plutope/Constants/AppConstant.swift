//
//  AppConstant.swift
//  Plutope
//
//  Created by Priyanka Poojara on 31/05/23.
//
import UIKit

typealias BindFail = ((_ status: Bool, _ message: String) -> Void)
struct AppConstants {
    static let serverURL: String = "@{serverURL}"
    static var storedTokensList: [MarketData]?
    static var storedCountryList:[CountryList]?
    static var cardPrimaryCurrency : String?
    static var tokensList: [Token]?
    // This property will load the stored wallet from UserDefaults (if it exists), or be an empty array otherwise
       static var storedWallet: [String]? {
           get {
               return UserDefaults.standard.stringArray(forKey: "storedWallet") ?? []
           }
           set {
               UserDefaults.standard.set(newValue, forKey: "storedWallet")
           }
       }
    static let supportedChains: [String] = [
            "binance-smart-chain", "ethereum", "polygon-pos", "okex-chain",
            "bitcoin", "optimistic-ethereum", "arbitrum-one", "avalanche", "base"
        ]
        
    static  let nativeCoins: [String] = [
            "OKT Chain", "Ethereum", "POL (ex-MATIC)", "BNB", "Bitcoin",
            "Optimism", "Arbitrum", "Avalanche", "Base"
        ]
}

public var screenWidth = UIScreen.main.bounds.width
public var screenHeight = UIScreen.main.bounds.height
public var isIPAD = UIDevice.current.userInterfaceIdiom == .pad
public var isIPHONE = UIDevice.current.userInterfaceIdiom == .phone
/// Enum to check for coin transfer modules
enum CoinList {
    case send
    case buy
    case receive
    case receiveNFT
    case addCustomToken
    case swap
    case search
}
let window = UIApplication.shared.windows.first

func getWindow() -> UIWindow? {
    return UIApplication.shared.windows.first
}
// MARK: Global function to set any screen as root
public func setRootViewController(viewController: UIViewController) {
    guard let window = getWindow() else { return }
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.tabBarController?.selectedIndex = 0
    navigationController.setNavigationBarHidden(true, animated: true)
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
}
// MARK: LogOut
public func logoutApp() {
   
    DispatchQueue.main.async {
   DGProgressView.shared.hideLoader()
   UserDefaults.standard.removeObject(forKey: loginApiToken)
   UserDefaults.standard.removeObject(forKey: loginPhoneNumber)
   UserDefaults.standard.removeObject(forKey: loginPassword)
   UserDefaults.standard.removeObject(forKey: loginApiRefreshToken)
   UserDefaults.standard.removeObject(forKey: cardHolderfullName)
   UserDefaults.standard.removeObject(forKey: cryptoCardNumber)
   UserDefaults.standard.removeObject(forKey: mainPublicKey)
   UserDefaults.standard.removeObject(forKey: mainPrivetKey)
   UserDefaults.standard.removeObject(forKey: loginApiTokenExpirey)
   UserDefaults.standard.removeObject(forKey: cardTypes)
   UserDefaults.standard.removeObject(forKey: fiateValue)
   UserDefaults.standard.removeObject(forKey: cardCurrency)
   UserDefaults.standard.removeObject(forKey: serverType)
        let app = Application() // Example, ensure this matches your Application initialization
        let interactor = MainInteractor()
        let configurationService = ConfigurationService()
        let tabBarVC = TabBarViewController(interactor: interactor,app:app,configurationService:configurationService)

        setRootViewController(viewController: tabBarVC)
    }
}
// MARK: - App protocol delegates

/// Delegate for dismiss/pop view and action
protocol PushViewControllerDelegate: AnyObject {
    func pushViewController(_ controller: UIViewController)
}
protocol ProviderSelectDelegate: AnyObject {
    func valuesTobePassed(_ provider: BuyProviders)
}
protocol BuyProviderSelectDelegate: AnyObject {
    func valuesTobePassed(_ name:String,amount:String,url:String,imageUrl:String,providerName:String)
}
protocol SwapProviderSelectDelegate: AnyObject {
    func valuesTobePassed(name: String?,bestPrice: String?,swapperFee : String?,providerImage : String?,providerName:String,isBestPrice:Bool)
}
protocol PrimaryWalletDelegate: AnyObject {
    func setPrimaryWallet(primaryWallet: Wallets?)
}
protocol RefreshDataDelegate: AnyObject {
    func refreshData()
}
protocol CurrencyUpdateDelegate: AnyObject {
    func updateCurrency(currencyObject : Currencies)
}
protocol PasscodeVerifyDelegate: AnyObject {
    func verifyPasscode(isVerify : Bool)
}

/// SelectNetworkDelegate
protocol SelectNetworkDelegate : AnyObject {
    func selectNetwork(chain: Token)
}

/// SwappingCoinDelegate
protocol SwappingCoinDelegate: AnyObject {
    
    func selectPayCoin(_ coinDetail: Token?)
    func selectGetCoin(_ coinDetail: Token?)
}
protocol UpdatedWalletWalletDelegate: AnyObject {
    func setUpdatedWallet(primaryWallet: Wallets?)
}

/// EnabledTokenDelegate
protocol EnabledTokenDelegate: AnyObject {
    func selectEnabledToken(_ coinDetail: Token)
}

/// EnabledTokenDelegate
protocol RefreshCardTokenDelegate: AnyObject {
    func refreshCardTokenDelegateToken()
}
/// Select Contact for send Amount
protocol SelectContactDelegate: AnyObject {
    func selectContact(_ contact: Contacts)
}

/// AddFiatAmountDelegate for Receive Qrcode with Amount 
protocol AddFiatAmountDelegate : AnyObject {
    func addFiatAmount(tokenAmount:String,type:String,value:String,walletType:String)

}

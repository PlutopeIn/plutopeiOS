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
}

// MARK: Global function to set any screen as root
public func setRootViewController(viewController: UIViewController) {
    let appDelegate = UIApplication.shared.delegate as? SceneDelegate
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.setNavigationBarHidden(true, animated: true)
    appDelegate?.window?.makeKeyAndVisible()
    appDelegate?.window?.rootViewController = navigationController
}

// MARK: - App protocol delegates

/// Delegate for dismiss/pop view and action
protocol PushViewControllerDelegate: AnyObject {
    func pushViewController(_ controller: UIViewController)
}
protocol ProviderSelectDelegate: AnyObject {
    func valuesTobePassed(_ provider: BuyProviders)
}
protocol SwapProviderSelectDelegate: AnyObject {
    func valuesTobePassed(_ provider: SwapProviders)
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

/// EnabledTokenDelegate
protocol EnabledTokenDelegate: AnyObject {
    func selectEnabledToken(_ coinDetail: Token)
}

/// Select Contact for send Amount
protocol SelectContactDelegate: AnyObject {
    func selectContact(_ contact: Contacts)
}

/// AddFiatAmountDelegate for Receive Qrcode with Amount 
protocol AddFiatAmountDelegate : AnyObject {
    func addFiatAmount(tokenAmount:String,type:String,value:String,walletType:String)

}

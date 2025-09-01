//
//  UpdateVersionViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 28/08/24.
//

import UIKit
import CoreData

class UpdateVersionViewController: UIViewController {
    @IBOutlet weak var btnUpdate: GradientButton!
    @IBOutlet weak var lblMsg: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    lazy var viewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
        }
    }()
    lazy var tokenListViewModel: TokenListViewModel = {
        TokenListViewModel { status,_ in
            if status == false {
                //  self.showToast(message: message, font: AppFont.regular(15).value)
            }
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnUpdate.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.update, comment: ""), for: .normal)
        btnUpdate.titleLabel?.font = AppFont.violetRegular(17).value
        lblTitle.font = AppFont.violetRegular(27).value
        lblMsg.font = AppFont.violetRegular(17).value
        lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.plutopeUpdate, comment: "")
        lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.updateMsg, comment: "")
    }
//    func globallyUpdateTokensAndWallets(from coinList: [CoingechoCoinList], nativeCoins: [String], supportedChains: [String], completion: @escaping () -> Void) {
//        let context = DatabaseHelper.shared.context
//        let existingTokens = (DatabaseHelper.shared.retrieveData("Token") as? [Token]) ?? []
//        let existingTokenKeys = Set(existingTokens.map { "\($0.tokenId ?? "")-\($0.address ?? "")" })
//
//        let allWallets = (DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]) ?? []
//        var didUpdate = false
//
//        for coin in coinList {
//            guard let id = coin.id, let name = coin.name, let symbol = coin.symbol else { continue }
//
//            // Handle native tokens
//            if nativeCoins.contains(name),
//               !existingTokenKeys.contains("\(id)-") {
//
//                let token = Token(context: context)
//                token.tokenId = id
//                token.name = name
//                token.symbol = symbol.uppercased()
//                token.isEnabled = true
//                token.address = ""
//                token.balance = "0"
//                token.decimals = 18
//                token.type = getTokenTypeFromName(name)
//                didUpdate = true
//
//                // Associate with all wallets
//                for wallet in allWallets {
//                    let walletToken = WalletTokens(context: context)
//                    walletToken.id = UUID()
//                    walletToken.wallet_id = wallet.wallet_id
//                    walletToken.tokens = token
//                }
//            }
//
//            // Handle platform tokens
//            if let platforms = coin.platforms {
//                for (chain, address) in platforms where supportedChains.contains(chain) {
//                    guard let address = address, !existingTokenKeys.contains("\(id)-\(address.lowercased())") else { continue }
//
//                    let token = Token(context: context)
//                    token.tokenId = id
//                    token.name = name
//                    token.symbol = symbol.uppercased()
//                    token.address = address.lowercased()
//                    token.balance = "0"
//                    token.decimals = 18
//                    token.isEnabled = false
//                    token.type = getTokenTypeFromPlatformKey(chain)
//                    didUpdate = true
//
//                    // Don't link disabled tokens
//                }
//            }
//        }
//
//        // Save once
//        if didUpdate {
//            do {
//                try context.save()
//                print("New tokens and wallet links saved.")
//            } catch {
//                print("Failed to save updates: \(error.localizedDescription)")
//            }
//        }
//
//        completion()
//    }
    func globallyUpdateTokensAndWallets(
        from coinList: [CoingechoCoinList],
        nativeCoins: [String],
        supportedChains: [String],
        completion: @escaping () -> Void
    ) {
        let context = DatabaseHelper.shared.context

        // Existing tokens
        let existingTokens = (DatabaseHelper.shared.retrieveData("Token") as? [Token]) ?? []
        let existingTokenKeys = Set(existingTokens.map { "\($0.tokenId ?? "")-\($0.address?.lowercased() ?? "")" })

        // Existing wallets
        let allWallets = (DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]) ?? []
        let existingWalletIds = Set(allWallets.compactMap { $0.wallet_id })

        // Existing wallet-token links
        let existingWalletTokens = (DatabaseHelper.shared.retrieveData("WalletTokens") as? [WalletTokens]) ?? []
        var existingWalletTokenKeys = Set(existingWalletTokens.map {
            "\($0.wallet_id ?? UUID())-\($0.tokens?.tokenId ?? "")-\($0.tokens?.address?.lowercased() ?? "")"
        })

        var didUpdate = false

        for coin in coinList {
            guard let id = coin.id, let name = coin.name, let symbol = coin.symbol else { continue }

            // Handle native token (empty address)
            if nativeCoins.contains(name),
               !existingTokenKeys.contains("\(id)-") {

                let token = Token(context: context)
                token.tokenId = id
                token.name = name
                token.symbol = symbol.uppercased()
                token.isEnabled = true
                token.address = ""
                token.balance = "0"
                token.decimals = 18
                token.type = getTokenTypeFromName(name)
                didUpdate = true

                // Associate token with wallets
                for wallet in allWallets {
                    let linkKey = "\(wallet.wallet_id ?? UUID())-\(id)-"
                    if !existingWalletTokenKeys.contains(linkKey) {
                        let walletToken = WalletTokens(context: context)
                        walletToken.id = UUID()
                        walletToken.wallet_id = wallet.wallet_id
                        walletToken.tokens = token
                        existingWalletTokenKeys.insert(linkKey)
                    }
                }
            }

            // Handle platform tokens
            if let platforms = coin.platforms {
                for (chain, address) in platforms where supportedChains.contains(chain) {
                    guard let address = address?.lowercased(),
                          !existingTokenKeys.contains("\(id)-\(address)") else { continue }

                    let token = Token(context: context)
                    token.tokenId = id
                    token.name = name
                    token.symbol = symbol.uppercased()
                    token.address = address
                    token.balance = "0"
                    token.decimals = 18
                    token.isEnabled = false
                    token.type = getTokenTypeFromPlatformKey(chain)
                    didUpdate = true

                    // Skip wallet-token link for disabled tokens
                }
            }
        }

        if didUpdate {
            do {
                try context.save()
                print("✅ New tokens and wallet-token links saved.")
            } catch {
                print("❌ Failed to save updates: \(error.localizedDescription)")
            }
        }

        completion()
    }


    func getTokenTypeFromPlatformKey(_ key: String) -> String {
        switch key {
        case "binance-smart-chain": return "BEP20"
        case "ethereum": return "ERC20"
        case "polygon-pos": return "POLYGON"
        case "okex-chain": return "KIP20"
        case "Bitcoin": return "BTC"
        case "optimistic-ethereum": return "OP Mainnet"
        case "arbitrum-one": return "Arbitrum"
        case "avalanche": return "Avalanche"
        case "base": return "Base"
        default: return ""
        }
    }

    func getTokenTypeFromName(_ name: String) -> String {
        switch name {
        case "OKT Chain": return "KIP20"
        case "Ethereum": return "ERC20"
        case "POL (ex-MATIC)": return "POLYGON"
        case "BNB": return "BEP20"
        case "Bitcoin": return "BTC"
        case "Optimism": return "OP Mainnet"
        case "Arbitrum": return "Arbitrum"
        case "Avalanche": return "Avalanche"
        case "Base": return "Base"
        default: return ""
        }
    }

    func getNewTokens() {
        self.btnUpdate.ShowLoader()
        viewModel.apiCoinList { status, _, coinList in
            if status, var coinListD = coinList {
                // Remove unwanted symbol
                coinListD.removeAll { $0.symbol?.lowercased() == "bnry" }

                // Call the global updater
                self.globallyUpdateTokensAndWallets(
                    from: coinListD,
                    nativeCoins: ["OKT Chain", "Ethereum", "POL (ex-MATIC)", "BNB","Bitcoin","Optimism","Arbitrum","Avalanche","Base"], // add any others
                    supportedChains: ["binance-smart-chain", "ethereum", "polygon-pos","okex-chain","bitcoin","optimistic-ethereum","arbitrum-one","avalanche","base"]
                ) {
                    print("✅ Global token update completed.")
                    UserDefaults.standard.set(appUpdatedFlagUpdate, forKey: appUpdatedFlagValue)
                    UserDefaults.standard.set(appUpdatedFlagUpdate, forKey: isFromAppUpdatedKey)
                    UserDefaults.standard.set("true", forKey: DefaultsKey.upadtedUser)
                    UserDefaults.standard.set("true", forKey: isFromAppUpdated)
                    
                    // Refresh UI after update
                    DispatchQueue.main.async {
                        self.btnUpdate.HideLoader()
                        
                        self.navigationController?.popViewController(animated: false)
//                        guard let appDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
//                        let tabBarVC = TabBarViewController(interactor: appDelegate.interactor, app: appDelegate.app, configurationService: appDelegate.app.configurationService)
//                        appDelegate.window?.rootViewController = tabBarVC
//                        appDelegate.window?.makeKeyAndVisible()
                    }

                }
            } else {
                self.btnUpdate.HideLoader()
                print("❌ Failed to fetch CoinGecko list")
            }
        }
    }
    
    // Add Custom Token
    fileprivate func addCustomPLTToken() {
        self.btnUpdate.ShowLoader()
        let context = DatabaseHelper.shared.context

        // Step 1: Update MATIC to POL globally
        DatabaseHelper.shared.updateData(
            entityName: "Token",
            predicateFormat: "symbol == %@ AND name == %@",
            predicateArgs: ["MATIC","Polygon"]
        ) { object in
            if let tokenToUpdate = object as? Token {
                tokenToUpdate.name = "POL (ex-MATIC)"
                tokenToUpdate.symbol = "POL".uppercased()
            }
        }

        // Step 2: Update MATIC to POL in all associated WalletTokens
        DatabaseHelper.shared.updateData(
            entityName: "WalletTokens",
            predicateFormat: "tokens.symbol == %@ AND tokens.name == %@",
            predicateArgs: ["MATIC","Polygon"]
        ) { object in
            if let walletToken = object as? WalletTokens, let token = walletToken.tokens {
                token.name = "POL (ex-MATIC)"
                token.symbol = "POL".uppercased()
            }
        }
        // Step 3: Add new PlutoPe Token (PLT)
        let newToken = TokenModel(
            tokenId: "plt",
            address: "0x1E3B5Ac35B153BB0A6F6C6d46F05712E102FE42E".lowercased(),
            name: "PlutoPe Token",
            symbol: "PLT".uppercased(),
            decimals: 18,
            logoURI: "https://plutope.app/api/images/applogo.png",
            type: "BEP20",
            balance: "0",
            price: "0.0",
            lastPriceChangeImpact: "0.0",
            isEnabled: true,
            isUserAdded: false
        )

        if let allWallets = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets] {
            let walletIDs = allWallets.compactMap { $0.wallet_id }
            print(walletIDs) // Prints all wallet UUIDs

            DatabaseHelper.shared.addOrUpdateTokenForWallets(tokenModel: newToken, walletIDs: walletIDs) {
                
                UserDefaults.standard.set(appUpdatedFlagUpdate, forKey: appUpdatedFlagValue)
                UserDefaults.standard.set(appUpdatedFlagUpdate, forKey: isFromAppUpdatedKey)
                UserDefaults.standard.set("true", forKey: DefaultsKey.upadtedUser)
                UserDefaults.standard.set("true", forKey: isFromAppUpdated)
                self.btnUpdate.HideLoader()
                // Refresh UI after update
                DispatchQueue.main.async {
                    guard let appDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
                    let tabBarVC = TabBarViewController(interactor: appDelegate.interactor, app: appDelegate.app, configurationService: appDelegate.app.configurationService)
                    appDelegate.window?.rootViewController = tabBarVC
                    appDelegate.window?.makeKeyAndVisible()
                }
            }
        }
    }

    @IBAction func btnUpdateAction(_ sender: Any) {
        HapticFeedback.generate(.light)
//        addCustomPLTToken()
        viewModel.checkTokenVersion { status, msg, data in
            let userTokenkey = UserDefaults.standard.value(forKey: DefaultsKey.tokenString) as? String ?? ""
           
            if status == 1 {
                if data?.isUpdate == true {
                    if data?.tokenString != userTokenkey {
                        print("update")
                            UserDefaults.standard.set(data?.tokenString, forKey: DefaultsKey.tokenString)

                            let userTokenkeyNew = UserDefaults.standard.value(forKey: DefaultsKey.tokenString) as? String ?? ""
                            print("NEwDataTokenkey",userTokenkeyNew)
//                        self.btnUpdate.HideLoader()
//                        
//                        self.navigationController?.popViewController(animated: false)
                        self.getNewTokens()
                    } else {
                        print("no deed to update Tokens")
                    }

                }
                
            } else {
                print("updateTokenApiError:\(msg)")
            }
        }
        
        
        
    }
    
    
    


}

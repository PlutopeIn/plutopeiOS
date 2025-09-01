//
//  WalletData.swift
//  Plutope
//
//  Created by Priyanka Poojara on 16/06/23.
//
import Foundation
import Security
import Web3
import PromiseKit
import DGNetworkingServices
import Web3ContractABI
import OrderedCollections
import CoreData
import CGWallet
// import TronWeb
struct MyWallet {
        let address: String
        let privateKey: String
    }
struct MyTronWallet {
        let address: String
        let privateKey: String
        let publicKey:String
    }
enum WalletParsingError: Error {
    case missingKey(String)
    case invalidValueType(String)
    case invalidJson
}

// MARK: WalletData
// swiftlint:disable type_body_length
class WalletData {
    
    static var shared = WalletData()
    //    lazy var tronWeb: TronWeb3 = {
    //        let tronweb = TronWeb3()
    //        return tronweb
    //    }()
    private init() {
        do {
            let mnemonic = UserDefaults.standard.string(forKey: DefaultsKey.mnemonic)
            myWallet = parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, chainETH, nil))
            walletBTC = parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, chainBTC, nil))
            
            // let dispatchGroup = DispatchGroup()
            //  dispatchGroup.enter()
            //               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //                   self.importAccountFromMnemonicAction(mnemonic: mnemonic ?? "") { [weak self] wallet in
            //                       guard let self = self else {
            //                          // dispatchGroup.leave()
            //                           return
            //                       }
            //                       self.walletTron = wallet
            //                       //dispatchGroup.leave()
            //                   }
            //               }
            
            //dispatchGroup.wait() // Wait for the asynchronous operation to complete
            
        } catch {
            // Handle the exception, log an error, or perform any necessary actions
            print("Error: \(error)")
            // Assign a default value or handle the error case accordingly
            myWallet = parseWalletJson(walletJson: CGWalletGenerateWallet("", "", nil))
            walletBTC = parseWalletJson(walletJson: CGWalletGenerateWallet("", "", nil))
            
        }
    }
    var myWallet: MyWallet?
    var walletBTC: MyWallet?
    var walletTron:MyTronWallet?
    var primaryCurrency: Currencies?
    let chainETH = "ETH"
    let chainBTC = "BTC"
    let chainTron = "TRON"
    var mnemonic = ""
    
    fileprivate func storeEnabledTokenInWallet(walletEntity: Wallets,completion: @escaping ((Bool) -> Void)) {
        let dispatchGroup = DispatchGroup()
        let enabledToken = (DatabaseHelper.shared.retrieveData("Token") as? [Token])?.filter({ $0.isEnabled })
        for tokens in (enabledToken ?? []) {
            dispatchGroup.enter()
            let entity = NSEntityDescription.entity(forEntityName: "WalletTokens", in: DatabaseHelper.shared.context)!
            let walletTokenEntity = WalletTokens(entity: entity, insertInto: DatabaseHelper.shared.context)
            walletTokenEntity.id = UUID()
            walletTokenEntity.wallet_id = walletEntity.wallet_id
            walletTokenEntity.tokens = tokens
            DatabaseHelper.shared.saveData(walletTokenEntity) { status in
                if status {
                    dispatchGroup.leave()
                } else {
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(true)
        }
        
    }
    
    func getPrivateKeyData(coinType: CoinType) -> String {
        if coinType == .bitcoin {
            return walletBTC?.privateKey ?? ""
        }
        //else if coinType == .tron {
        //   return walletTron?.privateKey ?? ""
        //  }
        else {
            return myWallet?.privateKey ?? ""
        }
        //        return coinType == .bitcoin ? walletBTC?.privateKey : myWallet?.privateKey
    }
    func getPublicWalletAddress(coinType: CoinType) -> String? {
        //        if coinType == .bitcoin {
        //            return walletBTC?.address ?? ""
        //        } else if coinType == .tron {
        //            return walletTron?.address ?? ""
        //        } else {
        //            return myWallet?.address ?? ""
        //        }
        return coinType == .bitcoin ? walletBTC?.address : myWallet?.address
    }
    
    func getBitcoinAddress() -> String? {
        return walletBTC?.address
    }
    func getTronAddress() -> String? {
        return walletTron?.address
    }
    func parseWalletJson(walletJson: String) -> MyWallet? {
        guard let jsonData = walletJson.data(using: .utf8) else {
            return nil
        }
        
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
               let address = jsonObject["address"] as? String,
               let privateKey = jsonObject["privateKey"] as? String {
                return MyWallet(address: address, privateKey: privateKey)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    /// Create Wallet
//    func createWallet(walletName: String?, mnemonicKey: String?, isPrimary: Bool?, isICloudBackup: Bool?,isManualBackup: Bool?, coinList: [CoingechoCoinList]?, iCloudFileName: String? = "",alreadyAddStaticToken : Bool?, completion: @escaping (Bool) -> Void) {
//        guard let mnemonic = mnemonicKey else {
//            completion(false)
//            return
//        }
//        
//        myWallet = parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, chainETH, nil))
//        walletBTC = parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, chainBTC, nil))
//        //        importAccountFromMnemonic(mnemonic: mnemonic) { _ in
//        //
//        //        }
//        self.mnemonic = mnemonic
//        //  wallet = HDWallet(mnemonic: mnemonic, passphrase: "")
//        UserDefaults.standard.set(mnemonic, forKey: DefaultsKey.mnemonic)
//        
//        //        guard let wallet = wallet else {
//        //            completion(false)
//        //            return
//        //        }
//        guard let wallet = myWallet else {
//            completion(false)
//            return
//        }
//        guard let walletbtc = walletBTC else {
//            completion(false)
//            return
//        }
//        //        guard let wallettron = walletTron else {
//        //            completion(false)
//        //            return
//        //        }
//        
//        // Update isPrimary flag for existing wallets if needed
//        
//        updateExistingWalletsPrimaryFlag()
//        print("walletCreation ")
//        // Create a new wallet entity
//        let entity = NSEntityDescription.entity(forEntityName: "Wallets", in: DatabaseHelper.shared.context)!
//        let walletEntity = Wallets(entity: entity, insertInto: DatabaseHelper.shared.context)
//        walletEntity.wallet_id = UUID()
//        walletEntity.isPrimary = isPrimary ?? false
//        walletEntity.mnemonic = mnemonic
//        walletEntity.fileName = iCloudFileName ?? ""
//        walletEntity.wallet_name = walletName
//        walletEntity.isCloudBackup = isICloudBackup ?? false
//        walletEntity.isManualBackup = isManualBackup ?? false
//        
//        // Save the new wallet entity to the database
//        DatabaseHelper.shared.saveData(walletEntity) { _ in
//            let data = Data(from: mnemonic)
//            let _ = KeyChain.save(key: "mnemonicKey", data: data)
//
//            let dispatchGroup = DispatchGroup()
//            
//                // Add static token PLT
//                dispatchGroup.enter()
//            if alreadyAddStaticToken == false {
//                self.addStaticTokenPLT(for: walletEntity) {
//                    dispatchGroup.leave()
//                }
//            } else {
//                dispatchGroup.leave()
//            }
//            
//            // Process coin list
//            dispatchGroup.notify(queue: .main) {
//                self.processCoinList(coinList, for: walletEntity) { status in
//                    completion(status)
//                }
//            }
//        }
//    }
    func createWallet(
        walletName: String?,
        mnemonicKey: String?,
        isPrimary: Bool?,
        isICloudBackup: Bool?,
        isManualBackup: Bool?,
        coinList: [CoingechoCoinList]?,
        iCloudFileName: String? = "",
        alreadyAddStaticToken: Bool?,
        completion: @escaping (Bool) -> Void
    ) {
        guard let mnemonic = mnemonicKey else {
            completion(false)
            return
        }

        // Check if wallet already exists
        let context = DatabaseHelper.shared.context
        let fetchRequest: NSFetchRequest<Wallets> = Wallets.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mnemonic == %@", mnemonic)

        if let existingWallet = try? context.fetch(fetchRequest).first {
            print("⚠️ Wallet already exists with same mnemonic")
            completion(true)
            return
        }

        myWallet = parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, chainETH, nil))
        walletBTC = parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, chainBTC, nil))
        self.mnemonic = mnemonic

        guard let wallet = myWallet, let walletbtc = walletBTC else {
            completion(false)
            return
        }

        // Save mnemonic to UserDefaults
        UserDefaults.standard.set(mnemonic, forKey: DefaultsKey.mnemonic)

        // Update primary flags
        updateExistingWalletsPrimaryFlag()

        // Create wallet entity
        let entity = NSEntityDescription.entity(forEntityName: "Wallets", in: context)!
        let walletEntity = Wallets(entity: entity, insertInto: context)
        walletEntity.wallet_id = UUID()
        walletEntity.isPrimary = isPrimary ?? false
        walletEntity.mnemonic = mnemonic
        walletEntity.fileName = iCloudFileName ?? ""
        walletEntity.wallet_name = walletName
        walletEntity.isCloudBackup = isICloudBackup ?? false
        walletEntity.isManualBackup = isManualBackup ?? false

        DatabaseHelper.shared.saveData(walletEntity) { _ in
            // Save to Keychain
            let data = Data(from: mnemonic)
            _ = KeyChain.save(key: "mnemonicKey", data: data)

            let dispatchGroup = DispatchGroup()

            // Add static token PLT
            dispatchGroup.enter()
            if alreadyAddStaticToken == false {
                self.addStaticTokenPLT(for: walletEntity) {
                    dispatchGroup.leave()
                }
            } else {
                dispatchGroup.leave()
            }

            // Process CoinGecko coins
            dispatchGroup.notify(queue: .main) {
                self.processCoinList(coinList, for: walletEntity) { status in
                    completion(status)
                }
            }
        }
    }

    fileprivate func setNativeChains(_ nativeCoins: [String], _ name: String, _ id: String, _ symbol: String) {
        if nativeCoins.contains(name) {
            let entity = NSEntityDescription.entity(forEntityName: "Token", in: DatabaseHelper.shared.context)!
            let tokenEntity = Token(entity: entity, insertInto: DatabaseHelper.shared.context)
            tokenEntity.tokenId = id
            tokenEntity.name = name
            // tokenEntity.name = (name == "Optimism") ? "OP Mainnet" : name
            //            if name == "Optimism" {
            //                tokenEntity.symbol = "ETH"
            //            } else {
            //                tokenEntity.symbol = symbol.uppercased()
            //            }
            tokenEntity.symbol = symbol.uppercased()
            tokenEntity.isEnabled = true
            tokenEntity.address = ""
            tokenEntity.balance = "0"
            tokenEntity.decimals = 18
            
            switch name {
            case "OKT Chain":
                tokenEntity.type = "KIP20"
            case "Ethereum":
                tokenEntity.type = "ERC20"
            case "POL (ex-MATIC)":
                tokenEntity.type = "POLYGON"
            case "BNB":
                tokenEntity.type = "BEP20"
            case "Bitcoin":
                tokenEntity.type = "BTC"
            case "Optimism":
                tokenEntity.type = "OP Mainnet"
            case "Arbitrum":
                tokenEntity.type = "Arbitrum"
            case "Avalanche":
                tokenEntity.type = "Avalanche"
            case "Base":
                tokenEntity.type = "Base"
                //            case "TRON":
                //                tokenEntity.type = "TRC20"
                //            case "Solana":
                //                tokenEntity.type = "SPL"
            default:
                break
            }
        }
    }

    fileprivate func addStaticTokenPLT(for walletEntity: Wallets, completion: @escaping () -> Void) {
        let entity = NSEntityDescription.entity(forEntityName: "Token", in: DatabaseHelper.shared.context)!
        let tokenEntity = Token(entity: entity, insertInto: DatabaseHelper.shared.context)
        
        tokenEntity.tokenId = "plt" // Use the actual unique ID for PLT
        tokenEntity.name = "PlutoPe Token"
        tokenEntity.symbol = "PLT".uppercased()
        tokenEntity.isEnabled = true
        tokenEntity.address = "0x1E3B5Ac35B153BB0A6F6C6d46F05712E102FE42E".lowercased()
        tokenEntity.balance = "0"
        tokenEntity.decimals = 18
        tokenEntity.type = "BEP20" // Or other appropriate type
        
        DatabaseHelper.shared.saveData(tokenEntity) { status in
            if status {
                print("PLT token added successfully.")
            } else {
                print("Failed to add PLT token.")
            }
            completion()
        }
    }
    
    fileprivate func checkEmptyCoin(_ coinList: [CoingechoCoinList]?, _ nativeCoins: [String], _ supportedChains: [String]) {
        for coin in (coinList ?? []) {
            if let name = coin.name, let symbol = coin.symbol, let id = coin.id {
                setNativeChains(nativeCoins, name, id, symbol)
                
                if let platforms = coin.platforms {
                    for platform in platforms {
                        if supportedChains.contains(platform.key) {
                            let entity = NSEntityDescription.entity(forEntityName: "Token", in: DatabaseHelper.shared.context)!
                            let tokenEntity = Token(entity: entity, insertInto: DatabaseHelper.shared.context)
                            tokenEntity.tokenId = id
                            
                            tokenEntity.name = name
                            tokenEntity.symbol = symbol.uppercased()
                            tokenEntity.isEnabled = false // Always set isEnabled to false for platform tokens
                            tokenEntity.address = platform.value
                            tokenEntity.balance = "0"
                            tokenEntity.decimals = 18
                            
                            switch platform.key {
                            case "binance-smart-chain":
                                tokenEntity.type = "BEP20"
                            case "ethereum":
                                tokenEntity.type = "ERC20"
                            case "polygon-pos":
                                tokenEntity.type = "POLYGON"
                            case "okex-chain":
                                tokenEntity.type = "KIP20"
                            case "Bitcoin":
                                tokenEntity.type = "BTC"
                            case "optimistic-ethereum":
                                tokenEntity.type = "OP Mainnet"
                            case "arbitrum-one":
                                tokenEntity.type = "Arbitrum"
                            case "avalanche":
                                tokenEntity.type = "Avalanche"
                            case "base":
                                tokenEntity.type = "Base"
                                //                            case "TRON":
                                //                                tokenEntity.type = "TRC20"
                                //                            case "Solana":
                                //                                tokenEntity.type = "SPL"
                            default:
                                break
                            }  }  }  } }
        }
    }
    fileprivate func checkCoinList(_ coinList: [CoingechoCoinList]?, _ nativeCoins: [String], _ supportedChains: [String]) {
        checkEmptyCoin(coinList, nativeCoins, supportedChains)
    }
    
    func processCoinList(_ coinList: [CoingechoCoinList]?, for walletEntity: Wallets, completion: @escaping (Bool) -> Void) {
        
        // Process coin list and store tokens in the wallet
        //        let supportedChains = ["binance-smart-chain", "ethereum", "polygon-pos","okex-chain","bitcoin","optimistic-ethereum","arbitrum-one","avalanche","tron",]
        //        let nativeCoins = ["OKT Chain", "Ethereum", "Polygon", "BNB","Bitcoin","Optimism","Arbitrum","Avalanche","Tron"]
        //        let supportedChains = ["binance-smart-chain", "ethereum", "polygon-pos","okex-chain","bitcoin","arbitrum-one","avalanche","Tron","solana"]
        //        let nativeCoins = ["OKT Chain", "Ethereum", "Polygon", "BNB","Bitcoin","Arbitrum","Avalanche","Tron","Solana"]
        let supportedChains = ["binance-smart-chain", "ethereum", "polygon-pos","okex-chain","bitcoin","optimistic-ethereum","arbitrum-one","avalanche","base"]
        let nativeCoins = ["OKT Chain", "Ethereum", "POL (ex-MATIC)", "BNB","Bitcoin","Optimism","Arbitrum","Avalanche","Base"]
        
        self.checkCoinList(coinList, nativeCoins, supportedChains)
        storeEnabledTokenInWallet(walletEntity: walletEntity) { status in
            completion(status)
        }
    }
    
    func updateExistingWalletsPrimaryFlag() {
        if !DatabaseHelper.shared.entityIsEmpty("Wallets") {
            guard let wallets = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets] else {
                return
            }
            wallets.forEach { $0.isPrimary = false }
        }
    }
    func formatDecimalString(_ stringValue: String, decimalPlaces: Int) -> String {
        // Convert the string to an NSDecimalNumber
        let decimalNumber = NSDecimalNumber(string: stringValue)
        
        // Truncate to the desired number of decimal places
        let truncatedNumber = decimalNumber.rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: .down, scale: Int16(decimalPlaces), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
        
        // Create a NumberFormatter to format the NSDecimalNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = decimalPlaces
        
        // Use the NumberFormatter to convert the NSDecimalNumber back to a formatted string
        if let formattedString = numberFormatter.string(from: truncatedNumber) {
            return formattedString
            // return formattedString
        } else {
            return "Error formatting NSDecimalNumber to string"
        }
    }
}
//    func importAccountFromMnemonicAction(mnemonic: String, completion: @escaping (MyTronWallet?) -> Void) {
//            if tronWeb.isGenerateTronWebInstanceSuccess != true {
//                tronWeb.setup(privateKey: "01", node: TRONMainNet) { [weak self] setupResult, error in
//                    guard let self = self else { return }
//                    if setupResult {
//                        self.importAccountFromMnemonic(mnemonic: mnemonic, completion: completion)
//                    } else {
//                        print(error)
//                        completion(nil)
//                    }
//                }
//            } else {
//                importAccountFromMnemonic(mnemonic: mnemonic, completion: completion)
//            }
//        }
//        
//        func importAccountFromMnemonic(mnemonic: String, completion: @escaping (MyTronWallet?) -> Void) {
//            tronWeb.importAccountFromMnemonic(mnemonic: mnemonic) { state, address, privateKey, publicKey, error in
//                if state {
//                    let wallet = MyTronWallet(address: address, privateKey: privateKey, publicKey: publicKey)
//                    completion(wallet)
//                } else {
//                    print(error)
//                    completion(nil)
//                }
//            }
//        }
//}
// swiftlint:enable type_body_length
class KeyChain {
    
    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String      : kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String  : data ] as [String: Any]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String      : kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String : kCFBooleanTrue ?? "",
            kSecMatchLimit as String : kSecMatchLimitOne ] as [String: Any]
        
        var dataTypeRef: AnyObject?
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
    
    class func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)
        
        let swiftString: String = cfStr as String
        return swiftString
    }
}

extension Data {
    
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee  }
    }
}
extension String {
    func toHexString() -> String {
        return self.utf8.map { String(format: "%02hhx", $0) }.joined()
    }
}

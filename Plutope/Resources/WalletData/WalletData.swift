//
//  WalletData.swift
//  Plutope
//
//  Created by Priyanka Poojara on 16/06/23.
//
import Foundation
//import WalletCore
import Security
import Web3
import PromiseKit
import DGNetworkingServices
import Web3ContractABI
import OrderedCollections
import CoreData
import CGWallet

struct MyWallet {
        let address: String
        let privateKey: String
    }

enum WalletParsingError: Error {
    case missingKey(String)
    case invalidValueType(String)
    case invalidJson
}
// MARK: WalletData
class WalletData {
    
    static var shared = WalletData()
    //var wallet: HDWallet?
    // let coinTypes = Chain.ethereum.coinType
    
    // Now you can use coinType as needed
    private init() {
        do {
            let mnemonic = UserDefaults.standard.string(forKey: DefaultsKey.mnemonic)
            myWallet = parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, chainETH, nil))
          //  print("MYWAllet",myWallet)
            walletBTC = parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, chainBTC, nil))
          //  print("MYBTCWAllet",walletBTC)
        } catch {
            // Handle the exception, log an error, or perform any necessary actions
            print("Error: \(error)")
            // Assign a default value or handle the error case accordingly
            myWallet = parseWalletJson(walletJson: CGWalletGenerateWallet("", "", nil))
            
        }
    }
    var myWallet: MyWallet?
    var walletBTC: MyWallet?
    var primaryCurrency: Currencies?
    let chainETH = "ETH"
    let chainBTC = "BTC"
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
        return coinType == .bitcoin ? walletBTC?.privateKey ?? "" : myWallet?.privateKey ?? ""
    }
    func getPublicWalletAddress(coinType: CoinType) -> String? {
        
        return coinType == .bitcoin ? walletBTC?.address : myWallet?.address
    }
    func getBitcoinAddress() -> String? {
        return walletBTC?.address
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
    func createWallet(walletName: String?, mnemonicKey: String?, isPrimary: Bool?, isICloudBackup: Bool?,isManualBackup: Bool?, coinList: [CoingechoCoinList]?, iCloudFileName: String? = "", completion: @escaping (Bool) -> Void) {
        guard let mnemonic = mnemonicKey else {
            completion(false)
            return
        }
        
        myWallet = parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, chainETH, nil))
        walletBTC = parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, chainBTC, nil))
        self.mnemonic = mnemonic
        //  wallet = HDWallet(mnemonic: mnemonic, passphrase: "")
        UserDefaults.standard.set(mnemonic, forKey: DefaultsKey.mnemonic)
        
        //        guard let wallet = wallet else {
        //            completion(false)
        //            return
        //        }
        guard let wallet = myWallet else {
            completion(false)
            return
        }
        guard let walletbtc = walletBTC else {
            completion(false)
            return
        }
        
        // Update isPrimary flag for existing wallets if needed
        
        updateExistingWalletsPrimaryFlag()
        // Create a new wallet entity
        let entity = NSEntityDescription.entity(forEntityName: "Wallets", in: DatabaseHelper.shared.context)!
        let walletEntity = Wallets(entity: entity, insertInto: DatabaseHelper.shared.context)
        walletEntity.wallet_id = UUID()
        walletEntity.isPrimary = isPrimary ?? false
        walletEntity.mnemonic = mnemonic
        walletEntity.fileName = iCloudFileName ?? ""
        walletEntity.wallet_name = walletName
        walletEntity.isCloudBackup = isICloudBackup ?? false
        walletEntity.isManualBackup = isManualBackup ?? false
        
        // Save the new wallet entity to the database
        DatabaseHelper.shared.saveData(walletEntity, completion: { _ in
            let data = Data(from: mnemonic)
            let _ = KeyChain.save(key: "mnemonicKey", data: data)
            self.processCoinList(coinList, for: walletEntity) { status in
                completion(status)
            }
        })
    }
    
    fileprivate func checkEmptyCoin(_ coinList: [CoingechoCoinList]?, _ nativeCoins: [String], _ supportedChains: [String]) {
        for coin in (coinList ?? []) {
            if let name = coin.name, let symbol = coin.symbol, let id = coin.id {
                if nativeCoins.contains(name) {
                    let entity = NSEntityDescription.entity(forEntityName: "Token", in: DatabaseHelper.shared.context)!
                    let tokenEntity = Token(entity: entity, insertInto: DatabaseHelper.shared.context)
                    tokenEntity.tokenId = id
                    tokenEntity.name = name
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
                    case "Polygon":
                        tokenEntity.type = "POLYGON"
                    case "BNB":
                        tokenEntity.type = "BEP20"
                    case "Bitcoin":
                        tokenEntity.type = "BTC"
                    default:
                        break
                    }
                    //                        continue
                }
                
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
                            default:
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func checkCoinList(_ coinList: [CoingechoCoinList]?, _ nativeCoins: [String], _ supportedChains: [String]) {
            checkEmptyCoin(coinList, nativeCoins, supportedChains)
    }
    
    func processCoinList(_ coinList: [CoingechoCoinList]?, for walletEntity: Wallets, completion: @escaping (Bool) -> Void) {
        
        // Process coin list and store tokens in the wallet
        let supportedChains = ["binance-smart-chain", "ethereum", "polygon-pos", "okex-chain","bitcoin"]
        let nativeCoins = ["OKT Chain", "Ethereum", "Polygon", "BNB","Bitcoin"]
        
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

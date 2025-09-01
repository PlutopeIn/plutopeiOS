////
////  WalletData.swift
////  Plutope
////
////  Created by Priyanka Poojara on 16/06/23.
////
//import Foundation
//import Security
//import Web3
//import PromiseKit
//import DGNetworkingServices
//import Web3ContractABI
//import OrderedCollections
//import CoreData
//import CGWallet
//// import TronWeb
//struct MyWallet {
//        let address: String
//        let privateKey: String
//    }
//struct MyTronWallet {
//        let address: String
//        let privateKey: String
//        let publicKey:String
//    }
//enum WalletParsingError: Error {
//    case missingKey(String)
//    case invalidValueType(String)
//    case invalidJson
//}
//
//// MARK: WalletData
//// swiftlint:disable type_body_length
//class UpdatedWalletData {
//    
//    static var shared = UpdatedWalletData()
////    lazy var tronWeb: TronWeb3 = {
////        let tronweb = TronWeb3()
////        return tronweb
////    }()
//    private init() {
//           do {
//               let mnemonic = UserDefaults.standard.string(forKey: DefaultsKey.mnemonic)
//               myWallet = parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, chainETH, nil))
//               walletBTC = parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, chainBTC, nil))
//               
//              // let dispatchGroup = DispatchGroup()
//             //  dispatchGroup.enter()
////               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
////                   self.importAccountFromMnemonicAction(mnemonic: mnemonic ?? "") { [weak self] wallet in
////                       guard let self = self else {
////                          // dispatchGroup.leave()
////                           return
////                       }
////                       self.walletTron = wallet
////                       //dispatchGroup.leave()
////                   }
////               }
//
//               //dispatchGroup.wait() // Wait for the asynchronous operation to complete
//               
//           } catch {
//               // Handle the exception, log an error, or perform any necessary actions
//               print("Error: \(error)")
//               // Assign a default value or handle the error case accordingly
//               myWallet = parseWalletJson(walletJson: CGWalletGenerateWallet("", "", nil))
//               walletBTC = parseWalletJson(walletJson: CGWalletGenerateWallet("", "", nil))
//              
//           }
//       }
//    var myWallet: MyWallet?
//    var walletBTC: MyWallet?
//    var walletTron:MyTronWallet?
//    var primaryCurrency: Currencies?
//    let chainETH = "ETH"
//    let chainBTC = "BTC"
//    let chainTron = "TRON"
//    var mnemonic = ""
//   
//    fileprivate func storeEnabledTokenInWallet(walletEntity: Wallets,completion: @escaping ((Bool) -> Void)) {
//        let dispatchGroup = DispatchGroup()
//        let enabledToken = (DatabaseHelper.shared.retrieveData("Token") as? [Token])?.filter({ $0.isEnabled })
//        for tokens in (enabledToken ?? []) {
//            dispatchGroup.enter()
//            let entity = NSEntityDescription.entity(forEntityName: "WalletTokens", in: DatabaseHelper.shared.context)!
//            let walletTokenEntity = WalletTokens(entity: entity, insertInto: DatabaseHelper.shared.context)
//            walletTokenEntity.id = UUID()
//            walletTokenEntity.wallet_id = walletEntity.wallet_id
//            walletTokenEntity.tokens = tokens
//            DatabaseHelper.shared.saveData(walletTokenEntity) { status in
//                if status {
//                    dispatchGroup.leave()
//                } else {
//                    dispatchGroup.leave()
//                }
//            }
//        }
//        dispatchGroup.notify(queue: .main) {
//            completion(true)
//        }
//       
//    }
//    
//    func getPrivateKeyData(coinType: CoinType) -> String {
//        if coinType == .bitcoin {
//            return walletBTC?.privateKey ?? ""
//        } 
//        //else if coinType == .tron {
//         //   return walletTron?.privateKey ?? ""
//      //  } 
//    else {
//            return myWallet?.privateKey ?? ""
//        }
////        return coinType == .bitcoin ? walletBTC?.privateKey : myWallet?.privateKey
//    }
//    func getPublicWalletAddress(coinType: CoinType) -> String? {
////        if coinType == .bitcoin {
////            return walletBTC?.address ?? ""
////        } else if coinType == .tron {
////            return walletTron?.address ?? ""
////        } else {
////            return myWallet?.address ?? ""
////        }
//        return coinType == .bitcoin ? walletBTC?.address : myWallet?.address
//    }
//    
//    func getBitcoinAddress() -> String? {
//        return walletBTC?.address
//    }
//    func getTronAddress() -> String? {
//        return walletTron?.address
//    }
//    func parseWalletJson(walletJson: String) -> MyWallet? {
//        guard let jsonData = walletJson.data(using: .utf8) else {
//            return nil
//        }
//        
//        do {
//            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
//               let address = jsonObject["address"] as? String,
//               let privateKey = jsonObject["privateKey"] as? String {
//                return MyWallet(address: address, privateKey: privateKey)
//            } else {
//                return nil
//            }
//        } catch {
//            return nil
//        }
//    }
//    /// update Wallet
//    func updateWallets(walletName: UUID?, mnemonicKey: String?, isPrimary: Bool?, isICloudBackup: Bool?,isManualBackup: Bool?, coinList: [CoingechoCoinList]?, iCloudFileName: String? = "", completion: @escaping (Bool) -> Void) {
//        guard let mnemonic = mnemonicKey else {
//            completion(false)
//            return
//        }
//        
//        myWallet = parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, chainETH, nil))
//        walletBTC = parseWalletJson(walletJson: CGWalletGenerateWallet(mnemonic, chainBTC, nil))
//        self.mnemonic = mnemonic
//        //  wallet = HDWallet(mnemonic: mnemonic, passphrase: "")
//        UserDefaults.standard.set(mnemonic, forKey: DefaultsKey.mnemonic)
//        guard let wallet = myWallet else {
//            completion(false)
//            return
//        }
//        guard let walletbtc = walletBTC else {
//            completion(false)
//            return
//        }
//        
//        updateExistingWalletsPrimaryFlag()
//        let data = Data(from: mnemonic)
//        let _ = KeyChain.save(key: "mnemonicKey", data: data)
//      
//        if let walletEntity = DatabaseHelper.shared.fetchExistingWalletEntity(walletID: walletName ?? UUID()) {
//            self.processCoinList(coinList, for: walletEntity) { status in
//                completion(status)
//            }
////            self.updateProcessCoinList(coinList, for: walletEntity) { status in
////                completion(status)
////            }
//        } else {
//            print("Wallet entity not found.")
//        }
//    }
//
//    fileprivate func setNativeChains(_ nativeCoins: [String], _ name: String, _ id: String, _ symbol: String) {
//        if nativeCoins.contains(name) {
//            // Check if token already exists in the database
//            let fetchRequest: NSFetchRequest<Token> = Token.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "tokenId == %@", id)
//            
//            do {
//                let existingTokens = try DatabaseHelper.shared.context.fetch(fetchRequest)
//                
//                let tokenEntity: Token
//                if let existingToken = existingTokens.first {
//                    // Token exists, update the existing entity
//                    tokenEntity = existingToken
//                    print("Updating existing token: \(name)")
//                } else {
//                    // Token doesn't exist, create a new one
//                    let entity = NSEntityDescription.entity(forEntityName: "Token", in: DatabaseHelper.shared.context)!
//                    tokenEntity = Token(entity: entity, insertInto: DatabaseHelper.shared.context)
//                    tokenEntity.tokenId = id
//                    tokenEntity.balance = "0"  // Default balance for new token
//                    print("Creating new token: \(name)")
//                }
//                
//                // Update common properties for both new and existing tokens
//                tokenEntity.name = name
//                tokenEntity.symbol = (name == "Optimism") ? "ETH" : symbol.uppercased()
//                tokenEntity.isEnabled = true
//                tokenEntity.address = ""  // Default empty address
//                tokenEntity.decimals = 18
//                
//                // Update token type based on the chain name
//                switch name {
//                case "OKT Chain":
//                    tokenEntity.type = "KIP20"
//                case "Ethereum":
//                    tokenEntity.type = "ERC20"
//                case "Polygon":
//                    tokenEntity.type = "POLYGON"
//                case "BNB":
//                    tokenEntity.type = "BEP20"
//                case "Bitcoin":
//                    tokenEntity.type = "BTC"
//                case "Optimism":
//                    tokenEntity.type = "OP Mainnet"
//                case "Arbitrum":
//                    tokenEntity.type = "Arbitrum"
//                case "Avalanche":
//                    tokenEntity.type = "Avalanche"
//                case "Base":
//                    tokenEntity.type = "Base"
//                default:
//                    tokenEntity.type = "Unknown"
//                }
//                
//                // Save changes to the database
//                DatabaseHelper.shared.saveData(tokenEntity)
//                
//            } catch {
//                print("Error fetching or updating token: \(error)")
//            }
//        }
//    }
//
//    
//    fileprivate func checkEmptyCoin(_ coinList: [CoingechoCoinList]?, _ nativeCoins: [String], _ supportedChains: [String]) {
//        for coin in (coinList ?? []) {
//            if let name = coin.name, let symbol = coin.symbol, let id = coin.id {
//                // Call setNativeChains to handle native chain tokens
//                setNativeChains(nativeCoins, name, id, symbol)
//                
//                // Iterate over platforms and handle each platform-specific token
//                if let platforms = coin.platforms {
//                    for platform in platforms {
//                        if supportedChains.contains(platform.key) {
//                            
//                            // Check if the token for the specific platform already exists
//                            let fetchRequest: NSFetchRequest<Token> = Token.fetchRequest()
//                            fetchRequest.predicate = NSPredicate(format: "tokenId == %@ AND address == %@", id, platform.value)
//                            
//                            do {
//                                let existingTokens = try DatabaseHelper.shared.context.fetch(fetchRequest)
//                                
//                                let tokenEntity: Token
//                                if let existingToken = existingTokens.first {
//                                    // Token already exists for this platform, update it
//                                    tokenEntity = existingToken
//                                    print("Updating existing token for platform: \(platform.key)")
//                                } else {
//                                    // Token doesn't exist, create a new one
//                                    let entity = NSEntityDescription.entity(forEntityName: "Token", in: DatabaseHelper.shared.context)!
//                                    tokenEntity = Token(entity: entity, insertInto: DatabaseHelper.shared.context)
//                                    tokenEntity.tokenId = id
//                                    tokenEntity.balance = "0"  // Default balance for new token
//                                    tokenEntity.address = platform.value  // Set platform address
//                                    print("Creating new token for platform: \(platform.key)")
//                                }
//                                
//                                // Set token common properties
//                                tokenEntity.name = name
//                                tokenEntity.symbol = symbol.uppercased()
//                                tokenEntity.isEnabled = false  // Always set isEnabled to false for platform tokens
//                                tokenEntity.decimals = 18  // Default decimals, adjust as needed
//
//                                // Set token type based on the platform key
//                                switch platform.key {
//                                case "binance-smart-chain":
//                                    tokenEntity.type = "BEP20"
//                                case "ethereum":
//                                    tokenEntity.type = "ERC20"
//                                case "polygon-pos":
//                                    tokenEntity.type = "POLYGON"
//                                case "okex-chain":
//                                    tokenEntity.type = "KIP20"
//                                case "Bitcoin":
//                                    tokenEntity.type = "BTC"
//                                case "optimistic-ethereum":
//                                    tokenEntity.type = "OP Mainnet"
//                                case "arbitrum-one":
//                                    tokenEntity.type = "Arbitrum"
//                                case "avalanche":
//                                    tokenEntity.type = "Avalanche"
//                                case "base":
//                                    tokenEntity.type = "Base"
//    //                            case "TRON":
//    //                                tokenEntity.type = "TRC20"
//    //                            case "Solana":
//    //                                tokenEntity.type = "SPL"
//                                default:
//                                    tokenEntity.type = "Unknown"  // Default type for unsupported platforms
//                                }
//                                
//                                // Save changes to the database
//                                DatabaseHelper.shared.saveData(tokenEntity)
//                                
//                            } catch {
//                                print("Error fetching or updating token: \(error)")
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//        fileprivate func checkCoinList(_ coinList: [CoingechoCoinList]?, _ nativeCoins: [String], _ supportedChains: [String]) {
//            checkEmptyCoin(coinList, nativeCoins, supportedChains)
//    }
//    
//    func processCoinList(_ coinList: [CoingechoCoinList]?, for walletEntity: Wallets, completion: @escaping (Bool) -> Void) {
//        
//        let supportedChains = ["binance-smart-chain", "ethereum", "polygon-pos","okex-chain","bitcoin","optimistic-ethereum","arbitrum-one","avalanche","base"]
//        let nativeCoins = ["OKT Chain", "Ethereum", "Polygon", "BNB","Bitcoin","Optimism","Arbitrum","Avalanche","Base"]
//        
//        self.checkCoinList(coinList, nativeCoins, supportedChains)
//        storeEnabledTokenInWallet(walletEntity: walletEntity) { status in
//            completion(status)
//        }
//    }
//
//  
//    func updateExistingWalletsPrimaryFlag() {
//        if !DatabaseHelper.shared.entityIsEmpty("Wallets") {
//            guard let wallets = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets] else {
//                return
//            }
//            wallets.forEach { $0.isPrimary = false }
//        }
//    }
//    func formatDecimalString(_ stringValue: String, decimalPlaces: Int) -> String {
//        // Convert the string to an NSDecimalNumber
//        let decimalNumber = NSDecimalNumber(string: stringValue)
//        
//        // Truncate to the desired number of decimal places
//        let truncatedNumber = decimalNumber.rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: .down, scale: Int16(decimalPlaces), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
//
//        // Create a NumberFormatter to format the NSDecimalNumber
//        let numberFormatter = NumberFormatter()
//        numberFormatter.minimumFractionDigits = 0
//        numberFormatter.maximumFractionDigits = decimalPlaces
//
//        // Use the NumberFormatter to convert the NSDecimalNumber back to a formatted string
//        if let formattedString = numberFormatter.string(from: truncatedNumber) {
//                    return formattedString
//            // return formattedString
//        } else {
//            return "Error formatting NSDecimalNumber to string"
//        }
//    }
////    func importAccountFromMnemonicAction(mnemonic: String, completion: @escaping (MyTronWallet?) -> Void) {
////            if tronWeb.isGenerateTronWebInstanceSuccess != true {
////                tronWeb.setup(privateKey: "01", node: TRONMainNet) { [weak self] setupResult, error in
////                    guard let self = self else { return }
////                    if setupResult {
////                        self.importAccountFromMnemonic(mnemonic: mnemonic, completion: completion)
////                    } else {
////                        print(error)
////                        completion(nil)
////                    }
////                }
////            } else {
////                importAccountFromMnemonic(mnemonic: mnemonic, completion: completion)
////            }
////        }
////        
////        func importAccountFromMnemonic(mnemonic: String, completion: @escaping (MyTronWallet?) -> Void) {
////            tronWeb.importAccountFromMnemonic(mnemonic: mnemonic) { state, address, privateKey, publicKey, error in
////                if state {
////                    let wallet = MyTronWallet(address: address, privateKey: privateKey, publicKey: publicKey)
////                    completion(wallet)
////                } else {
////                    print(error)
////                    completion(nil)
////                }
////            }
////        }
//}
//// swiftlint:enable type_body_length
//class KeyChain {
//    
//    class func save(key: String, data: Data) -> OSStatus {
//        let query = [
//            kSecClass as String      : kSecClassGenericPassword as String,
//            kSecAttrAccount as String: key,
//            kSecValueData as String  : data ] as [String: Any]
//        
//        SecItemDelete(query as CFDictionary)
//        
//        return SecItemAdd(query as CFDictionary, nil)
//    }
//    
//    class func load(key: String) -> Data? {
//        let query = [
//            kSecClass as String      : kSecClassGenericPassword,
//            kSecAttrAccount as String: key,
//            kSecReturnData as String : kCFBooleanTrue ?? "",
//            kSecMatchLimit as String : kSecMatchLimitOne ] as [String: Any]
//        
//        var dataTypeRef: AnyObject?
//        
//        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
//        
//        if status == noErr {
//            return dataTypeRef as! Data?
//        } else {
//            return nil
//        }
//    }
//    
//    class func createUniqueID() -> String {
//        let uuid: CFUUID = CFUUIDCreate(nil)
//        let cfStr: CFString = CFUUIDCreateString(nil, uuid)
//        
//        let swiftString: String = cfStr as String
//        return swiftString
//    }
//}
//
//extension Data {
//    
//    init<T>(from value: T) {
//        var value = value
//        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
//    }
//    
//    func to<T>(type: T.Type) -> T {
//        return self.withUnsafeBytes { $0.pointee  }
//    }
//}
//extension String {
//    func toHexString() -> String {
//        return self.utf8.map { String(format: "%02hhx", $0) }.joined()
//    }
//}

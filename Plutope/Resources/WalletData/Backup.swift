//
//  Backup.swift
//  Plutope
//
//  Created by Mitali Desai on 13/06/23.
//
import Foundation
// import WalletCore
import CryptoSwift
import CGWallet
class BackupWallet {
    
    static let shared = BackupWallet()
 
    private init() {  }
   
    // Encrypt the mnemonic key
    func encryptMnemonic(mnemonic: String, password: String) throws -> Data {
        guard let mnemonicData = mnemonic.data(using: .utf8) else {
            throw NSError(domain: "EncryptionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert mnemonic to data"])
        }
        
        do {
            let passwordData = Array(password.utf8)
            let key = try PKCS5.PBKDF2(password: passwordData, salt: passwordData, iterations: 4096, keyLength: 32).calculate()
            let encryptedData = try mnemonicData.encrypt(cipher: AES(key: key, blockMode: CBC(iv: Array(repeating: 0, count: 16))))
            return encryptedData
        } catch {
            throw error
        }
    }
    
    // Decrypt the mnemonic key
    func decryptMnemonic(encryptedData: Data, password: String) throws -> String {
        do {
            let passwordData = Array(password.utf8)
            let key = try PKCS5.PBKDF2(password: passwordData, salt: passwordData, iterations: 4096, keyLength: 32).calculate()
            let decryptedData = try encryptedData.decrypt(cipher: AES(key: key, blockMode: CBC(iv: Array(repeating: 0, count: 16))))
            guard let mnemonic = String(data: decryptedData, encoding: .utf8) else {
                throw NSError(domain: "DecryptionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert decrypted data to mnemonic"])
            }
            return mnemonic
        } catch {
            throw error
        }
    }
    
//    // Encrypt and save the wallet backup to iCloud as a JSON file
//    func backupWallet(wallet: HDWallet, password: String, fileName: String, completion: @escaping ((Error?) -> Void)) {
//        // Get the mnemonic from the wallet
//        let mnemonic = wallet.mnemonic
//        do {
//            // Encrypt the mnemonic key
//            let encryptedData = try encryptMnemonic(mnemonic: mnemonic, password: password)
//            guard let iCloudContainerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
//                let error = NSError(domain: "com.trustwallet.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get iCloud container URL"])
//                completion(error)
//                return
//            }
//            let jsonFilePath = iCloudContainerURL.appendingPathComponent(fileName + ".json")
//            let jsonData = ["encryptedData": encryptedData.base64EncodedString()]
//            let json = try JSONSerialization.data(withJSONObject: jsonData, options: [])
//            try json.write(to: jsonFilePath)
//
//
//            completion(nil)
//        } catch let error {
//            completion(error)
//        }
//    }
//
//    // Restore and decrypt the wallet backup
//    func restoreWallet(fromFile fileName: String, password: String, completion: @escaping (Result<HDWallet, Error>) -> Void) {
//        guard let iCloudContainerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
//            let error = NSError(domain: "com.trustwallet.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get iCloud container URL"])
//            completion(.failure(error))
//            return
//        }
//        let jsonFilePath = iCloudContainerURL.appendingPathComponent(fileName)
//        do {
//            let jsonData = try Data(contentsOf: jsonFilePath)
//            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
//            guard let jsonDict = jsonObject as? [String: Any],
//                  let encryptedDataString = jsonDict["encryptedData"] as? String,
//                  let encryptedData = Data(base64Encoded: encryptedDataString) else {
//                let error = NSError(domain: "com.yourapp.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format or missing encrypted data"])
//                completion(.failure(error))
//                return
//            }
//            // Decrypt the encrypted data using your decryption logic
//            let decryptedData = try decryptMnemonic(encryptedData: encryptedData, password: password)
//            // Restore the wallet using the decrypted data
//            guard let wallet = HDWallet(mnemonic: decryptedData, passphrase: "") else { return  }
//            completion(.success(wallet))
//        } catch let error {
//            completion(.failure(error))
//        }
//    }
//
    // chnages 13-12-23
    // Encrypt and save the wallet backup to iCloud as a JSON file
    func backupWallet(wallet: MyWallet, password: String, fileName: String, completion: @escaping ((Error?) -> Void)) {
        // Get the mnemonic from the wallet
        if let myWallet = WalletData.shared.myWallet {
        } else {
            
        }
        let mnemonic = WalletData.shared.mnemonic
        do {
            // Encrypt the mnemonic key
            let encryptedData = try encryptMnemonic(mnemonic: mnemonic, password: password)
            guard let iCloudContainerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
                let error = NSError(domain: "com.trustwallet.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get iCloud container URL"])
                completion(error)
                return
            }
            let jsonFilePath = iCloudContainerURL.appendingPathComponent(fileName + ".json")
            let jsonData = ["encryptedData": encryptedData.base64EncodedString()]
            let json = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            try json.write(to: jsonFilePath)
            
            
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    // Restore and decrypt the wallet backup
    func restoreWallet(fromFile fileName: String, password: String, completion: @escaping (Result<MyWallet, Error>) -> Void) {
        guard let iCloudContainerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
            let error = NSError(domain: "com.trustwallet.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get iCloud container URL"])
            completion(.failure(error))
            return
        }
        let jsonFilePath = iCloudContainerURL.appendingPathComponent(fileName)
        do {
            let jsonData = try Data(contentsOf: jsonFilePath)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            guard let jsonDict = jsonObject as? [String: Any],
                  let encryptedDataString = jsonDict["encryptedData"] as? String,
                  let encryptedData = Data(base64Encoded: encryptedDataString) else {
                let error = NSError(domain: "com.yourapp.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format or missing encrypted data"])
                completion(.failure(error))
                return
            }
            // Decrypt the encrypted data using your decryption logic
            let decryptedData = try decryptMnemonic(encryptedData: encryptedData, password: password)
            // Restore the wallet using the decrypted data
            
            // guard let wallet = HDWallet(mnemonic: decryptedData, passphrase: "") else { return  }
           
            let coinType: CoinType = .bitcoin
            if coinType == .bitcoin {
                guard let wallet =  WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(decryptedData , WalletData.shared.chainBTC, nil)) else { return  }
                completion(.success(wallet))
            } else {
                guard let wallet =  WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(decryptedData , WalletData.shared.chainETH, nil)) else { return  }
                completion(.success(wallet))
                }
           
        } catch let error {
            completion(.failure(error))
        }
    }
    // // chnages end  13-12-23 
    func deleteFile(atPath filePath: URL, completion: @escaping (Error?) -> Void) {
        do {
            try FileManager.default.removeItem(at: filePath)
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    func getFilesFromICloudDrive(iCloudContainerURL: URL, completion: @escaping (Result<[(url: URL, creationDate: Date)], Error>) -> Void) {
        
        do {
            let fileManager = FileManager.default
            let directoryContents = try fileManager.contentsOfDirectory(at: iCloudContainerURL, includingPropertiesForKeys: [.creationDateKey], options: [])
            var fileDataWithCreationDates: [(url: URL, creationDate: Date)] = []
            for fileURL in directoryContents {
                if fileURL.pathExtension.lowercased() == "json" {
                    if let creationDate = try fileURL.resourceValues(forKeys: [.creationDateKey]).creationDate {
                        fileDataWithCreationDates.append((url: fileURL, creationDate: creationDate))
                        
                    }
                }
            }
            completion(.success(fileDataWithCreationDates))
        } catch {
            // Handle any errors during the search
            completion(.failure(error))
        }
    }
}

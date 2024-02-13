//
//  EncryptionManager.swift
//  Plutope
//
//  Created by Trupti Mistry on 07/12/23.
//

import Foundation
import CommonCrypto
import CryptoSwift
import CryptoKit

class EncryptionManager {
    private let encryptionKey = "uPW*brqXJ3uwAWT#-8HYRXy=pe=hV%zh".data(using: .utf8)!
    private let initialVector = "41b126e31bd2a511".data(using: .utf8)!
    
    func encrypt(privateKey: String) -> String? {
        var encrypted: Data?
        do {
            var keyData = encryptionKey
            keyData.count = kCCKeySizeAES256
            
            var ivData = initialVector
            ivData.count = kCCBlockSizeAES128
            
            var cipherText = [UInt8](repeating: 0, count: privateKey.utf8.count + kCCBlockSizeAES128)
            var numBytesEncrypted: size_t = 0
            
            let cryptStatus = CCCrypt(
                UInt32(kCCEncrypt),
                UInt32(kCCAlgorithmAES),
                UInt32(kCCOptionPKCS7Padding),
                keyData.bytes,
                keyData.count,
                ivData.bytes,
                privateKey,
                size_t(privateKey.utf8.count),
                &cipherText,
                cipherText.count,
                &numBytesEncrypted
            )
            
            guard cryptStatus == Int32(kCCSuccess) else {
                print("Encryption failed")
                return nil
            }
            
            encrypted = Data(bytes: cipherText, count: numBytesEncrypted)
        } catch {
            print("Encryption error: \(error.localizedDescription)")
        }
        
        return encrypted?.base64EncodedString()
    }
    func decrypt(encryptedPrivateKey: String) -> String? {
        guard let encryptedData = Data(base64Encoded: encryptedPrivateKey),
              let encryptionKey = "uPW*brqXJ3uwAWT#-8HYRXy=pe=hV%zh".data(using: .utf8),
              let initialVector = "41b126e31bd2a511".data(using: .utf8) else {
            return nil
        }
        
        var decryptedData = Data(count: encryptedData.count + kCCBlockSizeAES128)
        var decryptedLength = 0
        
        let status = encryptedData.withUnsafeBytes { encryptedBytes in
            initialVector.withUnsafeBytes { ivBytes in
                encryptionKey.withUnsafeBytes { keyBytes in
                    decryptedData.withUnsafeMutableBytes { decryptedBytes in
                        CCCrypt(
                            CCOperation(kCCDecrypt),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress,
                            keyBytes.count,
                            ivBytes.baseAddress,
                            encryptedBytes.baseAddress,
                            encryptedBytes.count,
                            decryptedBytes.baseAddress,
                            decryptedBytes.count,
                            &decryptedLength
                        )
                    }
                }
            }
        }
        
        if status == kCCSuccess {
            decryptedData.count = decryptedLength
            return String(data: decryptedData, encoding: .utf8)
        } else {
            return nil
        }
    }
    
}
    

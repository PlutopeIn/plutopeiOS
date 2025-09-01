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
import Security
class EncryptionManager {
    private let encryptionKey = "encryptionKey".data(using: .utf8)!
    private let initialVector = "initialVector".data(using: .utf8)!
    
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
              let encryptionKey = "encryptionKey".data(using: .utf8),
              let initialVector = "initialVector".data(using: .utf8) else {
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
    func decryptCardData(encryptedPrivateKey: String, encryptionKeyString: String) -> String? {
        guard let encryptedData = Data(base64Encoded: encryptedPrivateKey),
              let encryptionKey = encryptionKeyString.data(using: .utf8) else {
            return nil
        }
        
        var decryptedData = Data(count: encryptedData.count + kCCBlockSizeAES128)
        var decryptedLength = 0
        
        let status = encryptedData.withUnsafeBytes { encryptedBytes in
            encryptionKey.withUnsafeBytes { keyBytes in
                decryptedData.withUnsafeMutableBytes { decryptedBytes in
                    CCCrypt(
                        CCOperation(kCCDecrypt),
                        CCAlgorithm(kCCAlgorithmAES128),
                        CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode),
                        keyBytes.baseAddress,
                        keyBytes.count,
                        nil, // No IV for ECB mode
                        encryptedBytes.baseAddress,
                        encryptedBytes.count,
                        decryptedBytes.baseAddress,
                        decryptedBytes.count,
                        &decryptedLength
                    )
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
    
    
    func extractPublicKey(from base64Key: String) -> SecKey? {
        guard let publicKeyData = Data(base64Encoded: base64Key) else {
            print("Invalid Base64 public key")
            return nil
        }
        
        let keyDict: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: 2048
        ]
        
        return SecKeyCreateWithData(publicKeyData as CFData, keyDict as CFDictionary, nil)
    }
    func rsaEncrypt(text: String, publicKeyBase64: String) -> String? {
        guard let publicKey = extractPublicKey(from: publicKeyBase64) else {
            print("Failed to create public key")
            return nil
        }
        
        guard let data = text.data(using: .utf8) else {
            print("Failed to convert text to Data")
            return nil
        }
        
        var error: Unmanaged<CFError>?
        guard let encryptedData = SecKeyCreateEncryptedData(publicKey, .rsaEncryptionPKCS1, data as CFData, &error) else {
            print("Encryption failed: \(error?.takeRetainedValue().localizedDescription ?? "Unknown error")")
            return nil
        }
        
        return (encryptedData as Data).base64EncodedString()
    }
    
    
    //    func extractKeyData(from pemString: String) -> Data? {
    //        let lines = pemString
    //            .components(separatedBy: "\n")
    //            .filter { !$0.contains("BEGIN") && !$0.contains("END") } // Remove headers
    //            .joined()
    //
    //        return Data(base64Encoded: lines)
    //    }
    
    func extractKeyData(from pemString: String) -> Data? {
           let lines = pemString
               .components(separatedBy: .newlines)
               .filter { !$0.contains("BEGIN") && !$0.contains("END") }
               .joined()
           
           return Data(base64Encoded: lines)
       }
       
       func extractPrivateKey(from pemString: String) -> SecKey? {
           guard let privateKeyData = extractKeyData(from: pemString) else {
               print("❌ Failed to extract private key data")
               return nil
           }
           
//           // Convert PKCS#8 to PKCS#1 (if needed)
//           guard let pkcs1Data = stripPKCS8Header(from: privateKeyData) else {
//               print("❌ Failed to convert PKCS#8 to PKCS#1")
//               return nil
//           }
//           
           let keyDict: [String: Any] = [
               kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
               kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
               kSecAttrKeySizeInBits as String: 1024
           ]
           
           var error: Unmanaged<CFError>?
           guard let privateKey = SecKeyCreateWithData(privateKeyData as CFData, keyDict as CFDictionary, &error) else {
               print("❌ Failed to create private key: \(error?.takeRetainedValue().localizedDescription ?? "Unknown error")")
               return nil
           }
           
           return privateKey
       }
       
       /// Strips PKCS#8 header to get the PKCS#1 private key
       private func stripPKCS8Header(from data: Data) -> Data? {
           var bytes = [UInt8](data)
           
           if bytes[0] != 0x30 { return nil } // Check ASN.1 sequence
           
           var index = 1
           if bytes[index] > 0x80 {
               index += Int(bytes[index] - 0x80 + 1)
           } else {
               index += 1
           }
           
           let rsaOid: [UInt8] = [0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00]
           if !bytes[index..<index + rsaOid.count].elementsEqual(rsaOid) {
               return nil
           }
           index += rsaOid.count
           
           if bytes[index] != 0x04 { return nil }
           index += 1
           
           let keyLength = Int(bytes[index])
           index += 1
           
           if keyLength & 0x80 != 0 {
               let byteCount = keyLength & 0x7f
               index += byteCount
           }
           
           return Data(bytes[index...])
       }
  
    func loadPrivateKey(fromPEM pemString: String) -> SecKey? {
        // Remove PEM headers and footers
        let keyString = pemString
            .replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Decode Base64
        guard let keyData = Data(base64Encoded: keyString, options: .ignoreUnknownCharacters) else {
            print("Invalid Base64 private key")
            return nil
        }

        // Define key attributes for PKCS#8
        let keyAttributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate
        ]

        // Create SecKey
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateWithData(keyData as CFData, keyAttributes as CFDictionary, &error) else {
            print("Failed to create private key: \(error?.takeRetainedValue().localizedDescription ?? "Unknown error")")
            return nil
        }

        print("Private Key Loaded Successfully!")
        return privateKey
    }
    
    func decryptRSA(encryptedBase64: String, privateKey: SecKey) -> String? {
        // 1️⃣ Convert Base64 string to Data
        guard let encryptedData = Data(base64Encoded: encryptedBase64) else {
            print("❌ Invalid Base64 data")
            return nil
        }

        var error: Unmanaged<CFError>?
        
        // 2️⃣ Decrypt using RSA
        guard let decryptedData = SecKeyCreateDecryptedData(
            privateKey,
            SecKeyAlgorithm.rsaEncryptionPKCS1, // Ensure encryption matches this padding
            encryptedData as CFData,
            &error
        ) as Data? else {
            print("❌ Decryption failed: \(error?.takeRetainedValue().localizedDescription ?? "Unknown error")")
            return nil
        }
        
        // 3️⃣ Convert decrypted Data to String
        return String(data: decryptedData, encoding: .utf8)
    }
    func decryptMultipleRSA(encryptedBase64Array: [String], privateKey: SecKey) -> [String] {
        var decryptedResults: [String] = []
        
        for encryptedBase64 in encryptedBase64Array {
            // Convert Base64 string to Data
            guard let encryptedData = Data(base64Encoded: encryptedBase64) else {
                print("❌ Invalid Base64 encoded string: \(encryptedBase64)")
                continue
            }
            
            var error: Unmanaged<CFError>?
            
            // Decrypt data using RSA
            guard let decryptedData = SecKeyCreateDecryptedData(
                privateKey,
                SecKeyAlgorithm.rsaEncryptionPKCS1, // Change if using different padding
                encryptedData as CFData,
                &error
            ) as Data? else {
                print("❌ Decryption failed: \(error?.takeRetainedValue().localizedDescription ?? "Unknown error")")
                continue
            }
            
            // Convert decrypted data to a string
            if let decryptedString = String(data: decryptedData, encoding: .utf8) {
                decryptedResults.append(decryptedString)
            } else {
                print("⚠️ Unable to decode decrypted data to string")
            }
        }
        
        return decryptedResults
    }
}
    

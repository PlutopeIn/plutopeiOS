//
//  RSAEncryptionManager.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/03/25.
//

import Foundation
import Security
class RSAEncryptionManager {
    
    var privateKey: SecKey?
    
    init(privateKeyPEM: String) {
            self.privateKey = loadPrivateKey(pemString: privateKeyPEM)
            if self.privateKey == nil {
                print("❌ Private key is not loaded")
            } else {
                print("✅ Private key loaded successfully")
            }
        }

    func loadPrivateKey(pemString: String) -> SecKey? {
        // Remove PEM headers and footers
        let keyString = pemString
            .replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")

        // Decode Base64 string to Data
        guard let keyData = Data(base64Encoded: keyString) else {
            print("❌ Failed to decode Base64 private key")
            return nil
        }

        // Define key attributes
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits as String: 2048
        ]

        // Create SecKey from key data
        var error: Unmanaged<CFError>?
        guard let secKey = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error) else {
            if let error = error?.takeRetainedValue() {
                print("❌ Error creating SecKey: \(error)")
            }
            return nil
        }

        print("✅ Private key loaded successfully")
        return secKey
    }
    /// Convert PEM key to Data
    private func stripPEMHeaderAndConvertToData(pemString: String) -> Data? {
        let lines = pemString.components(separatedBy: .newlines)
            .filter { !$0.contains("-----BEGIN") && !$0.contains("-----END") }
        
        let base64String = lines.joined()
        return Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)
    }
    
    /// Decrypt Base64-encoded RSA string using Private Key
    func decryptString(_ base64EncryptedString: String) -> String? {
        guard let privateKey = self.privateKey else {
            print("❌ Private key is not loaded")
            return nil
        }
        
        guard let encryptedData = Data(base64Encoded: base64EncryptedString) else {
            print("❌ Failed to convert base64 string to Data")
            return nil
        }
        
        var error: Unmanaged<CFError>?
        guard let decryptedData = SecKeyCreateDecryptedData(
            privateKey,
            SecKeyAlgorithm.rsaEncryptionOAEPSHA256, // Ensure correct encryption algorithm
            encryptedData as CFData,
            &error
        ) as Data? else {
            print("❌ Decryption failed: \(error?.takeRetainedValue() as Error? ?? NSError())")
            return nil
        }

        return String(data: decryptedData, encoding: .utf8)
    }
}



//class RSAEncryptionManager {
//    var publicKey: SecKey?
//    var privateKey: SecKey?
//
//    init() {
//        generateRSAKeyPair()
//    }
//
//    /// Generates RSA key pair (Public & Private Keys)
//    private func generateRSAKeyPair(keySize: Int = 2048) {
//        let attributes: [String: Any] = [
//            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
//            kSecAttrKeySizeInBits as String: keySize,
//            kSecPrivateKeyAttrs as String: [
//                kSecAttrIsPermanent as String: false
//            ]
//        ]
//        
//        var publicKey: SecKey?
//        var privateKey: SecKey?
//        
//        let status = SecKeyGeneratePair(attributes as CFDictionary, &publicKey, &privateKey)
//        
//        if status == errSecSuccess {
//            self.publicKey = publicKey
//            self.privateKey = privateKey
//        } else {
//            print("❌ Key generation failed with status: \(status)")
//        }
//    }
//
//    /// Encrypt data using Public Key
//    func encryptData(_ text: String) -> String? {
//        guard let publicKey = self.publicKey else { return nil }
//        guard let data = text.data(using: .utf8) else { return nil }
//        
//        var error: Unmanaged<CFError>?
//        let encryptedData = SecKeyCreateEncryptedData(
//            publicKey,
//            SecKeyAlgorithm.rsaEncryptionOAEPSHA256,
//            data as CFData,
//            &error
//        ) as Data?
//        
//        if let error = error {
//            print("❌ Encryption Error: \(error.takeRetainedValue() as Error)")
//            return nil
//        }
//        
//        // Convert encrypted data to Base64 string
//        return encryptedData?.base64EncodedString()
//    }
//
//    /// Decrypt Base64 encoded encrypted string using Private Key
//    func decryptBase64String(_ base64String: String) -> String? {
//        guard let privateKey = self.privateKey else { return nil }
//
//        // Convert Base64 string to Data
//        guard let encryptedData = Data(base64Encoded: base64String) else {
//            print("❌ Invalid Base64 string")
//            return nil
//        }
//        
//        return decryptData(encryptedData)
//    }
//
//    /// Decrypt data using Private Key
//    func decryptData(_ encryptedData: Data) -> String? {
//        guard let privateKey = self.privateKey else { return nil }
//        
//        var error: Unmanaged<CFError>?
//        let decryptedData = SecKeyCreateDecryptedData(
//            privateKey,
//            SecKeyAlgorithm.rsaEncryptionOAEPSHA256,
//            encryptedData as CFData,
//            &error
//        ) as Data?
//        
//        if let error = error {
//            print("❌ Decryption Error: \(error.takeRetainedValue() as Error)")
//            return nil
//        }
//        
//        return decryptedData.flatMap { String(data: $0, encoding: .utf8) }
//    }
//}


//class RSAEncryptionManager {
//    var privateKey: SecKey?
//
//    init(privateKey: SecKey) {
//        self.privateKey = privateKey
//    }
//
//    /// Decrypts a Base64-encoded encrypted string using the private key
//    func decryptData(base64String: String) -> String? {
//        guard let privateKey = self.privateKey else { return nil }
//        
//        // Convert Base64 string to Data
//        guard let encryptedData = Data(base64Encoded: base64String) else {
//            print("❌ Invalid Base64 string")
//            return nil
//        }
//        
//        var error: Unmanaged<CFError>?
//        let decryptedData = SecKeyCreateDecryptedData(
//            privateKey,
//            SecKeyAlgorithm.rsaEncryptionOAEPSHA256,
//            encryptedData as CFData,
//            &error
//        ) as Data?
//        
//        if let error = error {
//            print("❌ Decryption Error: \(error.takeRetainedValue() as Error)")
//            return nil
//        }
//        
//        return decryptedData.flatMap { String(data: $0, encoding: .utf8) }
//    }
//    func loadPrivateKey() -> SecKey? {
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassKey,
//            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
//            kSecReturnRef as String: true
//        ]
//
//        var item: CFTypeRef?
//        let status = SecItemCopyMatching(query as CFDictionary, &item)
//
//        guard status == errSecSuccess else {
//            print("❌ Failed to retrieve private key")
//            return nil
//        }
//
//        return (item as! SecKey)
//    }
//}

//
//  DatabaseHelper.swift
//  PlutoPe
//
//  Created by Mitali Desai on 26/05/23.
//
import Foundation
import UIKit
import CoreData
//import WalletCore
class DatabaseHelper {
    
    static var shared = DatabaseHelper()
    private init() {  }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - Save
    func saveData<T: NSManagedObject>(_ object: T, completion: @escaping ((Bool) -> Void)) {
        do {
            try context.save()
            completion(true)
        } catch {
            print("Could not save data: \(error)")
            completion(false)
        }
    }
    
    // MARK: - Retrieve
    func retrieveData<T: NSManagedObject>(_ entityName: String) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("Failed to retrieve data", error)
            return []
        }
    }
    
    func fetchTokens(withWalletID walletID: String) -> [WalletTokens]? {
        let fetchRequest: NSFetchRequest<WalletTokens> = WalletTokens.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "wallet_id == %@", walletID)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching tokens: \(error)")
            return nil
        }
    }
    func fetchWallet(byMnemonic mnemonic: String) -> Wallets? {
            let fetchRequest = NSFetchRequest<Wallets>(entityName: "Wallets")
            fetchRequest.predicate = NSPredicate(format: "mnemonic == %@", mnemonic)
            
            do {
                let results = try context.fetch(fetchRequest)
                return results.first
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                return nil
            }
        }
    func fetchTokenByID(btId id:String) -> Token? {
        
        let fetchRequest = NSFetchRequest<Token>(entityName: "Token")
        fetchRequest.predicate = NSPredicate(format: "tokenId == %@", id)
            do {
                let tokens = try context.fetch(fetchRequest)
                return tokens.first
            } catch {
                print("Failed to fetch token: \(error)")
                return nil
            }
        }
    func fetchTokenByAddress(byId id: String,byAddress address:String) -> Token? {
        
        let fetchRequest = NSFetchRequest<Token>(entityName: "Token")
        fetchRequest.predicate = NSPredicate(format: "tokenId == %@ AND address == %@",id ,address)
            do {
                let tokens = try context.fetch(fetchRequest)
                return tokens.first
            } catch {
                print("Failed to fetch token: \(error)")
                return nil
            }
        }
    func fetchExistingWalletEntity(walletID: UUID) -> Wallets? {
        let fetchRequest: NSFetchRequest<Wallets> = Wallets.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "wallet_id == %@", walletID as CVarArg)
        
        do {
            let results = try DatabaseHelper.shared.context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch Wallets entity: \(error)")
            return nil
        }
    }
    // MARK: - Update
    func updateData(entityName: String, predicateFormat: String, predicateArgs: [Any], updateBlock: @escaping (NSManagedObject) -> Void) {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: predicateFormat, argumentArray: predicateArgs)
        
        do {
            let results = try DatabaseHelper.shared.context.fetch(fetchRequest)
            
            for object in results {
                updateBlock(object)
            }
            
            // Save the changes to the context
            try context.save()
            
            print("Data updated successfully.")
        } catch {
            print("Error updating data: \(error.localizedDescription)")
        }
    }
    
    /// delete data
    func deleteData(withToken tokenObject: Token, walletID: String) {
        let fetchReq: NSFetchRequest<WalletTokens> = WalletTokens.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "tokens == %@ AND wallet_id == %@", tokenObject, walletID)
        
        do {
            let results = try context.fetch(fetchReq)
            if let walletToken = results.first {
                // Step 1: Delete the WalletTokens object
                context.delete(walletToken)
                
                // Save the context after deleting the WalletTokens object
                try context.save()
                
                // Step 2: Delete the Token object if it's a user-added token
                if tokenObject.isUserAdded {
                    context.delete(tokenObject)
                    
                    // Save the context after deleting the Token object
                    try context.save()
                }
            }
        } catch {
            print("Error fetching WalletTokens:", error)
        }
    }
    func deleteAllTokens() {
//        let fetchRequest: NSFetchRequest<Token> = Token.fetchRequest()
        let fetchRequest = NSFetchRequest<Token>(entityName: "Token")
     
        do {
            let tokenObjects = try DatabaseHelper.shared.context.fetch(fetchRequest)
            
            for token in tokenObjects {
                DatabaseHelper.shared.context.delete(token)
            }
            
            // Save changes to the context
            try context.save()
//            DatabaseHelper.shared.saveContext()
            print("All tokens have been deleted.")
            
        } catch let error as NSError {
            print("Could not fetch or delete tokens. \(error), \(error.userInfo)")
        }
    }
    func deleteAllWallets() {
       
        let fetchRequest: NSFetchRequest<Wallets> = Wallets.fetchRequest()
        
        do {
            let wallets = try context.fetch(fetchRequest)
            for wallet in wallets {
                context.delete(wallet)
            }
            try context.save()
        } catch {
            print("Error deleting all wallets: \(error.localizedDescription)")
        }
    }
    /// Delete
    func deleteEntity(withFormat format: String, entityName: String, identifier: String) {
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        // Set up the predicate to fetch the specific object to delete
        fetchReq.predicate = NSPredicate(format: format, identifier)

        do {
            let results = try context.fetch(fetchReq)
            if let objectToDelete = results.first as? NSManagedObject {
                // Delete the specific object
                context.delete(objectToDelete)

                do {
                    // Save the context after deleting the object
                    try context.save()
                } catch {
                    print("Error saving context after deletion", error)
                }
            }
        } catch {
            print("Error fetching \(entityName)", error)
        }
    }

    func deleteTokenIfDisabled(withAddress address: String) {
        let fetchRequest = NSFetchRequest<Token>(entityName: "Token")
        fetchRequest.predicate = NSPredicate(format: "address == %@ AND isEnabled == %@", address, NSNumber(value: false))

        do {
            let tokensToDelete = try context.fetch(fetchRequest)
            guard !tokensToDelete.isEmpty else {
                print("No token found with address \(address) and isEnabled == false. Nothing to delete.")
                return
            }

            for token in tokensToDelete {
                context.delete(token)
            }

            try context.save()
            print("Deleted \(tokensToDelete.count) token(s) with address \(address) and isEnabled == false.")
        } catch {
            print("Failed to delete token: \(error)")
        }
    }


    // MARK: - Check if entity is empty
    func entityIsEmpty(_ entityName: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let result = try context.fetch(fetchRequest)
            return result.isEmpty
        } catch {
            print(error)
            return false
        }
    }
    func fetchToken(byName name: String, btId id: String) -> Token? {
        let fetchRequest = NSFetchRequest<Token>(entityName: "Token")
        fetchRequest.predicate = NSPredicate(format: "tokenId == %@ AND name == %@", id, name)
        
        do {
            let tokens = try context.fetch(fetchRequest)
            return tokens.first
        } catch {
            print("Failed to fetch token: \(error)")
            return nil
        }
    }
    func addOrUpdateTokenAllForWallets(tokenModel: TokenModel, walletIDs: [UUID], completion: @escaping () -> Void) {
        let tokenId = tokenModel.tokenId
        
        var token: Token
        do {
            
            if let existingToken = fetchTokenByID(btId: tokenId) {
                token = existingToken
            } else {
                token = Token(context: context)
                token.tokenId = tokenModel.tokenId
            }
            
            // Update token properties
            token.address = tokenModel.address
            token.name = tokenModel.name
            token.symbol = tokenModel.symbol
            token.decimals = tokenModel.decimals
            token.logoURI = tokenModel.logoURI
            token.type = tokenModel.type
            token.balance = tokenModel.balance
            token.price = tokenModel.price
            token.lastPriceChangeImpact = tokenModel.lastPriceChangeImpact
            // token.isEnabled = tokenModel.isEnabled
            token.isUserAdded = tokenModel.isUserAdded
            
            // ✅ Check if the token is native or supported
            
            if AppConstants.nativeCoins.contains(token.name ?? "") {
                token.isEnabled = true
            } else {
                token.isEnabled = tokenModel.isEnabled // Keep existing value if not in lists
            }
            
            // ✅ Associate token with multiple wallets
            for walletID in walletIDs {
                guard let wallet = fetchExistingWalletEntity(walletID: walletID) else { continue }
                
                let fetchRequest: NSFetchRequest<WalletTokens> = WalletTokens.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "wallet_id == %@ AND tokens == %@", walletID as CVarArg, token)
                
                do {
                    let existingRelations = try context.fetch(fetchRequest)
                    if existingRelations.isEmpty {
                        let walletToken = WalletTokens(context: context)
                        walletToken.wallet_id = walletID
                        walletToken.tokens = token
                    }
                } catch {
                    print("Failed to fetch WalletTokens: \(error.localizedDescription)")
                }
            }
            
            do {
                try context.save()
                print("Token successfully added/updated")
                completion() // Call the UI refresh
            } catch {
                print("Failed to save token: \(error.localizedDescription)")
            }
        }
    }
    func addOrUpdateTokenForWallets(tokenModel: TokenModel, walletIDs: [UUID], completion: @escaping () -> Void) {
        let tokenId = tokenModel.tokenId
        
        var token: Token
        if let existingToken = fetchTokenByID(btId: tokenId) {
            token = existingToken
        } else {
            token = Token(context: context)
            token.tokenId = tokenModel.tokenId
        }
        
        token.address = tokenModel.address
        token.name = tokenModel.name
        token.symbol = tokenModel.symbol
        token.decimals = tokenModel.decimals
        token.logoURI = tokenModel.logoURI
        token.type = tokenModel.type
        token.balance = tokenModel.balance
        token.price = tokenModel.price
        token.lastPriceChangeImpact = tokenModel.lastPriceChangeImpact
        token.isEnabled = tokenModel.isEnabled
        token.isUserAdded = tokenModel.isUserAdded
        
        for walletID in walletIDs {
            guard let wallet = fetchExistingWalletEntity(walletID: walletID) else { continue }

            let fetchRequest: NSFetchRequest<WalletTokens> = WalletTokens.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "wallet_id == %@ AND tokens == %@", walletID as CVarArg, token)

            do {
                let existingRelations = try context.fetch(fetchRequest)
                if existingRelations.isEmpty {
                    let walletToken = WalletTokens(context: context)
                    walletToken.wallet_id = walletID
                    walletToken.tokens = token
                }
            } catch {
                print("Failed to fetch WalletTokens: \(error.localizedDescription)")
            }
        }

        do {
            try context.save()
            print("Token successfully added/updated")
            completion() // Call the UI refresh
        } catch {
            print("Failed to save token: \(error.localizedDescription)")
        }
    }
    
    func addOrUpdateNewTokenForWallets(tokenModel: TokenModel, walletIDs: [UUID], completion: @escaping () -> Void) {
        let tokenId = tokenModel.tokenId

        var token: Token
        var isNewToken = false
        var isChanged = false

        if let existingToken = fetchTokenByID(btId: tokenId) {
            token = existingToken
        } else {
            token = Token(context: context)
            token.tokenId = tokenId
            isNewToken = true
            isChanged = true
        }

        // Update only if values changed
        func update<T: Equatable>(_ keyPath: ReferenceWritableKeyPath<Token, T>, _ newValue: T) {
            if token[keyPath: keyPath] != newValue {
                token[keyPath: keyPath] = newValue
                isChanged = true
            }
        }

        update(\.address, tokenModel.address)
        update(\.name, tokenModel.name)
        update(\.symbol, tokenModel.symbol)
        update(\.decimals, tokenModel.decimals)
        update(\.logoURI, tokenModel.logoURI ?? "")
        update(\.type, tokenModel.type ?? "")
        update(\.balance, tokenModel.balance ?? "")
        update(\.price, tokenModel.price ?? "")
        update(\.lastPriceChangeImpact, tokenModel.lastPriceChangeImpact ?? "")
        update(\.isEnabled, tokenModel.isEnabled)
        update(\.isUserAdded, tokenModel.isUserAdded)

        for walletID in walletIDs {
            guard let wallet = fetchExistingWalletEntity(walletID: walletID) else { continue }

            let fetchRequest: NSFetchRequest<WalletTokens> = WalletTokens.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "wallet_id == %@ AND tokens == %@", walletID as CVarArg, token)

            do {
                let existingRelations = try context.fetch(fetchRequest)
                if existingRelations.isEmpty {
                    let walletToken = WalletTokens(context: context)
                    walletToken.wallet_id = walletID
                    walletToken.tokens = token
                    isChanged = true
                }
            } catch {
                print("Failed to fetch WalletTokens: \(error.localizedDescription)")
            }
        }

        if isChanged {
            do {
                try context.save()
                print("Token \(tokenModel.symbol) \(isNewToken ? "added" : "updated")")
            } catch {
                print("Failed to save token: \(error.localizedDescription)")
            }
        } else {
            print("Token \(tokenModel.symbol) is up-to-date, no changes.")
        }

        completion()
    }


}
struct TokenModel {
    let tokenId: String
    let address: String
    let name: String
    let symbol: String
    let decimals: Int64
    let logoURI: String?
    let type: String?
    let balance: String?
    let price: String?
    let lastPriceChangeImpact: String?
    let isEnabled: Bool
    let isUserAdded: Bool
}

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
} 

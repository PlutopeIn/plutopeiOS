//
//  TransactionHistoryViewModel.swift
//  Plutope
//
//  Created by Mitali Desai on 24/05/23.
//

import Foundation
/// TransactionHistoryViewModel
class TransactionHistoryViewModel {
 
    private var failblock: BindFail? = nil
    private lazy var repo: TransactionListRepo? = TransactionListRepo()
//    var transactionData: Observable<[TransactionList]> = .init([])
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    
    /// apiGetTransactionaHistroy
    func apiGetTransactionaHistroy(_ coindetail: Token,_ page: String,completion: @escaping (([TransactionResult]?,Bool,String) -> Void)) {
     
        repo?.getTransactionHistorty(coindetail,page,completion: { transactionList, status, err in
            if status == true {
                completion(transactionList,status,err)
            } else {
                self.failblock?(false, err)
            }
        })
    }
    /// getInternalTransactionHistory
    func apiGetInternalTransactionaHistroy(_ coindetail: Token,_ page: String,completion: @escaping (([TransactionResult]?,Bool,String) -> Void)) {
     
        repo?.apiGetInternalTransactionaHistroy(coindetail,page,completion: { transactionList, status, err in
            if status == true {
                completion(transactionList,status,err)
            } else {
                completion(transactionList,status,err)
            }
        })
    }
    
    func getTransactionHistortyNew1(_ coindetail: Token,_ page: String,completion: @escaping (([TransactionHistoryResult]?,Bool,String) -> Void)) {
        repo?.getTransactionHistortyNew1(coindetail, page, completion: { transactionList, status, err in
            completion(transactionList,status,err)
        })
    }
    func getTransactionHistortyNew(
        _ coindetail: Token,
        cursor: String?,
        completion: @escaping (([TransactionHistoryResult]?, String?, Bool, String) -> Void)
    ) {
        repo?.getTransactionHistortyNew(coindetail, cursor: cursor, completion: { transactionList, status, err,cursor  in
            completion(transactionList,status,err,cursor)
        })
    }
    

}

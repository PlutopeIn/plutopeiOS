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
}

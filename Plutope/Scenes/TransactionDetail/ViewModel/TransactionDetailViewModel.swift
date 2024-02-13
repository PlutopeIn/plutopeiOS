//
//  TransactionDetailViewModel.swift
//  Plutope
//
//  Created by Mitali Desai on 05/07/23.
//

import Foundation
/// TransactionDetailViewModel
class TransactionDetailViewModel {
 
    private var failblock: BindFail?
    private lazy var repo: TransactionDetailRepo? = TransactionDetailRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    
    /// getTransactionDetail
    func getTransactionDetail(_ chainShortName: String,_ txid: String,completion: @escaping (([TransactionDetails]?,Bool,String) -> Void)) {
     
        repo?.getTransactionDetail(chainShortName,txid,completion: { transactionList, status, err in
            if status == true {
                completion(transactionList,status,err)
            } else {
                self.failblock?(false, err)
            }
        })
    }
}

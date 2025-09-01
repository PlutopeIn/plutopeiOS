//
//  AllTranscationHistryViewwModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 19/06/24.
//

import Foundation
class AllTranscationHistryViewwModel {
    
    private var failblock: BindFail? = nil
    private lazy var repo: AllTranscationHistryRepo? = AllTranscationHistryRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    
    func getAllHistoryAPI(offset:Int,size:Int,completion: @escaping(Int,String,[AllTransactionHistryDataList]?) -> Void) {
        repo?.apiGetAllHistory(offset: offset, size: size, completion: { status, msg, data in
            completion(status, msg, data)
        })
    }
    func getSingleWalletHistoryAPI(currencyFilter:String,completion: @escaping(Int,String,[SingleTransactionHistry]?) -> Void) {
        repo?.apiGetSingleWalletHistory(currencyFilter: currencyFilter, completion: { status, msg, data in
            completion(status, msg, data)
        })
    }
    //// live
    func fetchTransactions(offset: Int, size: Int, completion: @escaping (Result<[AllTransactionHistryDataListNewElement], Error>) -> Void) {
        repo?.fetchTransactions(offset: offset, size: size, completion: { result in
            completion(result)
        })
    }
}

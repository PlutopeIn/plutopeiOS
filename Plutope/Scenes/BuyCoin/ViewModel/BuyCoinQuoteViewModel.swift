//
//  BuyCoinQuoteViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 04/04/24.
//

import Foundation

class BuyCoinQuoteViewModel {
    
    private var failblock: BindFail?
    private lazy var repo: BuyCoinViewRepo? = BuyCoinViewRepo()
    init(_ bindFailure: @escaping BindFail) {
      
        self.failblock = bindFailure
    }
    
    func buyQuoteAPI(parameters: BuyQuoteParameters,completion: @escaping ((Bool,String,[BuyMeargedDataList]?) -> Void)) {
        repo?.apiBuyQuote(parameters: parameters, completion: { status, msg, data in
            if status == true {
                completion(true,"",data)
            } else {
                completion(false,"",nil)
            }
        })
    }
}

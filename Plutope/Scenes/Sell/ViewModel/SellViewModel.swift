//
//  SellViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 22/04/25.
//

import Foundation

class SellViewModel  {
    private var failblock: BindFail? = nil
    private lazy var repo: SellRepo? = SellRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    func apiGetSellProvider(completion:@escaping(_ status : Int,_ msg:String,_ resData : [SellProviderList]?) -> Void) {
        repo?.getSellProviderAPi(completion: { status, msg, resData in
            completion(status, msg, resData)
        })
        
    }
    
    
    
}

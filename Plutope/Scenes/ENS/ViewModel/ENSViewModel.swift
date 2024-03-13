//
//  ENSViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 02/01/24.
//

import Foundation
class ENSViewModel {
    
    private var failblock: BindFail? = nil
    private lazy var repo: ENSRepo? = ENSRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    
    func eNSDataAPI(currency: String,domainName: String,ownerAddress:String,recordsAddress:String,completion: @escaping ((ApiResponse)-> Void)) {
        
//        repo?.apiENSData(currency: currency, domainName: domainName, ownerAddress: ownerAddress, recordsAddress: recordsAddress, completion: { status, msg, data in
//            completion(status,msg,data)
//
//        })
        
        repo?.apiENSData(currency: currency, domainName: domainName, ownerAddress: ownerAddress, recordsAddress: recordsAddress, completion: { apiResponse in
          completion(apiResponse)
        })
    }
}

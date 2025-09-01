//
//  ReferallCodeViewModel.swift
//  Plutope
//
//  Created by sonoma on 03/07/24.
//

import Foundation
/// ReferallCodeViewModel
class ReferallCodeViewModel {
 
    private var failblock: BindFail?
    private lazy var repo: ReferallCodeRepo? = ReferallCodeRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
     
    /// getReferallCode
    func getReferallCodeAPI(walletAddress: String,completion: @escaping(_ resStatus:Int,_ dataValue:ReferallCodeDataList?,_ resMessage:String) -> ()) {
        repo?.referallCodeRepo(walletAddress: walletAddress,completion: { resStatus, dataValue, resMessage in
            completion(resStatus, dataValue, resMessage)
        })
    }
}

//
//  ReferalUserViewModel.swift
//  Plutope
//
//  Created by Pushpendra Rajput on 11/07/24.
//

import Foundation
/// ReferallCodeViewModel
class ReferalUserCodeViewModel {
 
    private var failblock: BindFail?
    private lazy var repo: ReferalUserRepo? = ReferalUserRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
     
    /// getReferallCode
    func referalUserRepo(walletAddress: String,completion: @escaping(_ resStatus:Int,_ resMessage:String,_ dataValue:[ReferalUserDataList]?) -> ()) {
        repo?.referalUserRepo(walletAddress: walletAddress, completion: { resStatus, resMessage,dataValue in
            completion(resStatus, resMessage,dataValue)
        })
    }
    
    /// getReferallCode
    func updateClaimRepo(walletAddress: String,completion: @escaping( _ resStatus:Int, _ resMessage:String,_ dataValue:[UpdateClaimDataList]?) -> ()) {
            repo?.updateClaimRepo(walletAddress: walletAddress,completion: { resStatus, resMessage,dataValue in
                completion(resStatus, resMessage,dataValue)
            })
        }
}

//
//  RegisterUserViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 05/12/23.
//

import Foundation
class RegisterUserViewModel {
    
    private var failblock: BindFail? = nil
    private lazy var repo: RegisterUserRepo? = RegisterUserRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    
    /// apiGetCoinPrice
    func registerAPI(walletAddress :String,appType:Int,deviceId:String,fcmToken:String,type:String,referralCode:String,completion: @escaping(_ resStatus:Int, _ message: String) -> ()) {
        
        repo?.apiRegister(walletAddress:walletAddress , appType: appType,deviceId:deviceId,fcmToken:fcmToken,type:type,referralCode: referralCode,completion: { resStatus, message in
            completion(resStatus, message)
//            if resStatus == 1 {
//                completion(1, message)
//            } else {
//                completion(0, message)
//            }
        })
    }
    
    func setWalletActiveAPI(walletAddress :String,completion: @escaping(_ resStatus:Int, _ message: String) -> ()) {
        repo?.apiSetWalletActive(walletAddress: walletAddress, completion: { resStatus, message in
            if resStatus == 1 {
                completion(1, message)
            } else {
                completion(0, message)
            }
        })
    }
    func activeTokensInfoApi(walletAddress:String,transactionType:String? = nil,providerType:String? = nil,transactionHash:String? = nil,tokenDetailArrayList:[[String: Any]]?,completion: @escaping(_ resStatus:Int, _ message: String,_ resdata:[[String: Any]]?) -> ()) {
        repo?.apiActiveTokensInfo(walletAddress:walletAddress,transactionType:transactionType,providerType:providerType,transactionHash:transactionHash,tokenDetailArrayList:tokenDetailArrayList, completion: { status, msg, data in
            if status == 1 {
                completion(1,msg,data)
            } else {
                completion(0,msg,nil)
            }
        })
    }
    
}
   


    

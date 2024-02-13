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
    func registerAPI(walletAddress :String,appType:Int,deviceId:String,fcmToken:String,completion: @escaping(_ resStatus:Int, _ message: String) -> ()) {
        
        repo?.apiRegister(walletAddress:walletAddress , appType: appType,deviceId:deviceId,fcmToken:fcmToken,completion: { resStatus, message in
           // if resStatus == 1 {
                completion(1, message)
            //} else {
              //  completion(0, message,nil)
            //}
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
    
}
    

//
//  SendBTCCoinViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 08/12/23.
//

import Foundation
class SendBTCCoinViewModel {
    
    private var failblock: BindFail? = nil
    private lazy var repo: SendBTCCoinRepo? = SendBTCCoinRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    func sendBTCApi(privateKey:String,value:String,toAddress:String,env:String,fromAddress:String,completion:@escaping((_ statusResult:Int,_ message : String,_ resData : [String:Any]?)-> Void)) {
        
        repo?.apiSendBTC(privateKey: privateKey, value: value, toAddress: toAddress, env: env, fromAddress: fromAddress, completion: { statusResult, message, resData in
            if statusResult == 1 {
                completion(1,message,nil)
            } else {
                completion(0,message,nil)
            }
        })
    }
}

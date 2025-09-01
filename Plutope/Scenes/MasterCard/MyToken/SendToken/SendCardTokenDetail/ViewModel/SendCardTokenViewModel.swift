//
//  SendCardTokenViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/06/24.
//

import Foundation
class SendCardTokenViewModel {
    
    private var failblock: BindFail? = nil
    private lazy var repo: SendCardTokenRepo? = SendCardTokenRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    func getFeeAPI(currency:String,amount:String,address:String,phone:String,isFrom:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:GetTokenFeeList?) -> ()) {
        repo?.getFee(currency: currency, amount: amount, address: address, phone: phone,isFrom:isFrom, completion: { resStatus, resMsg,dataValue in
            completion(resStatus,resMsg, dataValue)
        })
    }
    func walletSendVerificationAPI(phone:String,amount:String,address:String,currency:String,isFrom:String,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ dataValue:WalletSendValidateList?) -> ()) {
        repo?.apiWalletSendVerification(phone: phone, amount: amount, address: address, currency: currency, isFrom: isFrom, completion: { resStatus, resMessage, dataValue in
            completion(resStatus,resMessage,dataValue)
        })
        
    }
    func apiWalletSend(fee:String,phone:String,amount:String,address:String,currency:String,isFrom:String,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ resValue:[String:Any]?) -> ()) {
        repo?.apiWalletSend(fee: fee, phone: phone, amount: amount, address: address, currency: currency, isFrom: isFrom, completion: { resStatus, resMessage ,resValue in
            completion(resStatus,resMessage,resValue)
        })
    }
}

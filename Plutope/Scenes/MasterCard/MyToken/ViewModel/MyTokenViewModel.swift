//
//  MyTokenViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/05/24.
//

import Foundation

class MyTokenViewModel {
    
    private var failblock: BindFail? = nil
    private lazy var repo: MyTokenRepo? = MyTokenRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
//    func getTokenAPI(completion: @escaping(Int,[Wallet]?,Fiat?,String) -> Void) {
//        repo?.apiGetToken(completion: { status, data ,fiat, msg in
//            if status == 1 {
//                completion(1, data,fiat,msg)
//            } else {
//                completion(0, nil,nil,msg)
//            }
//        })
//    }
    func createWalletAPI(currencies:[String]?,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[CreateWalletDataList]?) -> ()) {
        repo?.apiCreateWallet(currencies: currencies, completion: { resStatus, message, dataValue in
            if resStatus == 1 {
                completion(1,message, dataValue)
            } else {
                completion(0,message, nil)
            }
        })
    }
//    func kycStatusAPI(completion: @escaping(Int,KycStatusList?) -> Void) {
//        repo?.apiKycStatus(completion: { status, data in
//           completion(status,data)
//        })
//    }
    func kycStatusAPINew(completion: @escaping(Int,String,KycStatusList?) -> Void) {
        repo?.apiKycStatusNew(completion: { status, msg,data in
           completion(status,msg,data)
        })
    }
    func getTokenAPINew(completion: @escaping(Int,[Wallet]?,Fiat?,String) -> Void) {
        repo?.apiGetTokenNew(completion: { status,data ,fiat,msg in
            if status == 1 {
                completion(1,data,fiat,msg)
            } else {
                completion(0,nil,nil,msg)
            }
        })
    }
}
    

//
//  BankCardPayOutViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 04/07/24.
//

import Foundation

class BankCardPayOutViewModel {
    private var failblock: BindFail? = nil
    private lazy var repo: BankCardPayOutRepo? = BankCardPayOutRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
//    func getPayOutOtherDataAPI(cardRequestId:String,completion: @escaping(_ resStatus:Int,_ dataValue:PayOutOtherDataList?,_ resMessage:String) -> ()) {
//        repo?.getPayOutOtherData(cardRequestId: cardRequestId, completion: { resStatus, dataValue ,resMessage in
//            completion(resStatus,dataValue,resMessage)
//        })
//    }
    func getPayOutOtherDataLive(cardRequestId:String,completion: @escaping(_ resStatus:Int,_ dataValue:PayOutOtherDataList?,_ resMessage:String) -> ()) {
        repo?.getPayOutOtherDataLive(cardRequestId: cardRequestId, completion: { resStatus, dataValue ,resMessage in
            completion(resStatus,dataValue,resMessage)
        })
    }
    func apiPayOutAddCard(addCardPayout : AddCardPayout?,completion: @escaping(_ resStatus:Int,_ dataValue:[String:Any]?,_ resMessage : String) -> ()) {
        repo?.apiPayOutAddCard(addCardPayout: addCardPayout, completion: { resStatus, dataValue, resMessage in
            completion(resStatus,dataValue,resMessage)
        })
    }
    func apiPayOutOfferCreate(amount:String,cardId:String,toCurrency:String,fromCurrency:String,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ resData :[String:Any]?) -> ()) {
        repo?.apiPayOutOfferCreate(amount: amount, cardId: cardId, toCurrency: toCurrency, fromCurrency: fromCurrency, completion: { resStatus ,resMessage,resData in
            completion(resStatus,resMessage,resData)
        })
    }
    func apiPayOutOfferUpdate(amount:String,cardId:String,toCurrency:String,fromCurrency:String,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ resData :PayOutCreateOfferList?) -> ()) {
        repo?.apiPayOutOfferUpdate(amount: amount,cardId:cardId,toCurrency: toCurrency, fromCurrency: fromCurrency, completion: { resStatus ,resMessage,resData in
            completion(resStatus,resMessage,resData)
        })
    }
    func apipayOutExecuteOfferPayment(id:String,completion: @escaping(_  resStatus:Int,_ resMessage : String) -> ()) {
        repo?.apipayOutExecuteOfferPayment(id: id) { resStatus, resMessage in
            completion(resStatus,resMessage)
        }
    }
//    func getpayinPayCallback(id:String,completion: @escaping(_ resStatus:Int,_ dataValue:PayinPayCallbackList?,_ resMsg : String) -> ()) {
//        repo?.getpayinPayCallback(id: id, completion: {resStatus,resData,resMsg in
//            completion(resStatus,resData,resMsg)
//        })
//    }
}
    

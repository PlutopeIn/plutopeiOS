//
//  BankCardPayInViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 31/05/24.
//

import Foundation


class BankCardPayInViewModel {
    private var failblock: BindFail? = nil
    private lazy var repo: BankCardPayInRepo? = BankCardPayInRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    func getPayinFiatRates(completion: @escaping(_ resStatus:Int,String,_ dataValue:[PayinFiatRates]?) -> ()) {
        repo?.getPayinFiatRates(completion: { status,msg, data in
            completion(status,msg,data)
        })
    }
    
    func getPayInOtherDataAPI(cardRequestId:String,completion: @escaping(_ resStatus:Int,_ resMessage:String,_ dataValue:PayInOtherDataList?) -> ()) {
        repo?.getPayInOtherData(cardRequestId: cardRequestId, completion: { resStatus, resMessage,dataValue in
            completion(resStatus,resMessage,dataValue)
        })
    }
    func apiPayinAddCard(addCardPaying : AddCardPaying?,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ dataValue:[String:Any]?) -> ()) {
        repo?.apiPayinAddCard(addCardPaying: addCardPaying, completion: { resStatus,resMessage, dataValue in
            completion(resStatus,resMessage,dataValue)
        })
    }
    func apipayinCardBillingAddress(addCardBiling : AddCardPaying?,id:String,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ dataValue:[String:Any]?) -> ()) {
        repo?.apipayinCardBillingAddress(addCardBiling: addCardBiling, id: id, completion: { resStatus,resMessage, dataValue in
            completion(resStatus,resMessage,dataValue)
        })
        
    }
    func apiPayinOfferCreate(amount:String,cardId:String,operation:String,toCurrency:String,fromCurrency:String,cardCVV:String,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ resData :PayinCreateOfferList?) -> ()) {
        repo?.apiPayinOfferCreate(amount: amount, cardId: cardId, operation: operation, toCurrency: toCurrency, fromCurrency: fromCurrency, cardCVV: cardCVV, completion: { resStatus ,resMessage,resData in
            completion(resStatus,resMessage,resData)
        })
    }
    func getpayinPayCallback(id:String,completion: @escaping(_ resStatus:Int,_ resMsg : String,_ dataValue:PayinPayCallbackList?) -> ()) {
        repo?.getpayinPayCallback(id: id, completion: {resStatus,resMsg,resData in
            completion(resStatus,resMsg,resData)
        })
    }
    
    func apipayinExecuteOfferPayment(cardCVV:String,id:String,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ dataValue:PayinExecuteeOfferList?) -> ()) {
        repo?.apipayinExecuteOfferPayment(cardCVV: cardCVV, id: id, completion: { resStatus,resData,resMsg in
            completion(resStatus,resData,resMsg)
        })
    }
}
    

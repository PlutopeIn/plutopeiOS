//
//  TopUpCardViewwModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 05/06/24.
//

import Foundation
class TopUpCardViewwModel {
    private var failblock: BindFail? = nil
    private lazy var repo: TopUpCardRepo? = TopUpCardRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    func getCardPayloadCurrenciesAPI(completion: @escaping(_ resStatus:Int,String,_ dataValue:TopUpCurrencys?) -> ()) {
        repo?.getCardPayloadCurrencies(completion: { resStatus, msg,resData in
            completion(resStatus,msg,resData)
        })
    }
    func getCardPayloadOtherData(cardRequestId:String,completion: @escaping(_ resStatus:Int,String,_ dataValue:PayloadOtherList?) -> ()) {
        repo?.getCardPayloadOtherData(cardRequestId: cardRequestId, completion: { resStatus,msg, resData in
            completion(resStatus,msg, resData)
        })
    }
    func apiCreateCardPayloadOffer(cardId:String,fromCurrency:String,toCurrency:String,fromAmount:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:CreateCardPayloadOfferList?) -> ()) {
        repo?.apiCreateCardPayloadOffer(cardId: cardId, fromCurrency: fromCurrency, toCurrency: toCurrency, fromAmount: fromAmount, completion: { resStatus,resMsg, dataValue in
            completion(resStatus, resMsg, dataValue )
        })
    }
//    func apiUpdateCardPayloadOffer(cardId:String,fromCurrency:String,toCurrency:String,fromAmount:String,toAmount:String,offerId:String,completion: @escaping(_ resStatus:Int,_ dataValue:[CreateCardPayloadOfferList]?) -> ()) {
//        repo?.apiUpdateCardPayloadOffer(cardId: cardId, fromCurrency: fromCurrency, toCurrency: toCurrency, fromAmount: fromAmount, toAmount: toAmount, offerId: offerId, completion: { resStatus, dataValue in
//            completion(resStatus, dataValue)
//        })
//    }
    func apiPayloadOfferConfirm(cardId:String,offerId:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:[String:Any]?) -> ()) {
        repo?.apiPayloadOfferConfirm(cardId: cardId, offerId: offerId, completion: { resStatus, resMsg, dataValue in
            completion(resStatus, resMsg, dataValue)
        })
    }
}

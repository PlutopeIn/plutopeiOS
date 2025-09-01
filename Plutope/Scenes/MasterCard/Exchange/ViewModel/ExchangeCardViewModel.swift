//
//  ExchangeCardViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 20/06/24.
//

import Foundation
class ExchangeCardViewModel {
    private var failblock: BindFail? = nil
    private lazy var repo: ExchangeCardRepo? = ExchangeCardRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    func getExchangeCurrencyAPI(completion: @escaping(_ resStatus:Int,_ dataValue:ExchangeCurrencyList?,_ resMessage:String) -> ()) {
        repo?.getExchangeCurrency(completion: { resStatus, dataValue, resMessage in
            completion(resStatus, dataValue, resMessage)
        })
    }
    
    func apiExchangeOffer(amountTo:String,amountFrom:String,currencyTo:String,currencyFrom:String,completion: @escaping(_ resStatus:Int,_ dataValue:[String:Any]?,_ resMessage : String) -> ()) {
        
        repo?.apiExchangeOffer(amountTo: amountTo, amountFrom: amountFrom, currencyTo: currencyTo, currencyFrom: currencyFrom, completion: { resStatus, dataValue, resMessage in
            completion(resStatus, dataValue, resMessage)
        })
    }
    func getExchangeExecuteOffer(offerId:Int,completion: @escaping(_ resStatus:Int,_ resMessage:String) -> ()) {
        repo?.getExchangeExecuteOffer(offerId: offerId, completion: { resStatus, resMessage in
            completion(resStatus, resMessage)
        })
    }
        
}

//
//  CardPaymentViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 04/06/24.
//

import Foundation
class CardPaymentViewModel {
    
    private var failblock: BindFail? = nil
    private lazy var repo: CardPaymentRepo? = CardPaymentRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    func apiPaymentOffer(currency:String,id:String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
        repo?.apiPaymentOffer(currency: currency, id: id, completion: { resStatus, message, dataValue in
            completion(resStatus,message, dataValue)
        })
        
    }
    func apiPaymentOfferConfirm(id:String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
        repo?.apiPaymentOfferConfirm(id: id, completion: { resStatus, message, dataValue in
            completion(resStatus,message, dataValue)
        })
    }

}

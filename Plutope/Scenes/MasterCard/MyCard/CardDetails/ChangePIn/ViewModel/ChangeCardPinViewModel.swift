//
//  ChangeCardPinViewModel.swift
//  Plutope
//
//  Created by Sonoma on 04/09/24.
//

import Foundation

class ChangeCardPinViewModel {
    
    private var failblock: BindFail? = nil
    private lazy var repo: ChangeCardPinRepo? = ChangeCardPinRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    
//    func apiChangeCardPin(cardId:String,code:String,completion: @escaping(_ resStatus: Int, _ dataValue: ChangeCardPInResponseDataModel)/*(_ resStatus:Int,_ dataValue:[[String : Any]]?)*/ -> ()) {
//        repo?.apiChangeCardPin(cardId: cardId, code: code, completion: { resStatus, dataValue in
//            completion(resStatus,dataValue)
//        })
//    }
    
    func apiChangeCardPin(cardId: String, code:String, completion: @escaping(_ resStatus: Int,_ resmsg:String, _ dataValue: [String : Any]?) -> ()) {
        repo?.apiChangeCardPin(cardId: cardId, code: code, completion: { resStatus, resMsg, dataValue in
            completion(resStatus,resMsg,dataValue)
        })
    }
}

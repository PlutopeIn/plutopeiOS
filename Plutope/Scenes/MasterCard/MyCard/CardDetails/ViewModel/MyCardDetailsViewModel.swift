//
//  MyCardDetailsViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 27/05/24.
//

import Foundation

class MyCardDetailsViewModel {
    private var failblock: BindFail? = nil
    private lazy var repo: MyCardDetailsRepo? = MyCardDetailsRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    
//    func cardPublicPrivateKeyAPI(completion: @escaping(_ resStatus:Int,_ dataValue:PublicKeyData?) -> ()) {
//        repo?.getCardPublicPrivateKey(completion: { resStatus, dataValue in
//            completion(resStatus, dataValue)
//        })
//    }
//    func apiCardInformatonCodeSend(cardId:String,code:String,completion: @escaping(_ resStatus:Int,_ dataValue:[[String : Any]]?) -> ()) {
//        repo?.apiCardInformatonCodeSend(cardId: cardId, code: code, completion: { resStatus, dataValue in
//            completion(resStatus, dataValue)
//        })
//    }
//    func apiCardInformaton(cardId:String,code:String,publicKey:String,completion: @escaping(_ resStatus:Int,_ dataValue:CardInfoDataList?) -> ()) {
//        repo?.apiCardInformaton(cardId: cardId, code: code,publicKey: publicKey, completion: { resStatus,  dataValue in
//            completion(resStatus,dataValue)
//        })
//    }
    
//    func apiCardFreezeCodeSend(cardId:String,code:String,completion: @escaping(_ resStatus:Int,_ dataValue:[[String : Any]]?) -> ()) {
//        repo?.apiCardFreezeCodeSend(cardId: cardId, code: code, completion: { resStatus, dataValue in
//            completion(resStatus,dataValue)
//        })
//    }
//    func apiCardFreeze(cardId:String,code:String,publicKey:String? = "",completion: @escaping(_ resStatus:Int,_ resMessage : String) -> ()) {
//        repo?.apiCardFreeze(cardId: cardId, code: code, completion: { resStatus,resMessage in
//            completion(resStatus,resMessage)
//        })
//        
//    }
//    func apiCardUnFreezeCodeSend(cardId:String,code:String,completion: @escaping(_ resStatus:Int,_ dataValue:[[String : Any]]?) -> ()) {
//        repo?.apiCardUnFreezeCodeSend(cardId: cardId, code: code, completion: { resStatus, dataValue in
//            completion(resStatus,dataValue)
//        })
//    }
//    func apiCardUnFreeze(cardId:String,code:String,publicKey:String? = "",completion: @escaping(_ resStatus:Int,_ resMessage : String) -> ()) {
//        repo?.apiCardUnFreeze(cardId: cardId, code: code, completion: { resStatus ,resMessage in
//            completion(resStatus,resMessage)
//        })
//    }
//    func apiCardNumber(cardId:String,completion: @escaping(_ resStatus:Int,_ dataValue:CardNumberList?) -> ()) {
//        repo?.apiCardNumber(cardId: cardId, completion: { resStatus, dataValue in
//            completion(resStatus,dataValue)
//        })
//    }
//    func apiGetCardHistory(offset:Int,size:Int,cardId:String,completion: @escaping(Int,String,[CardHistoryFinalResponse]?) -> Void) {
//        repo?.apiGetCardHistory(offset: offset, size: size, cardId: cardId, completion: { resStatus, resMessage,dataValue in
//            completion(resStatus,resMessage,dataValue)
//        })
//    }
    /// live API
    func cardPublicPrivateKeyAPINew(completion: @escaping(_ resStatus:Int,_ dataValue:PublicKeyData?) -> ()) {
        repo?.getCardPublicPrivateKeyNew(completion: { resStatus, dataValue in
            completion(resStatus, dataValue)
        })
    }
    func apiCardInformatonCodeSendNew(cardId:String,code:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:[String : Any]?) -> ()) {
        repo?.apiCardInformatonCodeSendNew(cardId: cardId, code: code, completion: { resStatus,resMsg, dataValue in
            completion(resStatus, resMsg,dataValue)
        })
    }
    func apiCardInformatonNew(cardId:String,code:String,publicKey:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:CardInfoDataList?) -> ()) {
        repo?.apiCardInformatonNew(cardId: cardId, code: code,publicKey: publicKey, completion: { resStatus,resMsg , dataValue in
            completion(resStatus,resMsg,dataValue)
        })
    }
    
    func apiCardFreezeCodeSendNew(cardId:String,code:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:[String : Any]?) -> ()) {
        repo?.apiCardFreezeCodeSendNew(cardId: cardId, code: code, completion: { resStatus,resMsg, dataValue in
            completion(resStatus,resMsg,dataValue)
        })
    }
    func apiCardFreezeNew(cardId:String,code:String,publicKey:String? = "",completion: @escaping(_ resStatus:Int,_ resMessage : String,_ dataValue:[String : Any]?) -> ()) {
        repo?.apiCardFreezeNew(cardId: cardId, code: code, completion: { resStatus,resMessage,datavalue in
            completion(resStatus,resMessage,datavalue)
        })
        
    }
    func apiCardUnFreezeCodeSendNew(cardId:String,code:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:[String : Any]?) -> ()) {
        repo?.apiCardUnFreezeCodeSendNew(cardId: cardId, code: code, completion: { resStatus,resMsg, dataValue in
            completion(resStatus,resMsg,dataValue)
        })
    }
    func apiCardUnFreezeNew(cardId:String,code:String,publicKey:String? = "",completion: @escaping(_ resStatus:Int,_ resMessage : String,_ dataValue:[String : Any]?) -> ()) {
        repo?.apiCardUnFreezeNew(cardId: cardId, code: code, completion: { resStatus,resMessage,datavalue in
            completion(resStatus,resMessage,datavalue)
        })
    }
    func apiCardNumberNew(cardId:String,publicKey:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:CardNumberList?) -> ()) {
        repo?.apiCardNumberNew(cardId: cardId,publicKey: publicKey, completion: { resStatus,resMsg,dataValue in
            completion(resStatus,resMsg,dataValue)
        })
    }
    func apiCardNumberDecrypted(number:String,cardHolderName:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:CardNumberList?) -> ()) {
        repo?.apiCardNumberDecrypted(number: number, cardHolderName: cardHolderName,  completion: { resStatus, resMsg, dataValue in
            completion(resStatus,resMsg,dataValue)
        })
    }
    func apiCardInformatonDecrypted(number:String,expiry:String,cvv:String,cardholderName:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:CardInfoDataList?) -> ()) {
        repo?.apiCardInformatonDecrypted(number: number, expiry: expiry, cvv: cvv, cardholderName: cardholderName, completion: { resStatus, resMsg, dataValue in
            completion(resStatus,resMsg,dataValue)
        })
    }
    func apiGetCardHistoryNew(offset:Int,size:Int,cardId:String,completion: @escaping(Int,String,[CardHistoryListNew ]?) -> Void) {
        repo?.apiGetCardHistoryNew(offset: offset, size: size, cardId: cardId, completion: { resStatus, resMessage,dataValue in
            completion(resStatus,resMessage,dataValue)
        })
    }
    }
    

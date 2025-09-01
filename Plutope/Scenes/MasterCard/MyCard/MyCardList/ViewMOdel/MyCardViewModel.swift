//
//  MyCardViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/05/24.
//

import Foundation

class MyCardViewModel {
    
    private var failblock: BindFail? = nil
    private lazy var repo: MyCardRepo? = MyCardRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
//    func getCardAPI(completion: @escaping(Int,[Card]?) -> Void) {
//        repo?.apiGetCard(completion: { status, data in
//            if status == 1 {
//                completion(1, data)
//            } else {
//                completion(0, nil)
//            }
//        })
//    }
//    func cardRequestsAPI(cardType:String,cardDesignId:String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
//        repo?.apiCardRequests(cardType: cardType, cardDesignId: cardDesignId, completion: { resStatus, message, dataValue in
//            if resStatus == 1 {
//                completion(1,message, dataValue)
//            } else {
//                completion(0,message, nil)
//            }
//        })
//    }
//    func cancelCardRequestsAPI(cardRequestId:String,completion: @escaping(_ resStatus:Int,_ dataValue:[String : Any]?) -> ()) {
//        repo?.apiCancelCardRequests(cardRequestId: cardRequestId, completion: { status, data in
//            completion(status, data)
//        })
//    }
//    func addressUpdateRequestsAPI(updateCardHolderAddress:UpdateCardHolderAddress,cardRequestId:String,completion: @escaping(_ resStatus:Int,_ resMsg:String ,_ dataValue:[String : Any]?) -> ()) {
//        repo?.apiAddressUpdateRequests(updateCardHolderAddress:updateCardHolderAddress, cardRequestId: cardRequestId, completion: {status, msg ,data in
//            completion(status, msg,data)
//        })
//    }
    func getCountrisAPI(completion: @escaping(Int,String,[CountryList]?) -> Void) {
        repo?.apiGetCountris(completion: { status, msg, data in
            completion(status,msg,data)
        })
    }
//    func getCardPriceAPI(completion: @escaping(Int,[CardPriceList]?) -> Void) {
//        repo?.apiGetCardPrice(completion: { status, data in
//            completion(status, data)
//        })
//    }
//    func apiGetCardRequestPrice(cardRequestId:Int,currency : String,completion: @escaping(Int,CardPaymentValue?) -> Void) {
//        repo?.apiGetCardRequestPrice(cardRequestId: cardRequestId, currency: currency, completion: { status, data in
//            completion(status, data)
//        })
//    }
//    func additionalPersonalInfoAPI(taxId:String,isUsRelated:Bool,taxCountry:String,completion: @escaping(_ resStatus:Int,_ resMsg:String ,_ dataValue:AdditionalInfoList?) -> ()) {
//        repo?.apiAdditionalPersonalInfo(taxId: taxId, isUsRelated: isUsRelated, taxCountry: taxCountry, completion: { status, msg, data in
//            completion(status,msg,data)
//        })
//    }
    func changeCurrencyAPI(currencies:String?,completion: @escaping(_ resStatus:Int, _ message: String) -> ()) {
        repo?.apiChangeCurrency(currencies: currencies, completion: { resStatus, message in
            completion(resStatus,message)
        })
    }
    
    func getDashboardImagesAPI(completion: @escaping(Int,String,[String]?) -> Void) {
        repo?.apiGetDashboardImages(completion: { status, msg, data in
            completion(status,msg,data)
        })
    }
    
    /// live
    func getCardAPINew(completion: @escaping(Int,String,[Card]?) -> Void) {
        repo?.apiGetCardNew(completion: { status, msg,data in
            if status == 1 {
                completion(1,msg, data)
            } else {
                completion(0, msg,nil)
            }
        })
    }
    func cardRequestsAPINew(cardType:String,cardDesignId:String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
        repo?.apiCardRequestsNew(cardType: cardType, cardDesignId: cardDesignId, completion: { resStatus, message, dataValue in
           
                completion(resStatus,message, dataValue)
            
        })
    }
    func cancelCardRequestsAPINew(cardRequestId:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:[String : Any]?) -> ()) {
        repo?.apiCancelCardRequestsNew(cardRequestId: cardRequestId, completion: { status, msg,data in
            completion(status, msg,data)
        })
    }
    func addressUpdateRequestsAPINew(updateCardHolderAddress:UpdateCardHolderAddress,cardRequestId:String,completion: @escaping(_ resStatus:Int,_ resMsg:String ,_ dataValue:[String : Any]?) -> ()) {
        repo?.apiAddressUpdateRequestsNew(updateCardHolderAddress:updateCardHolderAddress, cardRequestId: cardRequestId, completion: {status, msg ,data in
            completion(status, msg,data)
        })
    }
    func apiCardHolderNameUpdateRequestsNew(cardholderName:String,cardRequestId:String,completion: @escaping(_ resStatus:Int,_ resMsg:String ,_ dataValue:[String : Any]?) -> ()) {
        repo?.apiCardHolderNameUpdateRequestsNew(cardholderName: cardholderName, cardRequestId: cardRequestId, completion: {status, msg ,data in
            completion(status, msg,data)
        })
    }
    func getCountrisAPINew(completion: @escaping(Int,String,[CountryList]?) -> Void) {
        repo?.apiGetCountris(completion: { status, msg, data in
            completion(status,msg,data)
        })
    }
    func getCardPriceAPINew(completion: @escaping(Int,String,[CardPriceList]?) -> Void) {
        repo?.apiGetCardPriceNew(completion: { status,msg ,data in
            completion(status, msg,data)
        })
    }
    func apiGetCardRequestPriceNew(cardRequestId:Int,currency : String,completion: @escaping(Int,String,CardPaymentValue?) -> Void) {
        repo?.apiGetCardRequestPriceNew(cardRequestId: cardRequestId, currency: currency, completion: { status, msg,data in
            completion(status,msg ,data)
        })
    }
    func additionalPersonalInfoAPINew(taxId:String,isUsRelated:Bool,taxCountry:String,completion: @escaping(_ resStatus:Int,_ resMsg:String ,_ dataValue:AdditionalInfoList?) -> ()) {
        repo?.apiAdditionalPersonalInfoNew(taxId: taxId, isUsRelated: isUsRelated, taxCountry: taxCountry, completion: { status, msg, data in
            completion(status,msg,data)
        })
    }
    func apiGetAdditionalPersonalInfoNew(completion: @escaping(Int,String,AdditionalInfoList?) -> Void) {
        repo?.apiGetAdditionalPersonalInfoNew(completion: { status, msg, data in
            completion(status,msg,data)
        })
    }
    func changeCurrencyAPINew(currencies:String?,completion: @escaping(_ resStatus:Int, _ message: String) -> ()) {
        repo?.apiChangeCurrencyNew(currencies: currencies, completion: { resStatus, message in
            completion(resStatus,message)
        })
    }
    
}
    

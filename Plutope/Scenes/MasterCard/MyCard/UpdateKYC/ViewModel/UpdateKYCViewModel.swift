//
//  UpdateKYCViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 21/05/24.
//

import Foundation
import UIKit
class UpdateKYCViewModel {
    
    private var failblock: BindFail? = nil
    private lazy var repo: UpdateKYCRepo? = UpdateKYCRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    func startKYCAPI(completion: @escaping(_ resStatus:Int,_ resData:[String:Any]?) ->()) {
        repo?.apiStartKYC(completion: { resStatus, resData in
            completion(resStatus,resData)
        })
    }
    func apiStartKYCSumSub(completion: @escaping(_ resStatus:Int,_ resData:GetKycToken?) -> ()) {
        repo?.apiStartKYCSumSub(completion: { resStatus, resData in
            completion(resStatus,resData)
        })
    }
    func finishKYCAPI(identificationId:String,completion: @escaping(_ resStatus:Int,_ resData:[[String:Any]]?) ->()) {
        repo?.apiFinishKYC(identificationId: identificationId, completion: { resStatus, resData in
            completion(resStatus,resData)
        })
    }
    func kycUploadDocumentAPI(documentImage:UIImage,completion: @escaping(_ resStatus:Int,_ resData:[[String:Any]]?) ->()) {
        repo?.apiKycUploadDocument(documentImage: documentImage, completion: { resStatus, resData in
            completion(resStatus,resData)
        })
    }
    
    
//    func apiGetKycLimit(completion: @escaping(Int,[String: KycLimitList]??) -> Void) {
//        repo?.apiGetKycLimit(completion: { resStatus, resData in
//            completion(resStatus,resData)
//        })
//    }
    func apiGetKycLimitNew(completion: @escaping(Int,String,KycLimitLists?) -> Void) {
        repo?.apiGetKycLimitNew(completion: { resStatus, resMsg, resData in
            completion(resStatus,resMsg,resData)
        })
    }
}

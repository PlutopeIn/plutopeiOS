//
//  CardUserProfileViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/05/24.
//

import Foundation

class CardUserProfileViewModel {
    
    private var failblock: BindFail? = nil
    private lazy var repo: CardUserProfileRepo? = CardUserProfileRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
 
//     func upateProfileAPI(profileData:ProfileList?,isfromRegister:Bool,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
//        
//         repo?.apiUpateProfile(profileData: profileData,isfromRegister: isfromRegister ,completion: { resStatus, message, dataValue in
//             if resStatus == 1 {
//                 completion(1, message, dataValue)
//             } else {
//                 completion(0, message, nil)
//                 
//             }
//         })
//         
//    }
//    func getProfileAPI(completion: @escaping(Int,CardUserDataList?) -> Void) {
//        repo?.apiGetProfile(completion: { status, data in
//            if status == 1 {
//                completion(1, data)
//            } else {
//                completion(0, nil)
//            }
//        })
//    }
    func getProfileAPINew(completion: @escaping(Int,String,CardUserDataList?) -> Void) {
        repo?.apiGetProfileNew(completion: { status,msg,data in
            if status == 1 {
                completion(1, msg,data)
            } else {
                completion(0,msg ,nil)
            }
        })
    }
    func apiUpateProfileNew(profileData:ProfileList?,isfromRegister:Bool,completion: @escaping(_ resStatus:Int, _ message: String) -> ()) {
        repo?.apiUpdateProfileNew(profileData: profileData, isfromRegister: isfromRegister, completion: { resStatus, message,res in
            if resStatus == 1 {
                completion(1, message)
            } else {
                completion(0, message)
                
            }
        })
    }
    
}
    

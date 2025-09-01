//
//  CardUserViewModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 20/03/24.
//

import Foundation
class CardUserViewModel {
    
    private var failblock: BindFail? = nil
    private lazy var repo: CardUserRepo? = CardUserRepo()
   
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    
    // sign-verify-otp
//    func signVerifyOtpAPI(mobile: String,otp: String, completion: @escaping(_ status :Int,_ message: String,_ resData:[String : Any]?)->()){
//        
//        repo?.apiSignVerifyOtp(mobile: mobile, otp: otp, completion: { resStatus, message, resData in
//            if resStatus == 1 {
//                completion(1, message, resData)
//            } else {
//                completion(0, message, nil)
//                //self.failblock?(resStatus,message)
//            }
//        })
//    }
    
   
    
    /// AddEmailAPI
//    func addEmailAPI(email: String,completion: @escaping(_ resStatus:Int,  _ message: String,_ dataValue:[String : Any]?)->()) {
//        repo?.apiAddEmail(email: email, completion: { resStatus, message, resData in
//            if resStatus == 1 {
//                completion(1, message, resData)
//            } else {
//                completion(0, message, nil)
//                //self.failblock?(resStatus,message)
//            }
//        })
//    }
    
    /// ConfirmEmailAPI
    func confirmEmailAPI(email: String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?)->()) {
        repo?.apiVerifyEmail(email: email, completion: { resStatus, message, resData in
            if resStatus == 1 {
                completion(1, message, resData)
            } else {
                completion(0, message, nil)
                //self.failblock?(resStatus,message)
            }
        })
    }
    func apiMobileEmailVerifyResend(completion: @escaping(_ resStatus:Int, _ message: String)->()) {
        repo?.apiMobileEmailVerifyResend(completion: { resStatus, message in
            completion(resStatus,message)
        })
    }
    
    /// live server
    ///  signUp
    func signUpAPINew(phone :String,password:String,completion: @escaping(_ resStatus:Int,_ message: String,_ dataValue:[String : Any]?) -> ()) {
        
        repo?.apiSignUpNew(phone: phone, password: password, completion: { resStatus, msg, data in
            if resStatus == 1 {
                completion(1, msg,data)
            } else {
               completion(0, msg,data)
            }
        })
    }
    
    // sign-verify-otp
    func signVerifyOtpAPINew(mobile: String,otp: String, completion: @escaping(_ status :Int,_ message: String,_ resData:[String : Any]?)->()) {
        
        repo?.apiSignVerifyOtpNew(mobile: mobile, otp: otp, completion: { resStatus, message, resData in
         
                completion(resStatus, message, resData)
            
        })
    }
    
    /// resendOtpAPI
    func resendOtpAPINew(mobile: String,completion: @escaping(_ resStatus:Int,_  message: String,_ dataValue:[String : Any]?)->()) {
        repo?.resendOtpAPINew(mobile: mobile, completion: { resStatus, message, resData in
            if resStatus == 1 {
                completion(1, message, resData)
            } else {
                completion(0, message, nil)
                //self.failblock?(resStatus,message)
            }
        })
    }
    
    /// AddEmailAPI
    func addEmailAPINew(email: String,completion: @escaping(_ resStatus:Int,  _ message: String,_ dataValue:[String : Any]?)->()) {
        repo?.apiAddEmailNew(email: email, completion: { resStatus, message, resData in
            if resStatus == 1 {
                completion(1, message, resData)
            } else {
                completion(0, message, nil)
                //self.failblock?(resStatus,message)
            }
        })
    }
    
    /// ConfirmEmailAPI
    func confirmEmailAPINew(email: String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?)->()) {
        repo?.apiVerifyEmailNew(email: email, token: "", completion: { resStatus, message, resData in
            if resStatus == 1 {
                completion(1, message, resData)
            } else {
                completion(0, message, nil)
                //self.failblock?(resStatus,message)
            }
        })
    }
    func apiMobileEmailVerifyResendNew(completion: @escaping(_ resStatus:Int, _ message: String)->()) {
        repo?.apiMobileEmailVerifyResendNew(completion: { resStatus, message in
            completion(resStatus,message)
        })
    }
}
    

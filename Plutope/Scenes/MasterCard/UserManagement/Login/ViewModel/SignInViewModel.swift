//
//  SignInViewModel.swift
//  Plutope
//
//  Created by sonoma on 16/05/24.
//

import Foundation
class SignInViewModel {
    
    private var failblock: BindFail? = nil
    private lazy var repo: SignInRepo? = SignInRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    
    ///  signIn
//    func signInAPI(phone :String,password:String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
//        
//        repo?.apiSignIn(phone: phone, password: password, completion: { resStatus, msg, data in
//            if resStatus == 1 {
//                completion(1, msg,data)
//            } else {
//                completion(0, msg,data)
//            }
//        })
//    }
//    func apiSignout(isfromRegister:Bool,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
//        repo?.apiSignout(isfromRegister: isfromRegister, completion: { resStatus, msg, data in
//            if resStatus == 1 {
//                completion(1, msg,data)
//            } else {
//                completion(0, msg,data)
//            }
//        })
//    }
    /// liv server 
    func apiSignInNew(phone: String, password: String, completion: @escaping (_ resStatus: Int, _ message: String, _ dataValue: [String:Any]?) -> ()) {
        repo?.apiSignInNew(phone: phone, password: password, completion: { resStatus, message, dataValue in
            if resStatus == 200 {
                completion(1, message,dataValue)
            } else {
                completion(0, message,dataValue)
            }
        })
    }
    func apiSignoutNew(isfromRegister:Bool,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
        repo?.apiSignoutNew(isfromRegister: isfromRegister, completion: {resStatus, msg, data in
            if resStatus == 1 {
                completion(1, msg,data)
            } else {
                completion(0, msg,data)
            }
        })
    }
}

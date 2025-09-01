//
//  ForgotPasswordViewModel.swift
//  Plutope
//
//  Created by sonoma on 17/05/24.
//

import Foundation
class ForgotPasswordViewModel {
    
    private var failblock: BindFail? = nil
    private lazy var repo: ForgotPasswordRepo? = ForgotPasswordRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    
    ///  ForgotPassword
    func forgotPasswordAPI(phone :String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
        
        repo?.apiForgotPassword(phone: phone, completion: { resStatus, msg, data in
            if resStatus == 1 {
                completion(1, msg,data)
            } else {
                completion(0, msg,data)
            }
        })
    }
    
   
    
    
    ///  reset Password
    func resetPasswordAPI(code :String,password :String,phone :String,completion: @escaping(_ resStatus:Int,_ message: String,_ dataValue:[String : Any]?) -> ()) {
        
        repo?.apiResetPassword(code: code,password: password,phone: phone, completion: { resStatus, msg, data in
            if resStatus == 1 {
                completion(1, msg,data)
            } else {
                completion(0, msg,data)
            }
        })
    }
    func apiChangePasswordNew(currentPassword :String,newPassword :String,completion: @escaping(_ resStatus:Int,_ message: String,_ dataValue:[String : Any]?) -> ()) {
        repo?.apiChangePasswordNew(currentPassword: currentPassword, newPassword: newPassword, completion: { resStatus, message, dataValue in
            completion(resStatus, message,dataValue)
        })
    }
    
    func apiForgotPasswordNew(phone :String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
        repo?.apiForgotPasswordNew(phone: phone, completion: { resStatus, msg, data in
            completion(resStatus, msg,data)
            
        })
    }
    ///  reset Confirm Code
    func resetConfirmCodeAPINew(code :String,phone :String,completion: @escaping(_ resStatus:Int,_ message: String,_ dataValue:[String : Any]?) -> ()) {
        repo?.apiConfirmCodeNew(code: code,phone: phone, completion: { resStatus, msg, data in
            if resStatus == 1 {
                completion(1, msg,data)
            } else {
                completion(0, msg,data)
            }
        })
    }
    ///  reset Password
    func apiResetPasswordNew(code :String,password :String,phone :String,completion: @escaping(_ resStatus:Int,_ message: String,_ dataValue:[String : Any]?) -> ()) {
        
        repo?.apiResetPasswordNew(code: code,password: password,phone: phone, completion: { resStatus, msg, data in
            if resStatus == 1 {
                completion(1, msg,data)
            } else {
                completion(0, msg,data)
            }
        })
    }
}

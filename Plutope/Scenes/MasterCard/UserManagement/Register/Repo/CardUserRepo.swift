//
//  CardUserRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 20/03/24.
//

import Foundation
import DGNetworkingServices

class CardUserRepo {

    /// sign-verify-otp Repo
//    func apiSignVerifyOtp(mobile: String,otp: String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?)->()) {
//        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.phoneConfirm
//        var parameter = [String:Any]()
//        parameter["phone"] = mobile
//        parameter["smsCode"] = otp
//        parameter["fingerprint"] = "12344444"
//        print("OTPParam =",parameter)
//        //showLoaderHUD()
//        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: nil) { status, error, data in
//            if status {
//                do {
//                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
//                    let status = data?["status"] as? Int
//                    let msg = data?["message"] as? String
//                    let datavalue = data?["data"] as? [String: Any]
//                    _ = datavalue?["result"] as? String
//                     if status == 200 {
//                         completion(1,msg ?? "", datavalue)
//                    } else if status  == 401 {
//                        logoutApp()
//                    } else {
//                        completion(0,msg ?? "",nil)
//                    }
//                    
//                } catch(let error) {
//                  
//                    print(error)
//                    completion(0,error.localizedDescription, nil)
//                }
//            } else {
//                if (error?.rawValue == "Access token expired") {
//                    logoutApp()
//                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
//                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
//                } else {
//                    completion(0,error?.rawValue ?? "",nil)
//                }
////                completion(0,error?.localizedDescription ?? "", nil)
//            }
//        }
//    }
    /// apiAddEmail Repo
//    func apiAddEmail(email: String,completion: @escaping(_ resStatus:Int,_  message: String,_ dataValue:[String : Any]?) -> ()) {
//        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.addEmail
//        var parameter = [String:Any]()
//        parameter["email"] = email
//        print("AddEmailParam =",parameter)
//        //showLoaderHUD()
//        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: ["auth": "\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
//            if status {
//                do {
//                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
//                    let status = data?["status"] as? Int
//                    let msg = data?["message"] as? String
//                    var datavalue = data?["data"] as? [String: Any]
//                    let result = datavalue?["result"] as? String
//                     if status == 200 {
//                         completion(1,msg ?? "", data)
//                    } else if status  == 401 {
//                        logoutApp()
//                    } else {
//                        completion(0,msg ?? "",nil)
//                    }
//                    
//                } catch(let error) {
//                  
//                    print(error)
//                    completion(0,error.localizedDescription, nil)
//                }
//            } else {
//                if (error?.rawValue == "Access token expired") {
//                    logoutApp()
//                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
//                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
//                } else {
//                    completion(0,error?.rawValue ?? "",nil)
//                }
////                completion(0,error?.localizedDescription ?? "", nil)
//            }
//        }
//    }
    /// apiverifyEmail Repo
    func apiVerifyEmail(email: String,completion: @escaping(_ resStatus:Int,_  message: String,_ dataValue:[String : Any]?) -> ()) {
//        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.addEmail
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.confirmEmail
        var parameter = [String:Any]()
        parameter["email"] = email
        print("ConfirmEmailParam =",parameter)
        //showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: nil) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    let status = data?["status"] as? Int
                    let msg = data?["message"] as? String
                    var datavalue = data?["data"] as? [String: Any]
                    let result = datavalue?["result"] as? String
                     if status == 200 {
                         completion(1,msg ?? "", data)
                    } else if status  == 401 {
                        logoutApp()
                    } else {
                        completion(0,msg ?? "",nil)
                    }
                    
                } catch(let error) {
                  
                    print(error)
                    completion(0,error.localizedDescription, nil)
                }
            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
                } else {
                    completion(0,error?.rawValue ?? "",nil)
                }
//                completion(0,error?.localizedDescription ?? "", nil)
            }
        }
    }
    func apiMobileEmailVerifyResend(completion: @escaping(_ resStatus:Int, _ message: String)->()) {
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.mobileEmailVerify
     
        //showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: nil, headers: nil) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    let status = data?["status"] as? Int
                    let msg = data?["message"] as? String
                    
                     if status == 200 {
                         completion(1,msg ?? "")
                    } else if status  == 401  {
                        logoutApp()
                    } else {
                        completion(0,msg ?? "")
                    }
                    
                } catch(let error) {
                  
                    print(error)
                    completion(0,error.localizedDescription)
                }
            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.")
                } else {
                    completion(0,error?.rawValue ?? "")
                }
//                completion(0,error?.localizedDescription ?? "")
            }
        }
    }
}

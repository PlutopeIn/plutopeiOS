//
//  CardUserRepo + NewApis.swift
//  Plutope
//
//  Created by Trupti Mistry on 12/07/24.
//

import Foundation
import UIKit
import DGNetworkingServices
/// Live Server
extension CardUserRepo {
    
    /// SignUp Repo
    func apiSignUpNew(phone :String,password:String,completion: @escaping(_ resStatus:Int,_ message: String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion + ServiceNameConstant.signupNew
        var parameter = [String:Any]()
        parameter["phone"] = phone
        parameter["password"] = password
        print("RegisterParam =",parameter)
        let merchantId = merchantID
        
        var header = [String:String]()
        header["X-Merchant-ID"] = merchantId
        header["X-Version"] = headerVersion
        print("header =",header)
//        = ["X-Merchant-ID": merchantID,"X-Version":xVersion] as [String : Any]
        // showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: header) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
//                            if error == "You are not authorised for this request." {
//                                logoutApp()
//                            } else {
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0, decodeResult.message ?? "", nil)
                                                          
//                            }
                           
                        } else {
                            let datavalue = json["data"] as? [String: Any]
                            completion(1, "",datavalue)
                        }
                    } else {
                        completion(0, "",nil)
                    }

                } catch let error {
                    print("Decoding error: \(error)")
                    completion(0,error.localizedDescription, nil)
                }
            } else {
                if (error?.rawValue == "Access token expired") {
                   // logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
                } else {
                    completion(0,error?.rawValue ?? "",nil)
                }
//                completion(0,error?.localizedDescription ?? "", nil)
            }
        }
    }

    /// sign-verify-otp Repo
    func apiSignVerifyOtpNew(mobile: String,otp: String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?)->()) {
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion + ServiceNameConstant.confirmOtp
        var parameter = [String:Any]()
        parameter["phone"] = mobile
        parameter["smsCode"] = otp
        parameter["fingerprint"] = "12344444"
        print("OTPParam =",parameter)
        //showLoaderHUD()
        let header = ["X-Merchant-ID": merchantID]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: header) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
//                            if error == "You are not authorised for this request." {
//                                logoutApp()
//                            } else {
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0, decodeResult.message ?? "", nil)
//                            }
                           
                        } else {
                            let datavalue = json as? [String: Any]
                            completion(1, "",datavalue)
                        }
                    } else {
                        completion(0, "",nil)
                    }

                } catch let error {
                    print("Decoding error: \(error)")
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
    
    /// resendOtpAPI
    func resendOtpAPINew(mobile: String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?)->()) {
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion + ServiceNameConstant.resendOtpNew
        var parameter = [String:Any]()
        parameter["phone"] = mobile
        
        var header = [String:String]()
        header["X-Fingerprint"] = "12344444"
        header["X-Merchant-ID"] = merchantID
        header["X-Version"] = headerVersion
        
        print("header =",header)
        print("ResendOTPParam =",parameter)
        //showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: header) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
//                            if error == "You are not authorised for this request." {
//                                logoutApp()
//                            } else {
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0, decodeResult.message ?? "", nil)
//                            }
                           
                        } else {
                            let datavalue = json as? [String: Any]
                            completion(1, "",datavalue)
                        }
                    } else {
                        completion(0, "",nil)
                    }

                } catch let error {
                    print("Decoding error: \(error)")
                    completion(0,error.localizedDescription, nil)
                }            } else {
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
    /// apiAddEmail Repo
    func apiAddEmailNew(email: String,completion: @escaping(_ resStatus:Int,_  message: String,_ dataValue:[String : Any]?) -> ()) {
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion + ServiceNameConstant.confirmAddmail
        var parameter = [String:Any]()
        parameter["email"] = email
        print("AddEmailParam =",parameter)
        //showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .put, parameters: parameter, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
//                            if error == "You are not authorised for this request." {
//                                logoutApp()
//                            } else {
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0, decodeResult.message ?? "", nil)
//                            }
                           
                        } else {
                            let datavalue = json as? [String: Any]
                            completion(1, "",datavalue)
                        }
                    } else {
                        completion(0, "",nil)
                    }

                } catch let error {
                    print("Decoding error: \(error)")
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
    /// apiverifyEmail Repo
    func apiVerifyEmailNew(email: String,token:String,completion: @escaping(_ resStatus:Int,_  message: String,_ dataValue:[String : Any]?) -> ()) {
//        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.addEmail
        
        let baseUel = ServiceNameConstant.BaseUrl.baseUrlNew
        let version = ServiceNameConstant.appVersion
        let requestUrl = ServiceNameConstant.confirmEmailNew
        let apiUrl = "\(baseUel)\(version)\(requestUrl)?token=\(token)"
        
        // ?token=
        var parameter = [String:Any]()
        parameter["email"] = email
        print("ConfirmEmailParam =",parameter)
        //showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: nil) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
//                            if error == "You are not authorised for this request." {
//                                logoutApp()
//                            } else {
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0, decodeResult.message ?? "", nil)
//                            }
                            
                        } else {
                            let datavalue = json as? [String: Any]
                            completion(1, "",datavalue)
                        }
                    } else {
                        completion(0, "",nil)
                    }
                    
                } catch let error {
                    print("Decoding error: \(error)")
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
    func apiMobileEmailVerifyResendNew(completion: @escaping(_ resStatus:Int, _ message: String)->()) {
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion + ServiceNameConstant.mobileEmailVerify
     
        //showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: nil, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
//                            if error == "You are not authorised for this request." {
//                                logoutApp()
//                            } else {
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0, decodeResult.message ?? "")
//                            }
                            
                        } else {
                            let datavalue = json["data"] as? [String: Any]
                            completion(1, "")
                        }
                    } else {
                        completion(0, "")
                    }
                    
                } catch let error {
                    print("Decoding error: \(error)")
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

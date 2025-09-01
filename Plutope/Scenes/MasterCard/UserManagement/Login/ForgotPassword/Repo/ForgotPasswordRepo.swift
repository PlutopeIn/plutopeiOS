//
//  ForgotPasswordRepo.swift
//  Plutope
//
//  Created by sonoma on 17/05/24.
//

import Foundation
import DGNetworkingServices

class ForgotPasswordRepo {
    /// ForgotPassword Repo
    func apiForgotPassword(phone :String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.resetPassword
        var parameter = [String:Any]()
        parameter["phone"] = phone
        print("SignInParam =",parameter)
        //showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: nil) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    let status = data?["status"] as? Int
                    let msg = data?["message"] as? String
                    let datavalue = data?["data"] as? [String: Any]
                    _ = datavalue?["result"] as? String
                    if status == 200 {
                        completion(1,msg ?? "", datavalue)
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
    /// ResetPassword Repo
    func apiResetPassword(code :String,password :String,phone :String,completion: @escaping(_ resStatus:Int,_ message: String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.setPassword
        var parameter = [String:Any]()
        parameter["code"] = code
        parameter["password"] = password
        parameter["phone"] = phone
        print("resetPasswordParam =",parameter)
        //showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: nil) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    let status = data?["status"] as? Int
                    let msg = data?["message"] as? String
                    let datavalue = data?["data"] as? [String: Any]
                    _ = datavalue?["result"] as? String
                    if status == 200 {
                        completion(1,msg ?? "", datavalue)
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
    /// change password  live
    func apiChangePasswordNew(currentPassword :String,newPassword :String,completion: @escaping(_ resStatus:Int,_ message: String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion + ServiceNameConstant.passwordChangeNew
        var parameter = [String:Any]()
        parameter["currentPassword"] = currentPassword
        parameter["newPassword"] = newPassword
        
        print("changePasswordParam =",parameter)
        //showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .put, parameters: parameter, headers: ["Authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {
                    // Decode response to a dictionary first
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0, decodeResult.message ?? "", nil)
//                            }
                            
                        } else {
                            // Handle success response
                            let decodeResult = data as? [String:Any]
                            completion(1,"", decodeResult)
                        }
                    } else {
                        completion(0,"",nil)
                    }
                } catch(let error) {
                    print(error)
                    completion(0, error.localizedDescription,nil)
                }
            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
                } else {
                    completion(0,error?.rawValue ?? "",nil)
                }
            }
        }
    }
    
    func apiForgotPasswordNew(phone :String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion + ServiceNameConstant.resetPaawordNew
        var parameter = [String:Any]()
       
        parameter["phone"] = phone
        print("ForgotPasswor =",parameter)
        
        let merchantId = merchantID
        var header = [String:String]()
        header["X-Merchant-ID"] = merchantId
        header["X-Version"] = headerVersion
        print("header =",header)
        //showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: header) { status, error, data in
            if status {
                do {
                    // Decode response to a dictionary first
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0, decodeResult.message ?? "", nil)
//                            }
                            
                        } else {
                            // Handle success response
                            let decodeResult = data as? [String:Any]
                            completion(1,"", decodeResult)
                        }
                    } else {
                        completion(0,"",nil)
                    }
                } catch(let error) {
                    print(error)
                    completion(0, error.localizedDescription,nil)
                }
            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
                } else {
                    completion(0,error?.rawValue ?? "",nil)
                }
            }
        }
    }
    /// ConfirmCode Repo
    func apiConfirmCodeNew(code :String,phone :String,completion: @escaping(_ resStatus:Int,_ message: String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion +  ServiceNameConstant.resetConfirmCodeNew
        var parameter = [String:Any]()
        parameter["code"] = code
        parameter["phone"] = phone
        print("ConfirmCodeParam =",parameter)
        let merchantId = merchantID
        var header = [String:String]()
        header["X-Merchant-ID"] = merchantId
        header["X-Version"] = headerVersion
        print("header =",header)
        // ["Authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: header) { status, error, data in
            if status {
                do {
                    // Decode response to a dictionary first
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0, decodeResult.message ?? "", nil)
                            
                        } else {
                            // Handle success response
                            let decodeResult = data as? [String:Any]
                            completion(1,"", decodeResult)
                        }
                    } else {
                        completion(0,"",nil)
                    }
                } catch(let error) {
                    print(error)
                    completion(0, error.localizedDescription,nil)
                }
            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
                } else {
                    completion(0,error?.rawValue ?? "",nil)
                }
            }
        }
    }
    /// ResetPassword Repo
    func apiResetPasswordNew(code :String,password :String,phone :String,completion: @escaping(_ resStatus:Int,_ message: String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion + ServiceNameConstant.confirmPasswordNew
        var parameter = [String:Any]()
        parameter["code"] = code
        parameter["password"] = password
        parameter["phone"] = phone
        print("resetPasswordParam =",parameter)
        let merchantId = merchantID
        var header = [String:String]()
        header["X-Merchant-ID"] = merchantId
        header["X-Version"] = headerVersion
        print("header =",header)
        // ["Authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: header) { status, error, data in
            if status {
                do {
                    // Decode response to a dictionary first
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0, decodeResult.message ?? "", nil)
                            
                        } else {
                            // Handle success response
                            let decodeResult = data as? [String:Any]
                            completion(1,"", decodeResult)
                        }
                    } else {
                        completion(0,"",nil)
                    }
                } catch(let error) {
                    print(error)
                    completion(0, error.localizedDescription,nil)
                }
            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
                } else {
                    completion(0,error?.rawValue ?? "",nil)
                }
            }
        }
    }
    
}

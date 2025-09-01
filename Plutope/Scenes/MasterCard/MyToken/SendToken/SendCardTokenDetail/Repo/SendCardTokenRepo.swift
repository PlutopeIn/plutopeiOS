//
//  SendCardTokenRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/06/24.
//

import Foundation
import DGNetworkingServices
class SendCardTokenRepo {
    func getFee(currency:String,amount:String,address:String,phone:String,isFrom:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:GetTokenFeeList?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        
        let apiRequestUrl = ServiceNameConstant.getFeeCurrencyNew
        var apiUrl = ""
        if isFrom == "walletAddress" {
             apiUrl = "\(apiBaseUrl)\(apiRequestUrl)/\(currency)?address=\(address)&amount=\(amount)"
        } else {
             apiUrl = "\(apiBaseUrl)\(apiRequestUrl)/\(currency)?amount=\(amount)&phone=\(phone)"
        }
        
        print(apiUrl)
        //  /v1/wallet/send/fee/USDT?address=dffdd&amount=ffff&phone=fff
        
        var header = [String:String]()
        header["authorization"] = "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"
        print("header =",header)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: header) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
                            
                            let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                            completion(0,decodeResult.message ?? "",nil)
                            
                        } else {
                            // Handle success response
                            let decodeResult = try JSONDecoder().decode(GetTokenFeeList.self, from: data ?? Data())
                            
                            completion(1,"",decodeResult)
                        }
                    } else {
                        completion(0,"",nil)
                    }
                } catch(let error) {
                    
                    print(error)
                    completion(0,error.localizedDescription,nil)
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
    func apiWalletSendVerification(phone:String,amount:String,address:String,currency:String,isFrom:String,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ dataValue:WalletSendValidateList?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl = ServiceNameConstant.walletSendValidateNew
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)"
        
        var parameter = [String:Any]()
        if isFrom == "phone" {
            parameter["phone"] = phone
        } else {
            parameter["address"] = address
        }
        parameter["amount"] = amount
        parameter["currency"] = currency
        //        parameter["publicKey"] = publicKey
        print("Param =",parameter)
        var header = [String:String]()
        header["authorization"] = "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"
        print("header =",header)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: header) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
                            
                            let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                            completion(0,decodeResult.message ?? "",nil)
                            
                        } else {
                            // Handle success response
                            let decodeResult = try JSONDecoder().decode(WalletSendValidateList.self, from: data ?? Data())
                            
                            completion(1,"",decodeResult)
                        }
                    } else {
                        completion(0,"",nil)
                    }
                } catch(let error) {
                    
                    print(error)
                    completion(0,error.localizedDescription,nil)
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
    func apiWalletSend(fee:String,phone:String,amount:String,address:String,currency:String,isFrom:String,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ resValue:[String:Any]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl = ServiceNameConstant.walletSendNew
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)"
        
        var parameter = [String:Any]()
        parameter["fee"] = fee
        if isFrom == "phone" {
            parameter["phone"] = phone
        } else {
            parameter["address"] = address
        }
        parameter["amount"] = amount
        
        parameter["currency"] = currency
        //        parameter["publicKey"] = publicKey
        print("Param =",parameter)
        var header = [String:String]()
        header["authorization"] = "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"
        print("header =",header)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: header) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
                            
                            let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                            completion(0,decodeResult.message ?? "",nil)
                            
                        } else {
                            // Handle success response
                            let decodeResult = json as? [String:Any]
                            
                            completion(1,"",decodeResult)
                        }
                    } else {
                        completion(0,"",nil)
                    }
                } catch(let error) {
                    
                    print(error)
                    completion(0,error.localizedDescription,nil)
                }            } else {
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

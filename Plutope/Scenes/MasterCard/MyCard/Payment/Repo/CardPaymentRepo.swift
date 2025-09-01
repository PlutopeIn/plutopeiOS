//
//  CardPaymentRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 04/06/24.
//

import Foundation

import DGNetworkingServices

class CardPaymentRepo {
    
    func apiPaymentOffer(currency:String,id:String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let paymentOfferUrl = ServiceNameConstant.cardRequestsNew
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(paymentOfferUrl)/\(id)/payment-offer/\(currency)?cp=CP_2"
        //card/card-requests/id/payment-offer/BTC?cp=CP_2
        var header = [String:String]()
        header["User-Agent"] = "vault/4.0(508) dart/3.2 (dart:io) ios/17.3.1; iphone 9da12fa6-716c-4cdc-a24"
        header["authorization"] = "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"
        print("header =",header)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: nil, headers: header) { status, error, data in
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
                            completion(0,decodeResult.message ?? "",nil)
                            //                            }
                            
                        } else {
                            // Handle success response
                            let decodeResult = json as? [String: Any]
                            
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
    func apiPaymentOfferConfirm(id:String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let paymentOfferUrl = ServiceNameConstant.cardRequestsNew
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(paymentOfferUrl)/payment-offer/\(id)/confirm?cp=CP_2"
        print(apiUrl)
        
        var header = [String:String]()
        header["authorization"] = "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"
        print("header =",header)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: nil, headers: header) { status, error, data in
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
                            let decodeResult = json as? [String: Any]
                            
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
   
}

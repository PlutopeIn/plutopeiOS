//
//  TopUpCardRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 05/06/24.
//

import Foundation
import DGNetworkingServices
class TopUpCardRepo {
    
    func getCardPayloadCurrencies(completion: @escaping(_ resStatus:Int,String,_ dataValue:TopUpCurrencys?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiCardUrl = ServiceNameConstant.BaseUrl.card
        let apiRequestUrl = ServiceNameConstant.payloadNew
        
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiCardUrl)\(apiRequestUrl)/currencies?cp=CP_2"
        let headers = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
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
                          
                            
                            let decodeResult = try JSONDecoder().decode(TopUpCurrencys.self, from: data ?? Data())
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
    
    func getCardPayloadOtherData(cardRequestId:String,completion: @escaping(_ resStatus:Int,String,_ dataValue:PayloadOtherList?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiCardUrl = ServiceNameConstant.BaseUrl.card
        let apiRequestUrl = ServiceNameConstant.payloadNew
        
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiCardUrl)\(cardRequestId)/\(apiRequestUrl)/data?cp=CP_2"
//        v2/card/97/payload/data?cp=CP_2
        
        let headers = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
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
                            let decodeResult = try JSONDecoder().decode(PayloadOtherList.self, from: data ?? Data())
                            
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
//        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { result in
//            switch result {
//                
//            case .success((_, let response)):
//                do {
//                    let resData = try JSONDecoder().decode(PayloadOtherData.self, from: response)
//                    if resData.status == 200 {
//                        completion(1, resData.data)
//                    } else if resData.status  == 401 {
//                        logoutApp()
//                    } else {
//                        completion(0,nil)
//                    }
//                } catch(let error) {
//                    print(error)
//                    completion(0, nil)
//                }
//            case .failure(let error):
//                print(error)
//                let errValue = error.rawValue
//                if (errValue == "Access token expired") {
//                    logoutApp()
//                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
//                    completion(0,nil)
//                } else {
//                    completion(0, nil)
//                }
////                completion(0, nil)
//            }
//        }
    }
    //    Create Card Payload Offer
    func apiCreateCardPayloadOffer(cardId:String,fromCurrency:String,toCurrency:String,fromAmount:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:CreateCardPayloadOfferList?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiCardUrl = ServiceNameConstant.BaseUrl.card
        let apiPayloadUrl = ServiceNameConstant.payloadNew
        let apiRequestUrl = ServiceNameConstant.createCardPayloadOffer
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiCardUrl)\(cardId)/\(apiPayloadUrl)/\(apiRequestUrl)?cp=CP_2"
//        card/{cardId}/payload/offers
//        /v2/card/ds/payload/offers?cp=CP_2
        var parameter = [String:Any]()
        parameter["cardId"] = cardId
        parameter["fromCurrency"] = fromCurrency
        parameter["toCurrency"] = toCurrency
        parameter["fromAmount"] = fromAmount
//        parameter["publicKey"] = publicKey
        print("Param =",parameter)
        let headers = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: headers) { status, error, data in
            if status {
                do {
                    // Decode response to a dictionary first
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                            completion(0, decodeResult.message ?? "",nil)
//                            }
                            
                        } else {
                            // Handle success response
                            let decodeResult = try JSONDecoder().decode(CreateCardPayloadOfferList.self, from: data ?? Data())
                            completion(1,"",decodeResult)
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
 
    func apiPayloadOfferConfirm(cardId:String,offerId:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:[String:Any]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiCardUrl = ServiceNameConstant.BaseUrl.card
        let apiRequestUrl = ServiceNameConstant.payloadNew
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiCardUrl)\(cardId)/\(apiRequestUrl)/offers/\(offerId)/confirm?cp=CP_2"
      
        let headers = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: nil, headers: headers) { status, error, data in
            if status {
                do {
                    // Decode response to a dictionary first
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                            completion(0, decodeResult.message ?? "",nil)
//                            }
                            
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

//
}

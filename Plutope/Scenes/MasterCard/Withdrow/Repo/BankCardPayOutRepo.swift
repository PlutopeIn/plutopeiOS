//
//  BankCardPayOutRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 04/07/24.
//

import Foundation
import DGNetworkingServices
class BankCardPayOutRepo {


    func getPayOutOtherDataLive(cardRequestId:String,completion: @escaping(_ resStatus:Int,_ dataValue:PayOutOtherDataList?,_ resMessage:String) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl = ServiceNameConstant.payoutData
        
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)"
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
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
                                completion(0, nil,decodeResult.message ?? "")
                          //  }
                           
                        } else {
                            // Handle success response
                            let decodeResult = try JSONDecoder().decode(PayOutOtherDataList.self, from: data ?? Data())
                            completion(1,decodeResult,"")
                        }
                    } else {
                        completion(0,nil,"")
                    }
                } catch(let error) {
                    
                    print(error)
                    completion(0, nil,error.localizedDescription)
                }            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,nil,"it looks like your device is offline please make sure your internet connection is stable.")
                } else {
                    completion(0, nil,error?.rawValue ?? "")
                }
//                completion(0, nil,error?.rawValue ?? "")
            }
        }
    }
    func apiPayOutAddCard(addCardPayout : AddCardPayout?,completion: @escaping(_ resStatus:Int,_ dataValue:[String:Any]?,_ resMessage : String) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl = ServiceNameConstant.payoutAddCardNew
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)"
        
        var parameter = [String:Any]()
        parameter["cardHolder"] = addCardPayout?.cardHolder
        parameter["cardNumber"] = addCardPayout?.cardNumber
        parameter["cardExpirationYear"] = addCardPayout?.cardExpirationYear
        parameter["cardExpirationMonth"] = addCardPayout?.cardExpirationMonth
        print("addCardPayoutParam =",parameter)
        
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
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
                                completion(0, nil,decodeResult.message ?? "")
                          //  }
                           
                        } else {
                            // Handle success response
                            let decodeResult = data as? [String:Any]
                            completion(1,decodeResult,"Card Added SucessFully")
                        }
                    } else {
                        completion(0,nil,"")
                    }
                } catch(let error) {
                    
                    print(error)
                    completion(0, nil,error.localizedDescription)
                }            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,nil,"it looks like your device is offline please make sure your internet connection is stable.")
                } else {
                    completion(0, nil,error?.rawValue ?? "")
                }
//                completion(0, nil,error?.rawValue ?? "")
            }
        }
    }
    func apiPayOutOfferCreate(amount:String,cardId:String,toCurrency:String,fromCurrency:String,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ resData :[String:Any]?) -> ()) {
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl = ServiceNameConstant.payoutCreateOfferNew
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)"
        
        var parameter = [String:Any]()
        parameter["amount"] = amount
        parameter["cardId"] = cardId
       // parameter["operation"] = operation
        parameter["toCurrency"] = toCurrency
        parameter["fromCurrency"] = fromCurrency
       // parameter["cardCVV"] = cardCVV
        print("Param =",parameter)
        
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
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
                }
            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
                } else {
                    completion(0,error?.rawValue ?? "",nil)
                }
//                completion(0,error?.rawValue ?? "",nil)
            }
        }
    }
    
    func apiPayOutOfferUpdate(amount:String,cardId:String,toCurrency:String,fromCurrency:String,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ resData :PayOutCreateOfferList?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.BaseUrl.clientVersion
        let apiuserUrl = ServiceNameConstant.BaseUrl.user
        let apiRequestUrl = ServiceNameConstant.payoutUpdateOffer
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiuserUrl)\(apiRequestUrl)/\(cardId)"
        
        var parameter = [String:Any]()
        parameter["amount"] = amount
        parameter["toCurrency"] = toCurrency
        parameter["fromCurrency"] = fromCurrency
        print("Param =",parameter)
        
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {

                    let resData = try JSONDecoder().decode(PayOutCreateOfferData.self, from: data ?? Data())
                    if resData.status == 200 {
                        completion(1, "",resData.data)
                    } else if resData.status == 401 {
                        logoutApp()
                    } else {
                        let failureData = try JSONDecoder().decode(FailureResponse.self, from: data ?? Data())
                        completion(0, failureData.message, nil)
                    }
                    
                } catch(let error) {
                    print(error)
                    completion(0,error.localizedDescription,nil)
                }
            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
                } else {
                    completion(0,error?.rawValue ?? "",nil)
                }
//                completion(0,error?.rawValue ?? "",nil)
            }
        }
    }
    func apipayOutExecuteOfferPayment(id:String,completion: @escaping(_  resStatus:Int,_ resMessage : String) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl = ServiceNameConstant.payoutExicuteOfferNew
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)/\(id)"
        
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
                                completion(0,decodeResult.message ?? "")
//                            }
                           
                        } else {
                            // Handle success response
                            let decodeResult = json as? [String: Any]
                            
                            completion(1,"")
                        }
                    } else {
                        completion(0,"")
                    }
                } catch(let error) {
                    
                    print(error)
                    completion(0,error.localizedDescription)
                }            } else {
                completion(0,"")
            }
        }
    }

}

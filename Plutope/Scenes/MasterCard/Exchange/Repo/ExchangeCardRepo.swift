//
//  ExchangeCardRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 20/06/24.
//

import Foundation
import DGNetworkingServices
class ExchangeCardRepo {
    
    func getExchangeCurrency(completion: @escaping(_ resStatus:Int,_ dataValue:ExchangeCurrencyList?,_ resMessage:String) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl = ServiceNameConstant.exchangeDataNew
        
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)/currencies"
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { result in
            switch result {
                
            case .success((_, let response)):
                do {
                    if let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
//                            if error == "You are not authorised for this request." {
//                                logoutApp()
//                            } else {
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: response)
                                completion(0, nil,decodeResult.message ?? "")
//                            }
                           
                        } else {
                            // Handle success response
                            let decodeResult = try JSONDecoder().decode(ExchangeCurrencyList.self, from: response)
                            
                            completion(1,decodeResult,"")
                        }
                    } else {
                        completion(0,nil,"")
                    }
                } catch(let error) {
                    
                    print(error)
                    completion(0, nil,error.localizedDescription)
                }

//                do {
//                    let resData = try JSONDecoder().decode(ExchangeCurrencyData.self, from: response)
//                    if resData.status == 200 {
//                        completion(1, resData.data, "")
//                    } else if resData.status == 401 {
//                        logoutApp()
//                    } else {
//                        completion(0,nil, resData.message ?? "")
//                    }
//                } catch(let error) {
//                    print(error)
//                    completion(0, nil,error.localizedDescription)
//                }
            case .failure(let error):
                print(error)
//                completion(0, nil,error.rawValue)
                let errValue = error.rawValue
                if (errValue == "Access token expired") {
                    logoutApp()
                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,nil,"it looks like your device is offline please make sure your internet connection is stable.")
                } else {
                    completion(0,nil,error.rawValue)
                }
            }
        }
    }
    
    func apiExchangeOffer(amountTo:String,amountFrom:String,currencyTo:String,currencyFrom:String,completion: @escaping(_ resStatus:Int,_ dataValue:[String:Any]?,_ resMessage : String) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl = ServiceNameConstant.exchangeNew
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)/offer"
        
        var parameter = [String:Any]()
        parameter["currencyFrom"] = currencyFrom
        parameter["currencyTo"] = currencyTo
        parameter["amountFrom"] = amountFrom
        parameter["amountTo"] = amountTo
      
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
                                completion(0,nil,decodeResult.message ?? "")
//                            }
                           
                        } else {
                            // Handle success response
                            let decodeResult = json as? [String: Any]
                            
                            completion(1,decodeResult,"")
                        }
                    } else {
                        completion(0,nil,"")
                    }
                } catch(let error) {
                    
                    print(error)
                    completion(0,nil,error.localizedDescription)
                }

            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,nil,"it looks like your device is offline please make sure your internet connection is stable.")
                } else {
                    completion(0,nil,error?.rawValue ?? "")
                }
               
            }
        }
    }
    
    func getExchangeExecuteOffer(offerId:Int,completion: @escaping(_ resStatus:Int,_ resMessage:String) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl = ServiceNameConstant.exchangeNew
        
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)/offer/\(offerId)"
        
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .put, parameters: nil, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
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

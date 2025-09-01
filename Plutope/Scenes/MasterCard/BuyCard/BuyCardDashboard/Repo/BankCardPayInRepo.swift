//
//  BankCardPayInRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 31/05/24.
//

import Foundation
import DGNetworkingServices
class BankCardPayInRepo {
    
    func getPayinFiatRates(completion: @escaping(_ resStatus:Int,String,_ dataValue:[PayinFiatRates]?) -> ()) {
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl = ServiceNameConstant.payinFiatRatesNew
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)"
        let header = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        print(header)
        
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: header) { result in
            switch result {
            case .success((_, let response)):
                do {
                    if let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")

                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: response)
                                completion(0, decodeResult.message ?? "", nil)
                        } else {
                            let decodeResult = try JSONDecoder().decode(PayinFiatRate.self, from: response)
                            print(decodeResult)
                            completion(1, "",decodeResult)
                        }
                    } else {
                        completion(0, "",nil)
                    }

                } catch let error {
                    print("Decoding error: \(error)")
                    completion(0,error.localizedDescription, nil)
                }
            case .failure(let error):
                let errValue = error.rawValue
                if (errValue == "Access token expired") {
                    logoutApp()
                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,errValue, nil)
                } else {
                    completion(0, errValue,nil)
                }
            }
        }
    }
    func getPayInOtherData(cardRequestId:String,completion: @escaping(_ resStatus:Int,_ resMessage:String,_ dataValue:PayInOtherDataList?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl = ServiceNameConstant.payinRatesCardsNew
        
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)"
        let header = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        print(header)
        
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: header) { result in
            switch result {
            case .success((_, let response)):
                do {
                    if let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")

                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: response)
                                completion(0, decodeResult.message ?? "", nil)
                        } else {
                            let decodeResult = try JSONDecoder().decode(PayInOtherDataList.self, from: response)
                            print(decodeResult)
                            completion(1, "",decodeResult)
                        }
                    } else {
                        completion(0, "",nil)
                    }

                } catch let error {
                    print("Decoding error: \(error)")
                    completion(0,error.localizedDescription, nil)
                }
            case .failure(let error):
                let errValue = error.rawValue
                if (errValue == "Access token expired") {
                    logoutApp()
                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,errValue, nil)
                } else {
                    completion(0, errValue,nil)
                }
            }
        }
    }
    func apiPayinAddCard(addCardPaying : AddCardPaying?,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ dataValue:[String:Any]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl = ServiceNameConstant.payinAddCardNew
        
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)"
        
        var parameter = [String:Any]()
        parameter["cardHolder"] = addCardPaying?.cardHolder
        parameter["cardNumber"] = addCardPaying?.cardNumber
        parameter["cardExpirationYear"] = addCardPaying?.cardExpirationYear
        parameter["cardExpirationMonth"] = addCardPaying?.cardExpirationMonth

        let billingAddress: [String: Any] = [
            "address": addCardPaying?.address ?? "",
            "city": addCardPaying?.city ?? "",
            "countryCode": addCardPaying?.countryCode ?? "",
            "zip": addCardPaying?.zip ?? "",
            "state": addCardPaying?.state ?? ""
        ]

        parameter["billingAddress"] = billingAddress
       
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
                                completion(0, decodeResult.message ?? "", nil)

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
    func apipayinCardBillingAddress(addCardBiling : AddCardPaying?,id:String,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ dataValue:[String:Any]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiuserUrl = ServiceNameConstant.payinAddCardNew
        let apiRequestUrl = ServiceNameConstant.payinCardBillingAddressNew
        let apiUrl = "\(apiBaseUrl)\(apiuserUrl)/\(id)/\(apiRequestUrl)"

        var parameter = [String:Any]()
        parameter["zip"] = addCardBiling?.zip
        parameter["city"] = addCardBiling?.city
        parameter["state"] = addCardBiling?.state
        parameter["address"] = addCardBiling?.address
        parameter["countryCode"] = addCardBiling?.countryCode
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
                                completion(0, decodeResult.message ?? "", nil)

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
    func apiPayinOfferCreate(amount:String,cardId:String,operation:String,toCurrency:String,fromCurrency:String,cardCVV:String,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ resData :PayinCreateOfferList?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl = ServiceNameConstant.payinOfferCreateNew
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)"
        var parameter = [String:Any]()
        parameter["amount"] = amount
        parameter["cardId"] = cardId
        parameter["operation"] = operation
        parameter["toCurrency"] = toCurrency
        parameter["fromCurrency"] = fromCurrency
//        parameter["cardCVV"] = cardCVV
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
                                completion(0, decodeResult.message ?? "", nil)

                        } else {
                            // Handle success response
                            let decodeResult = try JSONDecoder().decode(PayinCreateOfferList.self, from: data ?? Data())
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
    func apipayinExecuteOfferPayment(cardCVV:String,id:String,completion: @escaping(_ resStatus:Int,_ resMessage : String,_ dataValue:PayinExecuteeOfferList?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
       
        let apiRequestUrl = ServiceNameConstant.payinExecuteOfferPaymentNew
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)\(id)"
        
        var parameter = [String:Any]()
        parameter["cardCVV"] = cardCVV
      
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
                                completion(0, decodeResult.message ?? "", nil)

                        } else {
                            // Handle success response
                            let decodeResult = try JSONDecoder().decode(PayinExecuteeOfferList.self, from: data ?? Data())
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
    
    func getpayinPayCallback(id:String,completion: @escaping(_ resStatus:Int,_ resMsg : String,_ dataValue:PayinPayCallbackList?) -> ()) {
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl = ServiceNameConstant.payinPayCallbackNew
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)?offerId=\(id)"
        
        let header = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        print(header)
        
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: header) { result in
            switch result {
            case .success((_, let response)):
                do {
                    if let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")

                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: response)
                                completion(0, decodeResult.message ?? "", nil)
                        } else {
                            let decodeResult = try JSONDecoder().decode(PayinPayCallbackList.self, from: response)
                            print(decodeResult)
                            completion(1, "",decodeResult)
                        }
                    } else {
                        completion(0, "",nil)
                    }
                } catch let error {
                    print("Decoding error: \(error)")
                    completion(0,error.localizedDescription, nil)
                }
            case .failure(let error):
                let errValue = error.rawValue
                if (errValue == "Access token expired") {
                    logoutApp()
                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,errValue, nil)
                } else {
                    completion(0, errValue,nil)
                }
            }
        }
    }
}

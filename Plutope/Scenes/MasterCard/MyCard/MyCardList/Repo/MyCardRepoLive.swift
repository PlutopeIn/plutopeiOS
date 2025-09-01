//
//  MyCardRepoLive.swift
//  Plutope
//
//  Created by Trupti Mistry on 12/07/24.
//

import Foundation
import UIKit
import DGNetworkingServices
extension MyCardRepo {
    func apiCardRequestsNew(cardType:String,cardDesignId:String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
       
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiRequestUrl =  ServiceNameConstant.cardRequestsNew
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiRequestUrl)?cp=CP_2"
        
        print("apiUrl",apiUrl)
        var parameter = [String:Any]()
        parameter["cardType"] = cardType
        parameter["cardDesignId"] = cardDesignId
        print("ProfileParam =",parameter)
        
        var header = [String:String]()
        header["User-Agent"] = "vault/4.0(508) dart/3.2 (dart:io) ios/17.3.1; iphone 9da12fa6-716c-4cdc-a24"
        header["authorization"] = "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"
        print("header =",header)
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
    
    func apiCancelCardRequestsNew(cardRequestId:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiRequestUrl =  ServiceNameConstant.cardRequestsNew
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiRequestUrl)/\(cardRequestId)/cancel?cp=CP_2"
       
        print("apiUrl",apiUrl)
        print("Url =",apiUrl)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: nil, headers: ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")

                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0,decodeResult.message ?? "",nil)
                          //  }
                           
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
                    completion(0,error.localizedDescription,nil)
                }            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
                } else {
                    completion(0,error?.rawValue ?? "",nil)
                }
//                completion(0, nil,error?.rawValue ?? "")
            }
        }
    }
    func apiAddressUpdateRequestsNew(updateCardHolderAddress:UpdateCardHolderAddress,cardRequestId:String,completion: @escaping(_ resStatus:Int,_ resMsg:String ,_ dataValue:[String : Any]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl =  ServiceNameConstant.cardAddressUpdateRequestsNew
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)/\(cardRequestId)/address?cp=CP_2"
        
      
        print("Url =",apiUrl)
        var parameter = [String:Any]()
        parameter["country"] = updateCardHolderAddress.country ?? ""
        parameter["documentCountry"] = updateCardHolderAddress.documentCountry ?? ""
        parameter["city"] = updateCardHolderAddress.city ?? ""
        parameter["state"] = updateCardHolderAddress.state ?? ""
        parameter["address"] = updateCardHolderAddress.address ?? ""
        parameter["address2"] = updateCardHolderAddress.address2 ?? ""
        parameter["postalCode"] = updateCardHolderAddress.postalCode ?? ""
//        parameter["cardholderName"] = updateCardHolderAddress.cardholderName ?? ""
        
     print(parameter)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .put, parameters: parameter, headers: ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")

                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0,decodeResult.message ?? "",nil)
                          //  }
                           
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
                    completion(0,error.localizedDescription,nil)
                }            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
                } else {
                    completion(0,error?.rawValue ?? "",nil)
                }
//                completion(0, nil,error?.rawValue ?? "")
            }
        }
    }

    func apiCardHolderNameUpdateRequestsNew(cardholderName:String,cardRequestId:String,completion: @escaping(_ resStatus:Int,_ resMsg:String ,_ dataValue:[String : Any]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl =  ServiceNameConstant.cardAddressUpdateRequestsNew
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)/\(cardRequestId)/cardholder-name?cp=CP_2"
        
      
        print("Url =",apiUrl)
        var parameter = [String:Any]()
        parameter["cardholderName"] = cardholderName ?? ""
        
     print(parameter)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .put, parameters: parameter, headers: ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")

                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0,decodeResult.message ?? "",nil)
                          //  }
                           
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
                    completion(0,error.localizedDescription,nil)
                }            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
                } else {
                    completion(0,error?.rawValue ?? "",nil)
                }
//                completion(0, nil,error?.rawValue ?? "")
            }
        }
    }
    func apiGetCardNew(completion: @escaping(Int, String,[Card]?) -> Void) {
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion + ServiceNameConstant.masterCardListNew
        let header = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        print(header)
        
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: header) { result in
            switch result {
            case .success((_, let response)):
                do {
                    if let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("getCardError: \(error)")
                            if error == "You are not authorised for this request." || error == "invalid_token" {
                               
                                completion(0,error,nil)
//                                logoutApp()
                            } else {
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: response)
                                completion(0,error,nil)
                                                          
                            }
                           
                        } else {
                            let decodeResult = try JSONDecoder().decode(MyCardListNew.self, from: response)
                            print(decodeResult)
                            completion(1, "",decodeResult.cards)
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

    //  Live New
      func apiGetCardPriceNew(completion: @escaping(Int,String,[CardPriceList]?) -> Void) {
          let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion + ServiceNameConstant.cardPriceNew
          
          DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
              if status {
                  do {
                      if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                          if let error = json["error"] as? String {
                              // Handle failure response
                              print("Error: \(error)")

                                  // Handle failler response
                                  let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                  completion(0,decodeResult.message ?? "",nil)
                            //  }
                             
                          } else {
                              // Handle success response
                              let decodeResult = try JSONDecoder().decode(CardPrices.self, from: data ?? Data())
                              completion(1,"",decodeResult.prices)
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
  //                completion(0, nil,error?.rawValue ?? "")
              }
          }
      }
    
    func apiGetCardRequestPriceNew(cardRequestId:Int,currency : String,completion: @escaping(Int,String,CardPaymentValue?) -> Void) {
       
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiRequestUrl =  ServiceNameConstant.cardRequestsNew
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiRequestUrl)/\(cardRequestId)/price/\(currency)?cp=CP_2"
        
        print("apiUrl",apiUrl)
//        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiuserUrl)card-request/price/currency?id=\(cardRequestId)&currency=\(currency)"
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")

                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0,decodeResult.message ?? "",nil)
                          //  }
                           
                        } else {
                            // Handle success response
                            let decodeResult = try JSONDecoder().decode(CardPaymentValue.self, from: data ?? Data())
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
//                completion(0, nil,error?.rawValue ?? "")
            }
        }
        
//        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { result in
//            
//            switch result {
//            case .success((_, let response)):
//                do {
//                    let decodeResult = try JSONDecoder().decode(CardPaymentData.self, from: response)
//                    if decodeResult.status == 200 {
//                        completion(1,decodeResult.data)
//                    } else if decodeResult.status  == 401 {
//                        logoutApp()
//                    } else {
//                        completion(0, nil)
//                    }
//                } catch(let error) {
//                    print(error)
//                    completion(0, nil)
//                }
//            case .failure(let error):
//                let errValue = error.rawValue
//                if  (errValue == "Access token expired") {
//                    logoutApp()
//                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
//                    completion(0,nil)
//                } else {
//                    completion(0, nil)
//                }
//            }
//        }
    }
    
    func apiGetAdditionalPersonalInfoNew(completion: @escaping(Int,String,AdditionalInfoList?) -> Void) {
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl =  ServiceNameConstant.additionalPersonalInfoNew
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)"
        
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")

                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0,decodeResult.message ?? "",nil)
                          //  }
                           
                        } else {
                            // Handle success response
                            let decodeResult = try JSONDecoder().decode(AdditionalInfoList.self, from: data ?? Data())
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
//                completion(0, nil,error?.rawValue ?? "")
            }
        }
    }
    func apiAdditionalPersonalInfoNew(taxId:String,isUsRelated:Bool,taxCountry:String,completion: @escaping(_ resStatus:Int,_ resMsg:String ,_ dataValue:AdditionalInfoList?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiRequestUrl =  ServiceNameConstant.additionalPersonalInfoNew
        let apiUrl = "\(apiBaseUrl)\(apiRequestUrl)"
        print("Url =",apiUrl)
        var parameter = [String:Any]()
        parameter["taxId"] = taxId
        parameter["taxCountry"] = taxCountry
        parameter["isUsRelated"] = isUsRelated
        print(parameter)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
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
                            let decodeResult = try JSONDecoder().decode(AdditionalInfoList.self, from: data ?? Data())
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
    func apiGetCountrisNew(completion: @escaping(Int,String,[CountryList]?) -> Void) {
       
        let apiUrl = "https://countriesnow.space/api/v0.1/countries/"
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: nil) { result in
            
            switch result {
                
            case .success((_, let response)):
                do {
                  
                    let decodeResult = try JSONDecoder().decode(CountryListData.self, from: response)
                    if decodeResult.error == false {
                        completion(1,decodeResult.msg ?? "",decodeResult.data)
                    } else {
                        completion(0,decodeResult.msg ?? "",nil)
                    }
                    
                } catch(let error) {
                    
                    print(error)
                    completion(0, error.localizedDescription,nil)
                }
            case .failure(let error):
               
                print(error)
                let errValue = error.rawValue
                if (errValue == "Access token expired") {
                    logoutApp()
                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
                } else {
                    completion(0,error.rawValue,nil)
                }
            }
        }
    }
    func apiChangeCurrencyNew(currencies:String?,completion: @escaping(_ resStatus:Int, _ message: String) -> ()) {
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.changeCurrency
        var parameter = [String:Any]()
        parameter["primaryCurrency"] = currencies
        print("ChangeCurrencyParam =",parameter)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    let status = data?["status"] as? Int
                    let msg = data?["message"] as? String
                    let datavalue = data?["data"] as? [String: Any]
                    if status == 200 {
                        completion(1,"")
                    } else if status  == 401 {
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
            }
        }
    }

}

//
//  MyTokenRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/05/24.
//

import Foundation
import DGNetworkingServices
class MyTokenRepo {
    func apiCreateWallet(currencies:[String]?,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[CreateWalletDataList]?) -> ()) {
        
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion +  ServiceNameConstant.createWalletsNew
        var parameter = [String:Any]()
        parameter["currencies"] = currencies  //?.joined(separator: ",")
        // v2/wallets \
        print("UpdateProfileParam =",parameter)
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
//                            }
                            
                        } else {
                            // Handle success response
                            let decodeResult = try JSONDecoder().decode(CreateWalletList.self, from: data ?? Data())
                            completion(1,"",decodeResult.wallets)
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
 func apiKycStatusNew(completion: @escaping(Int,String,KycStatusList?) -> Void) {
       
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion + ServiceNameConstant.kycStatusNew
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
                            if error == "You are not authorised for this request." || error == "invalid_token" {
                                completion(0,error ,nil)
                            } else {
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0,decodeResult.error ?? "",nil)
                            }
                           
                        } else {
                            // Handle success response
                            let decodeResult = try JSONDecoder().decode(KycStatusList.self, from: data ?? Data())
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
    func apiGetTokenNew(completion: @escaping(Int,[Wallet]?,Fiat?,String) -> Void) {
       
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion + ServiceNameConstant.getwalletsNew
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
                                // Handle failler response
                            
                            if error == "You are not authorised for this request." || error == "invalid_token" {
                                completion(0,nil,nil,error)
//                                logoutApp()
                            }
                                 let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: response)
                                completion(0,nil,nil,error)
                           
                           
                        } else {
                            let decodeResult = try JSONDecoder().decode(CardTokenDataList.self, from: response)
                            print(decodeResult)
                            completion(1,decodeResult.wallets, decodeResult.fiat, "")
                          
                        }
                    } else {
                        completion(0, nil,nil,"")
                    }
                } catch(let error) {
                    
                    print(error)
                    completion(0,nil,nil, error.localizedDescription)
                }
            case .failure(let error):
               
                print(error)
                let errValue = error.rawValue
                if (errValue == "Access token expired") {
                    logoutApp()
                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,nil,nil,errValue)
                } else {
                    completion(0,nil,nil,errValue)
                }
//                    completion(0, nil,nil)
            }
        }
    }
}

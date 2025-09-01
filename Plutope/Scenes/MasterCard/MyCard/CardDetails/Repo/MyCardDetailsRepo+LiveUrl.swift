//
//  MyCardDetailsRepo+LiveUrl.swift
//  Plutope
//
//  Created by Trupti Mistry on 15/07/24.
//

import Foundation
import DGNetworkingServices
extension MyCardDetailsRepo {
    
    func getCardPublicPrivateKeyNew(completion: @escaping(_ resStatus:Int,_ dataValue:PublicKeyData?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrl
        let apiVersionUrl = ServiceNameConstant.BaseUrl.clientVersion
        let apiuserUrl = ServiceNameConstant.BaseUrl.user
        let apiRequestUrl = ServiceNameConstant.getCardPublicPrivateKey
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiuserUrl)\(apiRequestUrl)"
        
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { result in
            switch result {
                
            case .success((_, let response)):
                do {
                    
                    let resData = try JSONDecoder().decode(PublicKeyData.self, from: response)
                    completion(1, resData)
                } catch(let error) {
                    print(error)
                    completion(0, nil)
                }
            case .failure(let error):
                print(error)
                let errValue = error.rawValue
                if  (errValue == "Access token expired") {
                    logoutApp()
                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,nil)
                } else {
                    completion(0, nil)
                }
            }
        }
    }
    func apiCardInformatonCodeSendNew(cardId:String,code:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiCardUrl = ServiceNameConstant.BaseUrl.card
        let apiRequestUrl = ServiceNameConstant.masterCardInfoDetailsNew
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiCardUrl)\(cardId)/\(apiRequestUrl)/code?cp=CP_2"
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                            completion(0,decodeResult.message ?? "",nil)
                        } else {
                            // Handle success response
                            let decodeResult = json as [String:Any]
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
    //
    func apiCardInformatonNew(cardId:String,code:String,publicKey:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:CardInfoDataList?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiCardUrl = ServiceNameConstant.BaseUrl.card
        let apiRequestUrl = ServiceNameConstant.masterCardInfoDetailsNew
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiCardUrl)\(cardId)/\(apiRequestUrl)?cp=CP_2"
        var parameter = [String:Any]()
        parameter["code"] = code
        parameter["publicKey"] = publicKey
        let headers = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: headers) { status, error, data in
            if status {
                do {
                    // Decode response to a dictionary first
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                            completion(0, decodeResult.message ?? "", nil)
                        } else {
                            // Handle success response
                            let decodeResult = try JSONDecoder().decode(CardInfoDataList.self, from: data ?? Data())
                            completion(1,"",decodeResult)
                        }
                    } else {
                        completion(0,"",nil)
                    }
                } catch(let error) {
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
    func apiCardInformatonDecrypted(number:String,expiry:String,cvv:String,cardholderName:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:CardInfoDataList?) -> ()) {
        
        let apiBaseUrl =  ServiceNameConstant.BaseUrl.baseUrl
        let apiVersionUrl = ServiceNameConstant.BaseUrl.clientVersion
        let apiUserUrl = ServiceNameConstant.BaseUrl.user
        let apiCardUrl = ServiceNameConstant.BaseUrl.card
        let apiRequestUrl = ServiceNameConstant.detailsDecrypted
       let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiUserUrl)\(apiCardUrl)\(apiRequestUrl)"
     //   let apiUrl = "http://192.168.29.240:3011/api/user/card/details-decrypted"

        var parameter = [String:Any]()
        parameter["number"] = number
        parameter["cvv"] = cvv
        parameter["expiry"] = expiry
        parameter["cardholderName"] = cardholderName
       // let headers = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: nil) { status, error, data in
            if status {
//                do {
//                    // Decode response to a dictionary first
//                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
//                        if let error = json["error"] as? String {
//                            let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
//                            completion(0, decodeResult.message ?? "", nil)
//                        } else {
//                            // Handle success response
//                            let decodeResult = try JSONDecoder().decode(CardInfoData.self, from: data ?? Data())
//                            completion(1,"",decodeResult.data)
//                        }
//                    } else {
//                        completion(0,"",nil)
//                    }
//                } catch(let error) {
//                    completion(0, error.localizedDescription,nil)
//                }
                do {
                    let data = try JSONDecoder().decode(CardInfoData.self, from: data!)
                    if data.status == 200 {
                        completion(1,"",data.data)
                    } else {
                        completion(0,data.message ?? "",nil)
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
            }
        }
    }
    func apiCardNumberNew(cardId:String,publicKey:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:CardNumberList?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiCardUrl = ServiceNameConstant.BaseUrl.card
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiCardUrl)\(cardId)/number?cp=CP_2"
        
        var parameter = [String:Any]()
        parameter["publicKey"] = publicKey
        print("Param =",parameter)
        let headers = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: headers) { status, error, data in
            if status {
                do {
                    // Decode response to a dictionary first
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                            completion(0, decodeResult.message ?? "", nil)
                        } else {
                            // Handle success response
                            let decodeResult = try JSONDecoder().decode(CardNumberList.self, from: data ?? Data())
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
    
    func apiCardNumberDecrypted(number:String,cardHolderName:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:CardNumberList?) -> ()) {
        
        let apiBaseUrl =  ServiceNameConstant.BaseUrl.baseUrl
        let apiVersionUrl = ServiceNameConstant.BaseUrl.clientVersion
        let apiUserUrl = ServiceNameConstant.BaseUrl.user
        let apiCardUrl = ServiceNameConstant.BaseUrl.card
        let apiRequestUrl = ServiceNameConstant.numberDecrypted
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiUserUrl)\(apiCardUrl)\(apiRequestUrl)"
     //   let apiUrl = "http://192.168.29.240:3011/api/user/card/number-decrypted"
        var parameter = [String:Any]()
        parameter["number"] = number
        parameter["cardholderName"] = cardHolderName
//        parameter["publicKey"] = publicKey
        print("Param =",parameter)
        let headers = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: nil) { status, error, data in
            if status {
                do {
                    let data = try JSONDecoder().decode(CardNumberData.self, from: data!)
                    if data.status == 200 {
                        completion(1,"",data.data)
                    } else {
                        completion(0,data.message ?? "",nil)
                    }
                } catch(let error) {
                    print(error)
                    completion(0,error.localizedDescription,nil)
                }
//                do {
//                    // Decode response to a dictionary first
//                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
//                        if let error = json["error"] as? String {
//                            // Handle failure response
//                            let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
//                            completion(0, decodeResult.message ?? "", nil)
//                        } else {
//                            // Handle success response
//                            let decodeResult = try JSONDecoder().decode(CardNumberData.self, from: data ?? Data())
//                            completion(1,"",decodeResult.data)
//                        }
//                    } else {
//                        completion(0,"",nil)
//                    }
//                } catch(let error) {
//                    print(error)
//                    completion(0, error.localizedDescription,nil)
//                }
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
    /// freeze card
    func apiCardFreezeCodeSendNew(cardId:String,code:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiCardUrl = ServiceNameConstant.BaseUrl.card
        let apiRequestUrl = ServiceNameConstant.softBlockNew
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiCardUrl)\(cardId)/\(apiRequestUrl)/code?cp=CP_2"
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
                            let decodeResult = json as [String:Any]
                            completion(1,"",decodeResult)
                        }
                    } else {
                        completion(0,"",nil)
                    }
                } catch(let error) {

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
    func apiCardFreezeNew(cardId:String,code:String,publicKey:String? = "",completion: @escaping(_ resStatus:Int,_ resMessage : String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiCardUrl = ServiceNameConstant.BaseUrl.card
        let apiRequestUrl = ServiceNameConstant.softBlockNew
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiCardUrl)\(cardId)/\(apiRequestUrl)?cp=CP_2"
        var parameter = [String:Any]()
        parameter["code"] = code
        let headers = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: headers) { status, error, data in
            if status {
                do {
                    // Decode response to a dictionary first
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                            completion(0, decodeResult.message ?? "",nil)
                        } else {
                            // Handle success response
                            let decodeResult = json as [String:Any]
                            completion(1,"",decodeResult)
                        }
                    } else {
                        completion(0,"",nil)
                    }
                } catch(let error) {
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
    
    // unFreeze
    func apiCardUnFreezeCodeSendNew(cardId:String,code:String,completion: @escaping(_ resStatus:Int,_ resMsg:String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiCardUrl = ServiceNameConstant.BaseUrl.card
        let apiRequestUrl = ServiceNameConstant.softUnblockNew
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiCardUrl)\(cardId)/\(apiRequestUrl)/code?cp=CP_2"
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                            completion(0,decodeResult.message ?? "",nil)
                        } else {
                            // Handle success response
                            let decodeResult = json as [String:Any]
                            completion(1,"",decodeResult)
                        }
                    } else {
                        completion(0,"",nil)
                    }
                } catch(let error) {
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
    func apiCardUnFreezeNew(cardId:String,code:String,publicKey:String? = "",completion: @escaping(_ resStatus:Int,_ resMessage : String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiCardUrl = ServiceNameConstant.BaseUrl.card
        let apiRequestUrl = ServiceNameConstant.softUnblockNew
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiCardUrl)\(cardId)/\(apiRequestUrl)?cp=CP_2"
        var parameter = [String:Any]()
        parameter["code"] = code
        print("Param =",parameter)
        
        let headers = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: headers) { status, error, data in
            if status {
                do {
                    // Decode response to a dictionary first
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                            completion(0, decodeResult.message ?? "",nil)
                        } else {
                            // Handle success response
                            let decodeResult = json as [String:Any]
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
    
    /// history
    func apiGetCardHistoryNew(offset: Int, size: Int, cardId: String, completion: @escaping (Int, String, [CardHistoryListNew]?) -> Void) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrlNew
        let apiVersionUrl = ServiceNameConstant.appVersion
        let apiRequestUrl = ServiceNameConstant.historyByCardIdNew
        
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiRequestUrl)/\(cardId)?offset=\(offset)&size=\(size)&cp=CP_2"
        
        let headers = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: headers) { status, error, data in
            if status {
                guard let responseData = data, !responseData.isEmpty else {
                    
                    completion(0, "Empty response from server", nil)
                    return
                }
                do {
                    // Decode JSON Array Response
                    let decodedArray = try JSONDecoder().decode([CardHistoryListNew].self, from: responseData)
                    
                    if decodedArray.isEmpty {
                        completion(0, "", nil)
                    } else {
                        completion(1, "", decodedArray)  // Return all objects
                    }
                }  catch {
                    completion(0, "Failed to parse response", nil)
                }
            } else {
                // Handle API errors
                if let errorMessage = error?.rawValue {
                    if errorMessage == "Access token expired" {
                        logoutApp()
                    } else if errorMessage == "it looks like your device is offline please make sure your internet connection is stable." {
                        completion(0, "it looks like your device is offline please make sure your internet connection is stable.", nil)
                    } else {
                        completion(0, errorMessage, nil)
                    }
                } else {
                    completion(0, "Unknown error occurred", nil)
                }
            }
        }
    }
    
}

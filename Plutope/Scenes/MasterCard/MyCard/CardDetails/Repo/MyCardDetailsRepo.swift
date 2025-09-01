//
//  MyCardDetailsRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 27/05/24.
//

import Foundation
import DGNetworkingServices
class MyCardDetailsRepo {
    
//    func getCardPublicPrivateKey(completion: @escaping(_ resStatus:Int,_ dataValue:PublicKeyData?) -> ()) {
//        
//        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrl
//        let apiVersionUrl = ServiceNameConstant.BaseUrl.clientVersion
//        let apiuserUrl = ServiceNameConstant.BaseUrl.user
//        let apiRequestUrl = ServiceNameConstant.getCardPublicPrivateKey
//        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiuserUrl)\(apiRequestUrl)"
//        
//        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { result in
//            switch result {
//                
//            case .success((_, let response)):
//                do {
//                   
//                   let resData = try JSONDecoder().decode(PublicKeyData.self, from: response)
////                    if status == 200 {
//                        completion(1, resData)
////                    } else {
////                        completion(0,nil)
////                    }
//                } catch(let error) {
//                    print(error)
//                    completion(0, nil)
//                }
//            case .failure(let error):
//                print(error)
//                let errValue = error.rawValue
//                if  (errValue == "Access token expired") {
//                    logoutApp()
//                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
//                    completion(0,nil)
//                } else {
//                    completion(0, nil)
//                }
////                completion(0, nil)
//            }
//        }
//    }
//    func apiCardInformatonCodeSend(cardId:String,code:String,completion: @escaping(_ resStatus:Int,_ dataValue:[[String : Any]]?) -> ()) {
//        
//        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrl
//        let apiVersionUrl = ServiceNameConstant.BaseUrl.clientVersion
//        let apiuserUrl = ServiceNameConstant.BaseUrl.user
//        let apiCardUrl = ServiceNameConstant.BaseUrl.card
//        let apiRequestUrl = ServiceNameConstant.masterCardInfoDetails
//        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiuserUrl)\(apiCardUrl)\(cardId)/\(apiRequestUrl)/code"
//        
//        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { result in
//            switch result {
//                
//            case .success((let response, _)):
//                do {
//                    let status = response["status"] as? Int ?? 0
//                  //  let message = response["message"] as? String ?? ""
//                    let data = response["data"] as? [[String : Any]] ?? [[:]]
//                    if status == 200 {
//                        completion(1, data)
//                    } else if status  == 401 {
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
//                if  (errValue == "You are not authorised for this request.") || (errValue == "Access token expired") {
//                    logoutApp()
//                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
//                    completion(0,nil)
//                } else {
//                    completion(0, nil)
//                }
////                completion(0, nil)
//            }
//        }
//    }
//    /// freeze card
//    func apiCardFreezeCodeSend(cardId:String,code:String,completion: @escaping(_ resStatus:Int,_ dataValue:[[String : Any]]?) -> ()) {
//        
//        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrl
//        let apiVersionUrl = ServiceNameConstant.BaseUrl.clientVersion
//        let apiuserUrl = ServiceNameConstant.BaseUrl.user
//        let apiCardUrl = ServiceNameConstant.BaseUrl.card
//        let apiRequestUrl = ServiceNameConstant.softBlock
//        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiuserUrl)\(apiCardUrl)\(cardId)/\(apiRequestUrl)/code"
//        
//        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { result in
//            switch result {
//                
//            case .success((let response, _)):
//                do {
//                    let status = response["status"] as? Int ?? 0
//                  //  let message = response["message"] as? String ?? ""
//                    let data = response["data"] as? [[String : Any]] ?? [[:]]
//                    if status == 200 {
//                        completion(1, data)
//                    } else if status  == 401 {
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
//                if (errValue == "You are not authorised for this request.") || (errValue == "Access token expired") {
//                    logoutApp()
//                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
//                    completion(0,nil)
//                } else {
//                    completion(0, nil)
//                }
////                completion(0, nil)
//            }
//        }
//    }
//    func apiCardFreeze(cardId:String,code:String,publicKey:String? = "",completion: @escaping(_ resStatus:Int,_ resMessage : String) -> ()) {
//        
//        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrl
//        let apiVersionUrl = ServiceNameConstant.BaseUrl.clientVersion
//        let apiuserUrl = ServiceNameConstant.BaseUrl.user
//        let apiCardUrl = ServiceNameConstant.BaseUrl.card
//        let apiRequestUrl = ServiceNameConstant.softBlock
//        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiuserUrl)\(apiCardUrl)\(cardId)/\(apiRequestUrl)"
//        
//        var parameter = [String:Any]()
//        parameter["code"] = code
//        print("Param =",parameter)
//       
//        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
//            if status {
//                do {
//                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
//                    let status = data?["status"] as? Int
//                    let msg = data?["message"] as? String
//                   // var datavalue = data?["data"] as? [String: Any]
//                     if status == 200 {
//                         completion(1, "")
//                    } else if status  == 401 {
//                        logoutApp()
//                    } else {
//                        completion(0,msg ?? "")
//                    }
//                    
//                } catch(let error) {
//                    print(error)
//                    completion(0,error.localizedDescription)
//                }
//            } else {
//                if (error?.rawValue == "You are not authorised for this request.") || (error?.rawValue == "Access token expired") {
//                    logoutApp()
//                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
//                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.")
//                } else {
//                    completion(0,error?.rawValue ?? "")
//                }
////                completion(0,error?.rawValue ?? "")
//            }
//        }
//    }
//    
//   // unFreeze
//    func apiCardUnFreezeCodeSend(cardId:String,code:String,completion: @escaping(_ resStatus:Int,_ dataValue:[[String : Any]]?) -> ()) {
//        
//        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrl
//        let apiVersionUrl = ServiceNameConstant.BaseUrl.clientVersion
//        let apiuserUrl = ServiceNameConstant.BaseUrl.user
//        let apiCardUrl = ServiceNameConstant.BaseUrl.card
//        let apiRequestUrl = ServiceNameConstant.softUnblock
//        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiuserUrl)\(apiCardUrl)\(cardId)/\(apiRequestUrl)/code"
//        
//        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { result in
//            switch result {
//                
//            case .success((let response, _)):
//                do {
//                    let status = response["status"] as? Int ?? 0
//                    //  let message = response["message"] as? String ?? ""
//                    let data = response["data"] as? [[String : Any]] ?? [[:]]
//                    if status == 200 {
//                        completion(1, data)
//                    } else if status  == 401 {
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
//                if  (errValue == "You are not authorised for this request.") || (errValue == "Access token expired") {
//                    logoutApp()
//                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
//                    completion(0,nil)
//                } else {
//                    completion(0, nil)
//                    //                completion(0, nil)
//                }
//            }
//        }
//    }
//    func apiCardUnFreeze(cardId:String,code:String,publicKey:String? = "",completion: @escaping(_ resStatus:Int,_ resMessage : String) -> ()) {
//        
//        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrl
//        let apiVersionUrl = ServiceNameConstant.BaseUrl.clientVersion
//        let apiuserUrl = ServiceNameConstant.BaseUrl.user
//        let apiCardUrl = ServiceNameConstant.BaseUrl.card
//        let apiRequestUrl = ServiceNameConstant.softUnblock
//        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiuserUrl)\(apiCardUrl)\(cardId)/\(apiRequestUrl)"
//        
//        var parameter = [String:Any]()
//        parameter["code"] = code
////        parameter["publicKey"] = publicKey
//        print("Param =",parameter)
//       
//        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
//            if status {
//                do {
//                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
//                    let status = data?["status"] as? Int
//                    let msg = data?["message"] as? String
//                    var datavalue = data?["data"] as? [String: Any]
//                     if status == 200 {
//                         completion(1, "")
//                    } else if status  == 401 {
//                        logoutApp()
//                    } else {
//                        completion(0,msg ?? "")
//                    }
//                    
//                } catch(let error) {
//                    print(error)
//                    completion(0,error.localizedDescription)
//                }
//
//            } else {
//                if (error?.rawValue == "You are not authorised for this request.") || (error?.rawValue == "Access token expired") {
//                    logoutApp()
//                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
//                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.")
//                } else {
//                    completion(0,error?.rawValue ?? "")
//                }
////                completion(0,error?.rawValue ?? "")
//            }
//        }
//    }

    /// history
//    func apiGetCardHistory(offset:Int,size:Int,cardId:String,completion: @escaping(Int,String,[CardHistoryFinalResponse]?) -> Void) {
//       
//        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrl
//        let apiVersionUrl = ServiceNameConstant.BaseUrl.clientVersion
//        let apiuserUrl = ServiceNameConstant.BaseUrl.user
//        let apiRequestUrl = ServiceNameConstant.historyByCardId
//        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiuserUrl)\(apiRequestUrl)?offset=\(offset)&size=\(size)&cardId=\(cardId)"
//        // https://plutope.app/api/user/history-by-cardId?offset=0&size=50&cardId=97
//        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { result in
//            
//            switch result {
//                
//            case .success((_, let response)):
//                do {
//                  
//                    let decodeResult = try JSONDecoder().decode(CardHistoryData.self, from: response)
//                    if decodeResult.status == 200 {
//                        completion(1,"",decodeResult.data?.finalResponse)
//                    } else if decodeResult.status  == 401 {
//                        logoutApp()
//                    } else {
//                        completion(0,decodeResult.message ?? "" ,nil)
//                    }
//                    
//                } catch(let error) {
//                    
//                    print(error)
//                    completion(0,error.localizedDescription ,nil)
//                }
//            case .failure(let error):
//               
//                print(error)
//                let errValue = error.rawValue
//                if (errValue == "You are not authorised for this request.") || (errValue == "Access token expired") {
//                    logoutApp()
//                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
//                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
//                } else {
//                    completion(0,error.rawValue,nil)
//                }
////                completion(0,error.rawValue, nil)
//            }
//        }
//    }
}
/*
 //        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiuserUrl)\(apiRequestUrl)?offset=\(offset)&size=\(size)&cardId=\(cardId)"
         // https://plutope.app/api/user/history-by-cardId?offset=0&size=50&cardId=97
         let apiUrl = "https://api.crypterium.com/v2/history/card/\(cardId)?cp=CP_2&offset=\(offset)&size=\(size)"
         let token = UserDefaults.standard.value(forKey: loginApiToken) as? String ?? ""

         DGNetworkingServices.main.dataRequest(
             Service: NetworkURL(withURL: apiUrl),
             HttpMethod: .get,
             parameters: nil,
             headers: ["Authorization": "Bearer \(token)"]
         ) { status, error, data in
             
             guard status, let data = data else {
                 print("Network Request Failed. Error:", error?.rawValue ?? "Unknown error")
                 if error?.rawValue == "Access token expired" {
                     logoutApp()
                 } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                     completion(0, "it looks like your device is offline please make sure your internet connection is stable.", nil)
                 } else {
                     completion(0, error?.rawValue ?? "", nil)
                 }
                 return
             }
             
             do {
                 let json = try JSONSerialization.jsonObject(with: data, options: [])
                 print("Raw JSON Response:", json)
                 
                 if let jsonArray = json as? [[String: Any]] {
                     // ✅ Directly decode as an array of `CardHistoryFinalResponse`
                     let decodedResult = try JSONDecoder().decode([CardHistoryFinalResponse].self, from: data)
                     completion(1, "", decodedResult)
                     
                 } else if let jsonDict = json as? [String: Any], let errorMsg = jsonDict["error"] as? String {
                     // ✅ Handle API error response
                     let decodedError = try JSONDecoder().decode(LoginFailerData.self, from: data)
                     completion(0, decodedError.message ?? "", nil)
                     
                 } else {
                     print("Unexpected JSON format")
                     completion(0, "Invalid response format", nil)
                 }
             } catch {
                 print("Decoding error:", error)
                 completion(0, "Decoding failed", nil)
             }        }

         
 //        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { result in
 //
 //            switch result {
 //
 //            case .success((_, let response)):
 //                do {
 //
 //                    let decodeResult = try JSONDecoder().decode(CardHistoryData.self, from: response)
 //                    if decodeResult.status == 200 {
 //                        completion(1,"",decodeResult.data?.finalResponse)
 //                    } else if decodeResult.status  == 401 {
 //                        logoutApp()
 //                    } else {
 //                        completion(0,decodeResult.message ?? "" ,nil)
 //                    }
 //
 //                } catch(let error) {
 //
 //                    print(error)
 //                    completion(0,error.localizedDescription ,nil)
 //                }
 //            case .failure(let error):
 //
 //                print(error)
 //                let errValue = error.rawValue
 //                if (errValue == "You are not authorised for this request.") || (errValue == "Access token expired") {
 //                   // logoutApp()
 //                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
 //                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
 //                } else {
 //                    completion(0,error.rawValue,nil)
 //                }
 ////                completion(0,error.rawValue, nil)
 //            }
 //        }
 */

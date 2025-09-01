//
//  UpdateKYCRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 21/05/24.
//

import UIKit
import DGNetworkingServices

class UpdateKYCRepo {
    
    func apiStartKYC(completion: @escaping(_ resStatus:Int,_ resData:[String:Any]?) ->()) {
        
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.kycStartNew + "?platform=COMMON"
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
                                completion(0,nil)
//                            }
                           
                        } else {
                            // Handle success response
                            let decodeResult = json as? [String: Any]
                            
                            completion(1,decodeResult)
                        }
                    } else {
                        completion(0,nil)
                    }
                } catch(let error) {
                    
                    print(error)
                    completion(0,nil)
                }            } else {
                completion(0,nil)
            }
        }
    }
    
    func apiStartKYCSumSub(completion: @escaping(_ resStatus:Int,_ resData:GetKycToken?) ->()) {
        
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.kycStartNewV5
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: nil, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                 
                            print("Error: \(error)")

                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
                                completion(0,nil)
                        } else {
                            // Handle success response
                            let decodeResult = try JSONDecoder().decode(GetKycToken.self, from: data ?? Data())
                            completion(1,decodeResult)
                        }
                    } else {
                        completion(0,nil)
                    }
                } catch(let error) {
                    
                    print(error)
                    completion(0,nil)
                }            } else {
                completion(0,nil)
            }
        }
    }
    func apiFinishKYC(identificationId:String,completion: @escaping(_ resStatus:Int,_ resData:[[String:Any]]?) -> ()) {
        
        var parameter = [String:Any]()
        parameter["identificationId"] = identificationId
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew +  ServiceNameConstant.kycFinishNew
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
                                completion(0,nil)
//                            }
                           
                        } else {
                            // Handle success response
                            let decodeResult = json as? [[String: Any]]
                            
                            completion(1,decodeResult)
                        }
                    } else {
                        completion(0,nil)
                    }
                } catch(let error) {
                    
                    print(error)
                    completion(0,nil)
                }            } else {
                completion(0,nil)
            }
        }
    }
    func apiKycUploadDocument(documentImage:UIImage,completion: @escaping(_ resStatus:Int,_ resData:[[String:Any]]?) ->()) {
        
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.kycUploadDocument
        let documents : [Media?] = [
            
            Media(withPNGImage: documentImage, forKey: "image")
        ]
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), Attachments: documents, HttpMethod: .post, parameters: nil, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { (result) in
            switch result {
            case .success(let response):
             
                let res = response.0
                let status = res["status"] as? Int ?? 0
                let errmsg = res["message"] as? String ?? ""
                let data = res["data"] as? [[String : Any]] ?? [[:]]
                if status == 200 {
                    completion(1, data)
                } else if status  == 401 {
                    logoutApp()
                } else {
                    completion(0, nil)
                }
                
                case .failure(let error):
                print(error)
                let errValue = error.rawValue
                if (errValue == "Access token expired") {
                    logoutApp()
                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,nil)
                } else {
                    completion(0, nil)
                }
//                    completion(0, nil)
               
            }
        }
    }
//    func apiGetKycLimit(completion: @escaping(Int,[String: KycLimitList]??) -> Void) {
//       
//        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.kycLimits
//        
//        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { result in
//            
//            switch result {
//                
//            case .success((_, let response)):
//                do {
//                  
//                    let decodeResult = try JSONDecoder().decode(KycLimitData
//                        .self, from: response)
//                    if decodeResult.status == 200 {
//                        completion(1,decodeResult.data)
//                    } else if decodeResult.status  == 401  {
//                        logoutApp()
//                    } else {
//                        completion(0, nil)
//                    }
//                    
//                } catch(let error) {
//                    
//                    print(error)
//                    completion(0, nil)
//                }
//            case .failure(let error):
//               
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
//    }
    /// live
    func apiGetKycLimitNew(completion: @escaping(Int,String,KycLimitLists?) -> Void) {
       
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.kycLimitsNew
        
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { result in
            
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
                                completion(0, decodeResult.message ?? "", nil)
//                            }
                            
                        } else {
                            let decodeResult = try JSONDecoder().decode(KycLimitLists.self, from: response)
                            completion(1,"", decodeResult)
                        }
                    } else {
                        completion(0, "",nil)
                    }
                    
                } catch let error {
                    print("Decoding error: \(error)")
                    completion(0,error.localizedDescription, nil)
                }
            case .failure(let error):
               
                print(error)
                let errValue = error.rawValue
                if (errValue == "Access token expired") {
                    logoutApp()
                } else if error.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0,errValue,nil)
                } else {
                    completion(0,errValue ,nil)
                }
//                completion(0, nil)
            }
        }
    }
}

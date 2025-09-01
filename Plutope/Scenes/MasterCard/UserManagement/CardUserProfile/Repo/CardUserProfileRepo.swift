//
//  CardUserProfileRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/05/24.
//

import Foundation
import DGNetworkingServices
struct ProfileList {
    var firstName:String?
    var lastNAme:String?
    var email:String?
    var mobile:String?
    var dob:String?
    var country:String?
    var city:String?
    var street:String?
    var zip:String?
    var primaryCurrency : String?
    
}

class CardUserProfileRepo {
//    func apiUpateProfile(profileData:ProfileList?,isfromRegister:Bool,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
//        
//        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.updateProfile
//        var parameter = [String:Any]()
//        parameter["firstName"] = profileData?.firstName
//        parameter["lastName"] = profileData?.lastNAme
//        parameter["primaryCurrency"] = profileData?.primaryCurrency
//        parameter["residenceCountry"] = profileData?.country
//        parameter["residenceCity"] = profileData?.city
//        parameter["residenceStreet"] = profileData?.street
//        parameter["residenceZipCode"] = profileData?.zip
//        parameter["dateOfBirth"] = profileData?.dob
//        parameter["citizenshipCountry"] = profileData?.country
//        print("UpdateProfileParam =",parameter)
//        
//        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
//            if status {
//                do {
//                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
//                    let status = data?["status"] as? Int
//                    let msg = data?["message"] as? String
//                    _ = data?["data"] as? [String: Any]
//                    if status == 200 {
//                        completion(1,msg ?? "", data)
//                    } else if status  == 401 {
//                        logoutApp()
//                    } else {
//                        completion(0,msg ?? "",nil)
//                    }
//                    
//                } catch(let error) {
//                    
//                    print(error)
//                    completion(0,error.localizedDescription, nil)
//                }
//            } else {
//                if (error?.rawValue == "Access token expired") {
//                    logoutApp()
//                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
//                    completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
//                } else {
//                    completion(0,error?.rawValue ?? "",nil)
//                }
//                //                completion(0,error?.localizedDescription ?? "", nil)
//            }
//        }
//    }
    
//    func apiGetProfile(completion: @escaping(Int,CardUserDataList?) -> Void) {
//        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.getProfile
//        
//        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["auth":"\(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { result in
//            
//            switch result {
//                
//            case .success((_, let response)):
//                do {
//                    
//                    let decodeResult = try JSONDecoder().decode(CardUserDataModel.self, from: response)
//                    if decodeResult.status == 200 {
//                        completion(1, decodeResult.data)
//                    } else if decodeResult.status  == 401 {
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
//                //                    completion(0, nil)
//            }
//        }
//    }
    
    /// live
    func apiGetProfileNew(completion: @escaping (Int,String,CardUserDataList?) -> Void) {
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion + ServiceNameConstant.customerProfile
        
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: ["authorization":"Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]) { status, error, data in
            if status {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        if let error = json["error"] as? String {
                            // Handle failure response
                            print("Error: \(error)")
                            if error == "You are not authorised for this request." || error == "invalid_token" {
                                completion(0,error,nil)
//                                logoutApp()
                            } else {
                                // Handle failler response
                                let decodeResult = try JSONDecoder().decode(LoginFailerData.self, from: data ?? Data())
//                            completion(0,decodeResult.error ?? "",nil)
                            completion(0,error,nil)
                            }
                           
                        } else {
                            // Handle success response
                            let decodeResult = try JSONDecoder().decode(CardUserDataList.self, from: data ?? Data())
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
    /// libe Update Profile
    func apiUpdateProfileNew(profileData: ProfileList?, isfromRegister: Bool, completion: @escaping (_ resStatus: Int, _ message: String, _ dataValue: [String: Any]?) -> ()) {
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.appVersion + ServiceNameConstant.customerProfile
        var parameter = [String: Any]()
        parameter["firstName"] = profileData?.firstName
        parameter["lastName"] = profileData?.lastNAme
        parameter["primaryCurrency"] = profileData?.primaryCurrency
        parameter["residenceCountry"] = profileData?.country
        parameter["residenceCity"] = profileData?.city
        parameter["residenceStreet"] = profileData?.street
        parameter["residenceZipCode"] = profileData?.zip
        parameter["dateOfBirth"] = profileData?.dob
        parameter["citizenshipCountry"] = profileData?.country
        print("UpdateProfileParam =", parameter)
        
        var header = [String: String]()
        header["accept"] = "text/plain"
        header["authorization"] = "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"
        
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .patch, parameters: parameter, headers: header) { status, error, data in
            if status {
                
                if error == nil {
                    completion(1, "Profile updated successfully", nil)
                } else {
                    completion(0, error?.rawValue ?? "", nil)
                }
            } else {
                if (error?.rawValue == "Access token expired") {
                    logoutApp()
                } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
                    completion(0, "it looks like your device is offline please make sure your internet connection is stable.", nil)
                } else {
                    completion(0, error?.rawValue ?? "", nil)
                }
            }
        }
    }
}

//
//  SignInrepo.swift
//  Plutope
//
//  Created by sonoma on 16/05/24.
//

import Foundation
import DGNetworkingServices

class SignInRepo {
    /// SignIn Repo
    func apiSignIn(phone :String,password:String,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.signIn
        var parameter = [String:Any]()
        parameter["phone"] = phone
        parameter["password"] = password
        print("SignInParam =",parameter)
        // showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: nil) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    let status = data?["status"] as? Int
                    let msg = data?["message"] as? String
                    let datavalue = data?["data"] as? [String: Any]
                    _ = datavalue?["result"] as? String
                    if status == 200 {
                        completion(1,msg ?? "", data)
                    } else if status  == 401 {
                        logoutApp()
                    } else {
                        completion(0,msg ?? "",nil)
                    }
                    
                } catch(let error) {
                    
                    print(error)
                    completion(0,error.localizedDescription, nil)
                }
            } else {
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
    
    /// signOut
//   func apiSignout(isfromRegister:Bool,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
//       
//       let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.BaseUrl.user + ServiceNameConstant.signOut
//       var auth = ""
//       if isfromRegister == true {
//           let emailApiToken = UserDefaults.standard.value(forKey: loginApiToken) as? String ?? ""
//           auth = emailApiToken
//       } else {
//          let loginAuthoToken = UserDefaults.standard.value(forKey: loginApiToken) as? String ?? ""
//           auth = loginAuthoToken
//       }
//       
//       DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: nil, headers:["auth":"\(auth)"]) { status, error, data in
//           if status {
//               do {
//                   let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
//                   let status = data?["status"] as? Int
//                   let msg = data?["message"] as? String
//                   let datavalue = data?["data"] as? [String: Any]
//                   _ = datavalue?["result"] as? String
//                   if status == 200 {
//                       completion(1,msg ?? "", data)
//                   } else {
//                       completion(0,msg ?? "",nil)
//                   }
//                   
//               } catch(let error) {
//                   
//                   print(error)
//                   completion(0,error.localizedDescription, nil)
//               }
//           } else {
//               if (error?.rawValue == "Access token expired") {
//                   logoutApp()
//               } else if error?.rawValue == "it looks like your device is offline please make sure your internet connection is stable." {
//                   completion(0,"it looks like your device is offline please make sure your internet connection is stable.",nil)
//               } else {
//                   completion(0,error?.rawValue ?? "",nil)
//               }
////                completion(0,error?.localizedDescription ?? "", nil)
//           }
//       }
//   }
    func configureRequest(_ request: inout URLRequest, for serverType: ServerType) {
        switch serverType {
        case .live:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .test: // Assuming you have other server types, adjust accordingly
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
    }
/// Live Server Apis
    ///  Signin
    func apiSignInNew(phone: String, password: String, completion: @escaping (_ resStatus: Int, _ message: String, _ dataValue: [String: Any]?) -> ()) {
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew + ServiceNameConstant.login
        guard let url = URL(string: apiUrl) else {
            completion(0, "Invalid URL", nil)
            return
        }
        let merchantId = merchantID
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let serverType = serverTypes
        
        // configureRequest(&request, for: serverType)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(merchantId, forHTTPHeaderField: "X-Merchant-ID")
        
        let parameters: [String: String] = [
            "grant_type": "mobile_phone",
            "number": phone,
            "password": password
        ]
        
        let parameterArray = parameters.map { (key, value) -> String in
            return "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        let parameterString = parameterArray.joined(separator: "&")
        request.httpBody = parameterString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(0, error.localizedDescription, nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(0, "Invalid response", nil)
                return
            }
            
            print("Status code: \(httpResponse.statusCode)")
            
            guard let data = data else {
                print("No data received")
                completion(httpResponse.statusCode, "No data received", nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response JSON: \(json)")
                    if (200...299).contains(httpResponse.statusCode) {
                        completion(httpResponse.statusCode, "Success", json)
                    } else if httpResponse.statusCode == 400 {
                        // Handle 400 status code and extract error message
                        let errorMessage = json["message"] as? String ?? "Unknown error"
                        completion(httpResponse.statusCode, errorMessage, nil)
                    } else {
                        let errorMessage = json["message"] as? String ?? "Unknown error"
                        completion(httpResponse.statusCode, errorMessage, nil)
                    }
                } else {
                    print("Invalid JSON format")
                    completion(httpResponse.statusCode, "Invalid JSON format", nil)
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
                completion(httpResponse.statusCode, error.localizedDescription, nil)
            }
        }
        
        task.resume()
    }

    /// new Live
    func apiSignoutNew(isfromRegister:Bool,completion: @escaping(_ resStatus:Int, _ message: String,_ dataValue:[String : Any]?) -> ()) {
        
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrlNew +  ServiceNameConstant.signOut
        var auth = ""
        if isfromRegister == true {
            let emailApiToken = UserDefaults.standard.value(forKey: loginApiToken) as? String ?? ""
            auth = emailApiToken
        } else {
           let loginAuthoToken = UserDefaults.standard.value(forKey: loginApiToken) as? String ?? ""
            auth = loginAuthoToken
        }
        //showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: nil, headers:["X-DeviceId":"\(auth)"]) { status, error, data in
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
                            let decodeResult = data as? [String:Any]
                            completion(1,"", decodeResult)
                        }
                    } else {
                        completion(0, "",nil)
                    }
                    
                } catch let error {
                    print("Decoding error: \(error)")
                    completion(0,error.localizedDescription, nil)
                }
            } else {
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
}

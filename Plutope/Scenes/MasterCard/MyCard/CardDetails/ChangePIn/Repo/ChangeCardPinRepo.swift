//
//  ChangeCardPinRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 05/09/24.
//

import Foundation
import UIKit
import DGNetworkingServices

class ChangeCardPinRepo {
    func apiChangeCardPin(cardId: String, code:String, completion: @escaping(_ resStatus: Int,_ resmsg:String, _ dataValue: [String : Any]?) -> ()) {
        
        let apiUrl = "\(ServiceNameConstant.BaseUrl.baseUrlNew)\(ServiceNameConstant.appVersion)\(ServiceNameConstant.BaseUrl.card)\(cardId)\(ServiceNameConstant.changeCardPin)"
        let header = ["authorization": "Bearer \(UserDefaults.standard.value(forKey: loginApiToken) as? String ?? "")"]
        print(header)
    
        print("Url =",apiUrl)
        var parameter = [String:Any]()
        parameter["pin"] = code
       
        print(parameter)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: header) { status, error, data in
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
                            let decodeResult = json as? [String : Any]
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
}

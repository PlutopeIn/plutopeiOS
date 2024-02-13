//
//  RegisterUserRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 05/12/23.
//

import Foundation
import DGNetworkingServices

class RegisterUserRepo {
    /// Register Repo
    func apiRegister(walletAddress :String,appType:Int,deviceId:String,fcmToken:String,completion: @escaping(_ resStatus:Int, _ message: String) -> ()) {
        let apiUrl = "https://plutope.app/api/user/register-user"
        var parameter = [String:Any]()
        parameter["walletAddress"] = walletAddress
        parameter["appType"] = appType
        parameter["deviceId"] = deviceId
        parameter["fcmToken"] = fcmToken
        //showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: nil) { status, error, data in
            
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    let status = data?["status"] as? Int
                    let msg = data?["message"] as? String
                    //if status == 201 || status == 200 { // data.status == 200 ||
                        completion(1,msg ?? "")
                  //  } else {
                     //   completion(0,msg ?? "")
                  //  }
                    
                } catch(let error) {
                  
                    print(error)
                    completion(0,error.localizedDescription)
                }
            } else {
             
                completion(0,error?.localizedDescription ?? "")
            }
        }
    }
    
    
    /// set-wallet-active
    func apiSetWalletActive(walletAddress :String,completion: @escaping(_ resStatus:Int, _ message: String) -> ()) {
        let apiUrl = "https://plutope.app/api/admin/set-wallet-active"
        var parameter = [String:Any]()
        parameter["walletAddress"] = walletAddress
       
        //showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: nil) { status, error, data in
            
            if status {
                do {
                 
//                    let data = try JSONDecoder().decode(RegisterWalletData.self, from: data ?? Data())
                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    let status = data?["status"] as? Int
                    let msg = data?["message"] as? String
                    if status == 200 { // data.status == 200 ||
                        completion(1,msg ?? "")
                    } else {
                        completion(0,msg ?? "")
                    }
                    
                } catch(let error) {
                  
                    print(error)
                    completion(0,error.localizedDescription)
                }
            } else {
             
                completion(0,error?.localizedDescription ?? "")
            }
        }
    }
}

//
//  RegisterUserRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 05/12/23.
//

import UIKit
import DGNetworkingServices

class RegisterUserRepo {
    /// Register Repo
    func apiRegister(walletAddress :String,appType:Int,deviceId:String,fcmToken:String,type:String,referralCode:String,completion: @escaping(_ resStatus:Int, _ message: String) -> ()) {
            
        NSLog("referralCode: %@", referralCode)
        let apiUrl = "https://plutope.app/api/user/register-user"
        var parameter = [String:Any]()
        parameter["walletAddress"] = walletAddress
        parameter["appType"] = appType
        parameter["appType"] = appType
        parameter["deviceId"] = deviceId
        parameter["fcmToken"] = fcmToken
        parameter["walletAction"] = type
        parameter["referral_code"] = referralCode
        print("RegisterParam=>",parameter)
        //showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: nil) { status, error, data in
            
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    let status = data?["status"] as? Int
                    let msg = data?["message"] as? String
                    // if status == 201 || status == 200 { // data.status == 200 ||
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
   //     let apiUrl = "https://plutope.app/api/admin/set-wallet-active"
        
        var parameter = [String:Any]()
        parameter["walletAddress"] = walletAddress
        print("activitylogparameter",parameter)
        // showLoaderHUD()
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
    func apiActiveTokensInfo(requestId:String? = nil,walletAddress:String,transactionType:String? = nil,providerType:String? = nil,transactionHash:String? = nil,tokenDetailArrayList:[[String: Any]]? = [[:]],completion: @escaping(_ resStatus:Int, _ message: String,_ resdata:[[String: Any]]?) -> ()) {
        let apiUrl = " https://plutope.app/api/wallet-activity-log"
        // Convert tokenDetailArrayList to the desired format
        
        var parameter = [String:Any]()
        parameter["walletAddress"] = walletAddress
        parameter["transactionType"] = transactionType
        parameter["transactionHash"] = transactionHash
        parameter["providerType"] = providerType
        parameter["tokenDetailArrayList"] = tokenDetailArrayList
       
        print("RegisterParam =",parameter)
        //showLoaderHUD()
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .post, parameters: parameter, headers: nil) { status, error, data in
            if status {
                do {
                    print(data)
                    //                    let data = try JSONDecoder().decode(RegisterWalletData.self, from: data ?? Data())
                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    let status = data?["status"] as? Int
                    let msg = data?["message"] as? String
                    let data1 = data?["data"] as? [[String: Any]]
                    if status == 200 { // data.status == 200 ||
                        completion(1,msg ?? "",data1)
                    } else {
                        completion(0,msg ?? "",nil)
                    }
                    
                } catch(let error) {
                    
                    print(error)
                    completion(0,error.localizedDescription,nil)
                }
            } else {
                
                completion(0,error?.localizedDescription ?? "",nil)
            }
        }
    }
}

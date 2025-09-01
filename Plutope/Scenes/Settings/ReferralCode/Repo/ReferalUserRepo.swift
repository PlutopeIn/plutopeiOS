//
//  ReferalUserRepo.swift
//  Plutope
//
//  Created by Pushpendra Rajput on 11/07/24.
//

import Foundation
import DGNetworkingServices

/// ReferalUserRepo
class ReferalUserRepo {
    
    /// getReferalUserRepo
    func referalUserRepo(walletAddress: String,completion: @escaping(_ resStatus:Int,_ resMessage:String,_ dataValue:[ReferalUserDataList]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrl
        let apiVersionUrl = ServiceNameConstant.BaseUrl.clientVersion
        let apiuserUrl = ServiceNameConstant.BaseUrl.user
        let apiRequestUrl = ServiceNameConstant.referralCodeUser
        var deviceId = ""
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiuserUrl)\(apiRequestUrl)\(walletAddress)"

        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: nil) { result in
            switch result {
                
            case .success((_, let response)):
                do {
                    let resData = try JSONDecoder().decode(ReferalUserDataModel.self, from: response)
                    
                    if resData.status == 200 {
                        completion(1,"", resData.data)
                    } else {
                        completion(0,resData.message ?? "",nil)
                    }
                } catch(let error) {
                    print(error)
                    completion(0,error.localizedDescription, nil)
                }
            case .failure(let error):
                print(error)
                completion(0,error.rawValue,nil)
            }
        }
    }
    
    /// getUpdateClaimRepo
    func updateClaimRepo(walletAddress: String,completion: @escaping( _ resStatus:Int, _ resMessage:String,_ dataValue:[UpdateClaimDataList]?) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrl
        let apiVersionUrl = ServiceNameConstant.BaseUrl.clientVersion
        let apiuserUrl = ServiceNameConstant.BaseUrl.user
        let apiRequestUrl = ServiceNameConstant.updateClaimUser
        var deviceId = ""
        
//        let walletAddress = WalletData.shared.myWallet?.address ?? ""
//        let walletAddress = "0x6836693e7dd1a775132783F486628a99933abb25"
        
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiuserUrl)\(apiRequestUrl)\(walletAddress)"

        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: nil) { result in
            switch result {
                
            case .success((_, let response)):
                do {
                    let resData = try JSONDecoder().decode(UpdateClaimDataModel.self, from: response)
                    
                    if resData.status == 200 {
                        completion(1,"", resData.data)
                    } else {
                        completion(0,resData.message ?? "",nil)
                    }
                } catch(let error) {
                    print(error)
                    completion(0,error.localizedDescription, nil)
                }
            case .failure(let error):
                print(error)
                completion(0,error.rawValue,nil)
            }
        }
    }
    
}

extension Notification.Name {
    static let dataUpdated = Notification.Name("dataUpdated")
}

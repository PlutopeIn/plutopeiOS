//
//  ReferallCodeRepo.swift
//  Plutope
//
//  Created by sonoma on 03/07/24.
//

import Foundation
import DGNetworkingServices

/// TransactionDetailRepo
class ReferallCodeRepo {
    
    /// getTransactionDetail
    func referallCodeRepo(walletAddress: String,completion: @escaping(_ resStatus:Int,_ dataValue:ReferallCodeDataList?,_ resMessage:String) -> ()) {
        
        let apiBaseUrl = ServiceNameConstant.BaseUrl.baseUrl
        let apiVersionUrl = ServiceNameConstant.BaseUrl.clientVersion
        let apiuserUrl = ServiceNameConstant.BaseUrl.user
        let apiRequestUrl = ServiceNameConstant.referral
        var deviceId = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
           print("Device ID: \(uuid)")
            deviceId = uuid
        } else {
           print("Unable to retrieve device ID.")
        }
        
//        let walletAddress = WalletData.shared.myWallet?.address ?? ""
        
        let apiUrl = "\(apiBaseUrl)\(apiVersionUrl)\(apiuserUrl)\(apiRequestUrl)\(walletAddress)"

        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: nil) { result in
            switch result {
                
            case .success((_, let response)):
                do {
                    let resData = try JSONDecoder().decode(ReferallCodeData.self, from: response)
                    if resData.status == 200 {
                        completion(1, resData.data, "")
                    } else {
                        completion(0,nil, resData.message ?? "")
                    }
                } catch(let error) {
                    print(error)
                    completion(0, nil,error.localizedDescription)
                }
            case .failure(let error):
                print(error)
                completion(0, nil,error.rawValue)
            }
        }
    }
}

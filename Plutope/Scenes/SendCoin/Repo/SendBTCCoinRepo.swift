//
//  SendBTCCoinRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 08/12/23.
//

import Foundation
import DGNetworkingServices
/// TransactionListRepo
///
// MARK: - WalletData
struct SendWalletData: Codable {
    let status: Int?
    let message, data: String?
}

class SendBTCCoinRepo {
    /// send BTC Api
    func apiSendBTC(privateKey:String,value:String,toAddress:String,env:String,fromAddress:String,completion:@escaping((_ statusResult:Int,_ message : String,_ resData : String?)-> Void)) {
        
        var param = [String:Any]()
        param["privateKey"] = privateKey
        param["value"] = value
        param["toAddress"] = toAddress
        param["env"] = env
        param["fromAddress"] = fromAddress
        
        print(param)
      
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: "https://plutope.app/api/btc-transfer"), HttpMethod: .post, parameters: param, headers: nil) { status, error, data in
            if status {
                do {
                    DGProgressView.shared.hideLoader()
                    let data = try JSONDecoder().decode(SendWalletData.self, from: data ?? Data())
                    if data.status == 200 {
                        completion(1,data.message ?? "",nil)
                    } else {
                        print(error as Any)
                        completion(0,data.message ?? "",nil)
                    }
                    
                } catch(let error) {
                    DGProgressView.shared.hideLoader()
                    print(error)
                    completion(0,error.localizedDescription,nil)
                }
            } else {
                DGProgressView.shared.hideLoader()
                completion(0,error?.rawValue ?? "",nil)
            }
        }
    }
}

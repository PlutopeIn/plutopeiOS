//
//  BuyCoinViewRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 04/04/24.
//

import UIKit
import DGNetworkingServices
import CryptoSwift

class BuyCoinViewRepo {
    func apiBuyQuote(parameters:BuyQuoteParameters ,completion: @escaping ((Bool,String,[BuyMeargedDataList]?) -> Void)) {
        
        let param: [String: Any] = [
            "chainId": parameters.chainId ?? 0,
            "currency": parameters.currency ?? "",
            "amount": parameters.amount ?? "",
            "walletAddress": parameters.walletAddress ?? "",
            "countryCode":parameters.countryCode ?? "",
            "chainName":parameters.chainName ?? "",
            "tokenSymbol":parameters.tokenSymbol ?? "",
            "tokenAddress":parameters.tokenAddress ?? "",
            "decimals":parameters.decimals ?? 0
        ]
        print("mixProviderParams :==",param)
      // Now you can use this dictionary in your API request
        let appUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.buyQuote
        print(appUrl)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL:appUrl), HttpMethod: .post, parameters: param as [String : Any], headers: nil) { status, error, data in
            
            if status {
                do {
                    let resultData = try JSONDecoder().decode(BuyMeargedData.self, from: data ?? Data())
                    completion(true,"",resultData.data)
                    
                } catch(let error) {
                    completion(false,error.localizedDescription,nil)
                    print(error)
                }
            } else {
                completion(false,error?.rawValue ?? "",nil)
                print(error as Any)
                //                self.apiGetExchangePairs(fromCurrency: fromCurrency, fromNetwork: fromNetwork, toNetwork: toNetwork, completion: completion)
            }
//            if status {
//                do {
//                    let data = try JSONSerialization.jsonObject(with: data!)
//                    completion(true,"",data as? [String: Any])
//                } catch(let error) {
//                    print(error)
//                    completion(false,error.localizedDescription,nil)
//                }
//            } else {
//                completion(false,error?.rawValue ?? "",nil)
//            }
        }

    }
}
    

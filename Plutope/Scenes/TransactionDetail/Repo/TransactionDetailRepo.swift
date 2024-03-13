//
//  TransactionDetailRepo.swift
//  Plutope
//
//  Created by Mitali Desai on 05/07/23.
//

import Foundation
import DGNetworkingServices

/// TransactionDetailRepo
class TransactionDetailRepo {
    
    /// getTransactionDetail
    func getTransactionDetail(_ chainShortName: String,_ txid: String,completion: @escaping (([TransactionDetails]?,Bool,String) -> Void)) {
        
        let apiURL = "https://www.oklink.com/api/v5/explorer/transaction/transaction-fills?chainShortName=\(chainShortName)&txid=\(txid)"
            print(apiURL)
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiURL), HttpMethod: .get, parameters: nil, headers: APIKey.okLinkHeader) { result in
            
            switch result {
                
            case .success((_,let response)):
                do {
                    let decodedRes = try JSONDecoder().decode(TransactionDetailData.self, from: response)
                    if decodedRes.data?.count != 0 {
                        completion(decodedRes.data ?? [],true,"")
                    } else {
                        completion(nil,false,decodedRes.msg ?? "")
                    }
                } catch(let error) {
                    print(error)
                    completion(nil,false,error.localizedDescription)
                }
                
            case .failure(let error):
                print(error)
                completion(nil,false,error.rawValue)
            }
        }
    }
}

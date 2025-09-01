//
//  SellRepo.swift
//  Plutope
//
//  Created by Trupti Mistry on 22/04/25.
//

import Foundation
import DGNetworkingServices

class SellRepo {
    
    func getSellProviderAPi(completion:@escaping(_ status : Int,_ msg:String,_ resData : [SellProviderList]?) -> Void) {
        
        let apiUrl = ServiceNameConstant.BaseUrl.baseUrl + ServiceNameConstant.BaseUrl.clientVersion + ServiceNameConstant.getAllSellProvider
        print(apiUrl)
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: nil) { result in
            switch result {
            case .success((_, let response)):
                do {
                    let jsonData = try JSONDecoder().decode(SellProviderData.self, from: response)
                    //                    let coinPrice = coinPriceData.data ?? nil
                    if jsonData.status == 200 {
                        completion(1, "",jsonData.data)
                    } else {
                        completion(0, "",nil)
                    }
                    
                } catch(let error) {
                    completion(0,error.localizedDescription,nil)
                    print(error)
                }
            case .failure(let error):
                completion(1,error.rawValue,nil)
                print(error)
            }
        }
    }
}

//
//  BuyCoinPriceRepo.swift
//  Plutope
//
//  Created by Priyanka Poojara on 22/06/23.
//
import DGNetworkingServices
class CoinPriceRepo {
    
    /// apiGetTokenAssets
    func apiGetMinPrice(symbol: String, completion: @escaping ((CoinPrice?, Bool, String) -> Void)) {
        
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: "https://api.onramp.money/onramp/api/v3/buy/public/coinNetworks?coinCode=\(symbol)&fiatAmount="), HttpMethod: .get, parameters: nil, headers: nil) { result in
            switch result {
                
            case .success((_, let response)):
                do {
                    let coinPriceData = try JSONDecoder().decode(CoinDetail.self, from: response)
                    let coinPrice = coinPriceData.data ?? nil
                    
                    completion(coinPrice,true,"")
                    print(coinPriceData)
                } catch(let error) {
                    completion(nil,false,error.localizedDescription)
                    print(error)
                }
            case .failure(let error):
                completion(nil,false,error.rawValue)
                print(error)
            }
        }
    }
    
}

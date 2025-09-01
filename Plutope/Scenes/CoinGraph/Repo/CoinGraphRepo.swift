//
//  CoinGraphRepo.swift
//  Plutope
//
//  Created by Mitali Desai on 29/06/23.
//

import Foundation
import DGNetworkingServices

class CoinGraphRepo {
    
    func apiGraphData(_ chain: String,currency: String,days: String,completion: @escaping ((Bool,String,GraphData?) -> Void)) {
        
        let apiUrl = "https://api.coingecko.com/api/v3/coins/\(chain)/market_chart?vs_currency=\(currency)&days=\(days)"
        
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: nil) { result in
            switch result {
                
            case .success((_, let data)):
                do {
                    let data = try JSONDecoder().decode(GraphData.self, from: data)
                    completion(true,"",data)
                } catch(let error) {
                    print(error)
                    completion(false,error.localizedDescription,nil)
                }
            case .failure(let error) :
                print(error)
                completion(false,error.localizedDescription,nil)
                
            }
        }
    }
    
    func apiMarketVolumeData(_ vsCurrency: String,ids: String,completion: @escaping ((Bool,String,[MarketData]?) -> Void)) {
        
    //    let apiUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=\(vsCurrency)&ids=\(ids)"
//        let apiUrl = "https://plutope.app/api/markets-price?currency=\(vsCurrency)&ids=\(ids)"
     //   let apiUrl = "https://plutope.app/api/markets-price-new?currency=\(vsCurrency)&ids=\(ids)"
        let apiUrl = "https://plutope.app/api/markets-price-v2-filter?currency=\(vsCurrency)&ids=\(ids)"
//        print(apiUrl)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: nil) { status, error, data in
            if status {
                do {
                    let data = try JSONDecoder().decode([MarketData].self, from: data!)
                    completion(true,"",data)
                } catch(let error) {
                    print(error)
                    completion(false,error.localizedDescription,nil)
                }
            } else {
                completion(false,error?.rawValue ?? "",nil)
            }
        }
    }
    
    func apiCoinList(completion: @escaping ((Bool,String,[CoingechoCoinList]?) -> Void)) {
        
      //  let apiUrl = "https://api.coingecko.com/api/v3/coins/list?include_platform=true"
        let apiUrl = "https://plutope.app/api/get-all-tokens"
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: nil) { status, error, data in
            if status {
                DispatchQueue.main.async {
                    do {
                        let data = try JSONDecoder().decode([CoingechoCoinList].self, from: data!)
                        print("getallcoin:",data)
                        completion(true,"",data)
                    } catch(let error) {
                        print(error)
                        completion(false,error.localizedDescription,nil)
                    }
                }
                
            } else {
                completion(false,error?.rawValue ?? "",nil)
            }
        }
    }
    
    func apiCoinInfo(tokenID: String, completion: @escaping ((Bool,String, CoinInfoData?) -> Void)) {
        let apiUrl = "https://api.coingecko.com/api/v3/coins/\(tokenID)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: nil) { status, error, data in
            if status {
                DispatchQueue.main.async {
                    do {
                        let data = try JSONDecoder().decode(CoinInfoData.self, from: data!)
                        completion(true,"",data)
                    } catch(let error) {
                        print(error)
                        completion(false,error.localizedDescription,nil)
                    }
                }
            } else {
                completion(false,error?.rawValue ?? "",nil)
            }
        }
    }
    func checkTokenVersion(completion: @escaping ((Int, String,CheckAppVersonList?) -> Void)) {
       
        let appUrl = "https://plutope.app/api/get-generate-token"
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: appUrl), HttpMethod: .get, parameters: nil, headers: nil) { result in
            switch result {
                
            case .success((_,let response)):
                do {
                    let decodeData = try JSONDecoder().decode(CheckAppVersonData.self, from: response)
                    if decodeData.status == 200 {
                        print("decodeData.data",decodeData.data)
                        completion(1,decodeData.message ?? "",decodeData.data)
                    } else {
                        completion(0,decodeData.message ?? "",nil)
                    }
                   
                } catch(let error) {
                    completion(0,error.localizedDescription.debugDescription,nil)
                    print(error)
                }
            case .failure(let error):
                
                print(error)
                completion(0,error.readableDescription,nil)
            }
            
        }
    }
    
    
}

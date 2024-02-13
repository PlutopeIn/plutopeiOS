//
//  NFTRepo.swift
//  Plutope
//
//  Created by Priyanka Poojara on 28/06/23.
//

import UIKit
import DGNetworkingServices

class NFTRepo {
    
    /// Nft list for Polygon Chain
    func apiGetNFTListPolygon(detail: String?, completion: @escaping (([NFTList]?,Bool,String) -> Void)) {
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: "https://deep-index.moralis.io/api/v2/\(detail ?? "")/nft?chain=\(Chain.polygon.chainName)"), HttpMethod: .get, parameters: nil, headers: APIKey.moralisAPIKey) { result in
            
            switch result {
                
            case .success((_, let response)):
                
                do {
                    let nftData = try JSONDecoder().decode(NFTData.self, from: response)
                    let nftList = nftData.result
                    
                    completion(nftList, true, "")
                    print(nftData)
                    
                } catch(let error) {
                    completion(nil, false, error.localizedDescription)
                    print(error)
                }
                
            case .failure(let error):
                completion(nil, false, error.rawValue)
                print(error)
            }
            
        }
    }
    
    /// Nft list for Ethereum Chain
    func apiGetNFTListEth(detail: String?, completion: @escaping (([NFTList]?,Bool,String) -> Void)) {
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: "https://deep-index.moralis.io/api/v2/\(detail ?? "")/nft?chain=\(Chain.ethereum.chainName)"), HttpMethod: .get, parameters: nil, headers: APIKey.moralisAPIKey) { result in
            
            switch result {
                
            case .success((_, let response)):
                
                do {
                    let nftData = try JSONDecoder().decode(NFTData.self, from: response)
                    let nftList = nftData.result
                    
                    completion(nftList, true, "")
                    print(nftData)
                    
                } catch(let error) {
                    completion(nil, false, error.localizedDescription)
                    print(error)
                }
                
            case .failure(let error):
                completion(nil, false, error.rawValue)
                print(error)
            }
            
        }
    }
    
    /// Nft list for Binance Chain
    func apiGetNFTListBsc(detail: String?, completion: @escaping (([NFTList]?,Bool,String) -> Void)) {
    
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: "https://deep-index.moralis.io/api/v2/\(detail ?? "")/nft?chain=\(Chain.binanceSmartChain.chainName)"), HttpMethod: .get, parameters: nil, headers: APIKey.moralisAPIKey) { result in
            
            switch result {
                
            case .success((_, let response)):
                
                do {
                    let nftData = try JSONDecoder().decode(NFTData.self, from: response)
                    let nftList = nftData.result
                    
                    completion(nftList, true, "")
                    print(nftData)
                    
                } catch(let error) {
                    completion(nil, false, error.localizedDescription)
                    print(error)
                }
                
            case .failure(let error):
                completion(nil, false, error.rawValue)
                print(error)
            }
            
        }
    }
    
}

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
    
    func apiGetAllNFTList(detail: String?, completion: @escaping (([NFTDataNewElement]?, Bool, String) -> Void)) {
        guard let wallet = detail, !wallet.isEmpty else {
            completion(nil, false, "Wallet address is missing.")
            return
        }

        let urlString = "https://plutope.app/api/get-all-nft?walletAddress=\(wallet)"
        guard let url = URL(string: urlString) else {
            completion(nil, false, "Invalid URL.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // 🛑 Network error
            if let error = error {
                print("❌ Network Error:", error)
                DispatchQueue.main.async {
                    completion(nil, false, error.localizedDescription)
                }
                return
            }

            // 🛑 Invalid response or data
            guard let httpResponse = response as? HTTPURLResponse,
                  let responseData = data else {
                DispatchQueue.main.async {
                    completion(nil, false, "No response or data.")
                }
                return
            }

            print("📦 HTTP Status Code: \(httpResponse.statusCode)")
            if let contentType = httpResponse.allHeaderFields["Content-Type"] as? String {
                print("📄 Content-Type: \(contentType)")
            }

            if let jsonString = String(data: responseData, encoding: .utf8) {
                print("📄 Raw JSON:\n\(jsonString)")
            }

            // ✅ Decode JSON
            do {
                let decoder = JSONDecoder()
                let nftData = try decoder.decode(NFTDataNew.self, from: responseData)
                print("✅ Decoded NFT Data Count:", nftData.count)

                DispatchQueue.main.async {
                    completion(nftData, true, "")
                }
            } catch {
                print("❌ Decoding Error:", error)
                DispatchQueue.main.async {
                    completion(nil, false, "Decoding failed: \(error.localizedDescription)")
                }
            }
        }

        task.resume()
    }


//    func apiGetAllNFTList(detail: String?, completion: @escaping (([NFTDataNewElement]?, Bool, String) -> Void)) {
//        let apiUrl = "https://plutope.app/api/get-all-nft?walletAddress=\(detail ?? "")"
//        
//        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiUrl), HttpMethod: .get, parameters: nil, headers: nil) { status, error, data in
//            print("nftAPIstatus",status)
//            print("nftAPIerror",error)
//            if status {
//                do {
//                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
////                        if let error = json["error"] as? String {
////                            // Handle failure response
////                            print("Error: \(error)")
//////                            if error == "You are not authorised for this request." || error == "invalid_token" {
//////                                
//////                                completion(nil, false, error)
////////                                logoutApp()
//////                            } else {
////                                // Handle failler response
////                                completion(nil, false, error)
//////                            }
////                           
////                        } else {
//                            // Handle success response
//                            let decodeResult = try JSONDecoder().decode(NFTDataNew.self, from: data ?? Data())
//                            print("decodeResult: \(decodeResult)")
//                            completion(decodeResult,true,"")
//                           
//                       // }
//                    } else {
//                        completion(nil, false, error?.rawValue ?? "")
//                    }
//                } catch(let error) {
//                    
//                    print(error)
//                    completion(nil, false, error.localizedDescription)
//                }            } else {
//                    
//                    print("error?.localizedDescription",error?.localizedDescription ?? "")
//                    completion(nil, false, error?.localizedDescription ?? "")
//            }
//        }
//
//    }
    
}

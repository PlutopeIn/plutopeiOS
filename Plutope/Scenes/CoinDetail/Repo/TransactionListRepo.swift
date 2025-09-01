//
//  TransactionListRepo.swift
//  Plutope
//
//  Created by Mitali Desai on 24/05/23.
//
import Foundation
import DGNetworkingServices
/// TransactionListRepo
class TransactionListRepo {
    
    /// getTransactionHistorty
    func getTransactionHistorty(_ coindetail: Token,_ page: String,completion: @escaping (([TransactionResult]?,Bool,String) -> Void)) {
        
        // https://api.bscscan.com/api?module=account&action=txlist&address=0x37ec14ef9c13c2a07c2cd1ed3f5869d42d9a6596&startblock=0&endblock=99999999&sort=asc&apikey=G5NXUANXH7RE8ZQXGXRVRJQDZ8RBNMJZ4S
        
        //  https://api.bscscan.com/api?module=account&action=tokentx&contractaddress=0xc9849e6fdb743d08faee3e34dd2d1bc69ea11a51&address=0x7bb89460599dbf32ee3aa50798bbceae2a5f7f6a&page=1&offset=5&startblock=0&endblock=999999999&sort=asc&apikey=YourApiKeyToken
        
        // https://api.etherscan.io/api?module=account&action=txlist&address=0x04Cc45CEa9a1dBfe76f70CbFDFC42Df76D188a8e&sort=asc&apikey=1IT9WXZ9X2AVMUFJHRBP7E8I6W6TXIMHEJ
        
        // https://api.polygonscan.com/api?module=account&action=txlist&address=0xb91dd8225Db88dE4E3CD7B7eC538677A2c1Be8Cb&startblock=0&endblock=99999999&page=1&offset=10&sort=asc&apikey=YourApiKeyToken
        var protocolType: String {
             if coindetail.address != "" {
                return "token_20"
            } else {
                return ""
            }
        }
        let apiURL = "https://www.oklink.com/api/v5/explorer/address/transaction-list?chainShortName=\(coindetail.chain?.chainName ?? "")&page=\(page)&address=\(coindetail.chain?.walletAddress ?? "")&limit=50&tokenContractAddress=\(coindetail.address ?? "")&protocolType=\(protocolType)"
           
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiURL), HttpMethod: .get, parameters: nil, headers: APIKey.okLinkHeader) { result in
            
            switch result {
                
            case .success((_,let response)):
                do {
                    let decodedRes = try JSONDecoder().decode(TransactionData.self, from: response)
                    completion(decodedRes.data?.first?.transactionLists,true,"")
                  
                } catch(let error) {
                    print(error)
                    completion(nil,false,error.localizedDescription)
                }
                
            case .failure(let error):
                print("errorvalue",error)
                completion(nil,false,error.rawValue)
            }
        }
    }
    
    /// apiGetInternalTransactionaHistroy
    func apiGetInternalTransactionaHistroy(_ coindetail: Token,_ page: String,completion: @escaping (([TransactionResult]?,Bool,String) -> Void)) {
    
        let protocolType = "internal"
        let apiURL = "https://www.oklink.com/api/v5/explorer/address/transaction-list?chainShortName=\(coindetail.chain?.chainName ?? "")&page=\(page)&address=\(coindetail.chain?.walletAddress ?? "")&limit=50&tokenContractAddress=\(coindetail.address ?? "")&protocolType=\(protocolType)"
           
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiURL), HttpMethod: .get, parameters: nil, headers: APIKey.okLinkHeader) { result in
            
            switch result {
                
            case .success((_,let response)):
                do {
                    let decodedRes = try JSONDecoder().decode(TransactionData.self, from: response)
                    completion(decodedRes.data?.first?.transactionLists,true,"")
                  
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
    
    func getTransactionHistortyNew1(_ coindetail: Token,_ page: String,completion: @escaping (([TransactionHistoryResult]?,Bool,String) -> Void)) {
        
        let apiURL = "https://plutope.app/api/wallet-transcation?wallet_address=\(coindetail.chain?.walletAddress ?? "")&chain=\(coindetail.chain?.chainName ?? "")&token_address=\(coindetail.address ?? "")"
        //
        DGNetworkingServices.main.MakeApiCall(Service: NetworkURL(withURL: apiURL), HttpMethod: .get, parameters: nil, headers: nil) { result in
            
            switch result {
                
            case .success((_,let response)):
                do {
                    let decodedRes = try JSONDecoder().decode(TransactionHistoryDataNew.self, from: response)
                    completion(decodedRes.data,true,"")
                  
                } catch(let error) {
                    print(error)
                    completion(nil,false,error.localizedDescription)
                }
                
            case .failure(let error):
                print("errorvalue",error)
                completion(nil,false,error.rawValue)
            }
        }
    }
    func getTransactionHistortyNew(
        _ coindetail: Token,
        cursor: String?,
        completion: @escaping (([TransactionHistoryResult]?, String?, Bool, String) -> Void)
    ) {
        // Construct base URL
        var components = URLComponents(string: "https://plutope.app/api/wallet-transcation")!
        print("chain",coindetail.chain?.chainName ?? "")
        // Build query items
        var queryItems = [
            URLQueryItem(name: "wallet_address", value: coindetail.chain?.walletAddress ?? ""),
            URLQueryItem(name: "chain", value: coindetail.chain?.chainName ?? ""),
            URLQueryItem(name: "token_address", value: coindetail.address ?? "")
        ]
        
        if let cursor = cursor, !cursor.isEmpty {
            queryItems.append(URLQueryItem(name: "cursor", value: cursor))
        }

        components.queryItems = queryItems

        // Ensure valid URL
        guard let url = components.url else {
            completion(nil, nil, false, "Invalid URL")
            return
        }

        print("➡️ Final URL: \(url.absoluteString)")

        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Uncomment if your API requires headers
        // request.setValue("your-api-key", forHTTPHeaderField: "X-API-Key")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, nil, false, error.localizedDescription)
                print("➡️ Fetching transaction with error : \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, nil, false, "Invalid response")
                print("➡️ Invalid response : ")
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(nil, nil, false, "HTTP \(httpResponse.statusCode)")
                print("➡️ statusCode :\(httpResponse.statusCode) ")
                return
            }

            guard let data = data else {
                completion(nil, nil, false, "Empty response")
                return
            }

            do {
                let decodedRes = try JSONDecoder().decode(TransactionHistoryDataNew.self, from: data)
                print("➡️ decodedRes :\(decodedRes.data) ")
                completion(decodedRes.data, decodedRes.cursor, true, "")
            } catch {
                print("➡️ Decoding error :\(error.localizedDescription) ")
                completion(nil, nil, false, "Decoding error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }


}

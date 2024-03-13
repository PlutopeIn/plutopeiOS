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
                print(error)
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
}

//
//  TokenListViewModel.swift
//  PlutoPe
//
//  Created by Mitali Desai on 08/05/23.
//
import Foundation
/// TokenListViewModel
class TokenListViewModel {
    
    private var failblock: BindFail? = nil
    private lazy var repo: TokenListRepo? = TokenListRepo()
    var tokenPriceData: Observable<[String: AssetsList]> = .init([:])
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    
    /// apiGetCoinPrice
    func apiGetCoinPrice(_ currency: String,_ symbolList: [String],completion: @escaping (([String: AssetsList]?,Bool,String) -> Void)) {
        
        repo?.apiGetCoinPrice(currency, symbolList, completion: { assets, status, msg in
            if status {
                //                self.tokenPriceData.value = assets ?? [:]
                completion(assets,status,msg)
            } else {
                self.failblock?(false, msg)
            }
        })
    }
    
    func apiGetTokenImagesFromApi(completion: @escaping (([BackendTokenList]?,Bool,String) -> Void)) {
        repo?.apiGetTokenImagesFromApi(completion: { assets, status, msg in
            if status {
                completion(assets,status,msg)
            } else {
                self.failblock?(false, msg)
            }
        })
    }
    
    func getBitcoinBalanceAPI(walletAddress:String,completion: @escaping ((Double) -> Void)) {
        repo?.apiGetBitcoinBalance(walletAddress: walletAddress, completion: { balance in
            completion(balance)
        })
    }
    
    func apiGetActiveTokens(walletAddress:String,completion: @escaping (([ActiveTokens]?,Bool) -> Void)) {
        repo?.apiGetActiveTokens(walletAddress: walletAddress, completion: { data, status in
            completion(data,status)
        })
    }
}

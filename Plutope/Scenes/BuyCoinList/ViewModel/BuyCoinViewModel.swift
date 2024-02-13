//
//  BuyCoinViewModel.swift
//  Plutope
//
//  Created by Priyanka Poojara on 22/06/23.
//
import Foundation
// Coin minimum price View Model
class CoinMinPriceViewModel {
    
    private var failblock: BindFail?
    private lazy var repo: CoinPriceRepo? = CoinPriceRepo()
    var tokenPriceData: Observable<[String: CoinPrice]> = .init([:])
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    
    /// apiGetCoinPrice
    func apiGetCoinPrice(_ symbol: String, completion: @escaping ((CoinPrice?,Bool,String) -> Void)) {
        
        repo?.apiGetMinPrice(symbol: symbol, completion: { coinData, status, message in
            if status {
                completion(coinData, status, message)
            } else {
                self.failblock?(false, message)
            }
        })
        
    }
    
}

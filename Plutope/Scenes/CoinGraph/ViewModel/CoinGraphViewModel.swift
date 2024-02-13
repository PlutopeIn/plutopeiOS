//
//  CoinGraphViewModel.swift
//  Plutope
//
//  Created by Mitali Desai on 29/06/23.
//

import Foundation
class CoinGraphViewModel {
 
    private var failblock: BindFail? = nil
    private lazy var repo: CoinGraphRepo? = CoinGraphRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    
    /// apiGraphData
    func apiGraphData(_ chain: String,currency: String,days: String,completion: @escaping ((Bool,String,GraphData?) -> Void)) {
        repo?.apiGraphData(chain, currency: currency, days: days, completion: { status, err, graphData in
            if status == true {
                completion(status,err,graphData)
            } else {
                self.failblock?(false, err)
            }
        })
    }
    
    /// apiMarketVolumeData
    func apiMarketVolumeData(_ vsCurrency: String,ids: String,completion: @escaping ((Bool,String,[MarketData]?) -> Void)) {
        repo?.apiMarketVolumeData(vsCurrency, ids: ids,completion: { status, err, marketData in
            if status == true {
                completion(status,err,marketData)
            } else {
                self.failblock?(false, err)
            }
        })
    }
    
    /// apiCoinList
    func apiCoinList(completion: @escaping ((Bool,String,[CoingechoCoinList]?) -> Void)) {
        repo?.apiCoinList(completion: { status, errmsg, coinList in
            if status == true {
                completion(status,errmsg,coinList)
            } else {
                self.failblock?(false, errmsg)
            }
        })
    }
    
    /// apiCoin Info
    func apiCoinInfo(tokenID: String, completion: @escaping ((Bool,String,CoinInfoData?) -> Void)) {
        repo?.apiCoinInfo(tokenID: tokenID, completion: { status, message, coinInfo in
            if status == true {
                completion(status, message, coinInfo)
            } else {
                self.failblock?(false, message)
            }
        })
    }
}

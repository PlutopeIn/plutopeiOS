//
//  ProviderViewModel.swift
//  Plutope
//
//  Created by Mitali Desai on 11/07/23.
//

import Foundation

class ProviderViewModel {
    
    private var failblock: BindFail?
    private lazy var repo: ProviderRepo? = ProviderRepo()
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
    
    func apiGetOnMetaBestPrice(buyTokenSymbol: String,chainId: String,fiatCurrency: String,fiatAmount: String,senderAddress: String,buyTokenAddress: String,type : ProviderType = .buy,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        repo?.apiGetOnMetaBestPrice(buyTokenSymbol: buyTokenSymbol, chainId: chainId, fiatCurrency: fiatCurrency, fiatAmount: fiatAmount, buyTokenAddress: buyTokenAddress,senderAddress:senderAddress,type: type, completion: { status, errMsg, data in
            completion(status,errMsg,data)
        })
    }
    
    func apiGetChangeNowBestPrice(fromCurrency: String,toCurrency: String,fromAmount: String,type : ProviderType = .buy,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        repo?.apiGetChangeNowBestPrice(fromCurrency: fromCurrency,toCurrency: toCurrency,fromAmount: fromAmount,type: type, completion: { status, errMsg, data in
//            if status {
                completion(status,errMsg,data)
//            } else {
//                self.failblock?(false, errMsg)
//            }
        })
    }
    
    func apiGetOnRampBestPrice(coinCode: String,chainId: String,network: String,fiatAmount: String,currency: String,type : ProviderType = .buy,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        repo?.apiGetOnRampBestPrice(coinCode: coinCode,chainId: chainId,network: network,fiatAmount: fiatAmount,currency: currency,type: type,completion: { status, errMsg, data in
            completion(status,errMsg,data)
        })
    }
    
    func apiGetMeldBestPrice(sourceAmount: String,sourceCurrencyCode: String,destinationCurrencyCode: String,countryCode: String,type : ProviderType = .buy,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        repo?.apiGetMeldBestPrice(sourceAmount: sourceAmount, sourceCurrencyCode: sourceCurrencyCode, destinationCurrencyCode: destinationCurrencyCode, countryCode: countryCode,type: type,completion: { status, errMsg, data in
            completion(status,errMsg,data)
        })
    }
    
    func apiGetUnlimitBestPrice(payment: String,crypto: String,fiat: String,amount: String,region: String,type : ProviderType = .buy,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        repo?.apiGetUnlimitBestPrice(payment: payment, crypto: crypto, fiat: fiat, amount: amount, region: region, completion: { status, errMsg, data in
            completion(status,errMsg,data)
        })
    }
}

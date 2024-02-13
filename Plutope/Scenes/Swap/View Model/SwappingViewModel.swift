//
//  SwappingViewModel.swift
//  Plutope
//
//  Created by Mitali Desai on 22/05/23.
//
import Foundation

/// SwappingViewModel
class SwappingViewModel {
    
    private var failblock: BindFail?
    private lazy var repo: SwappingRepo? = SwappingRepo()
//    var currencies: Observable<[TransactionCurrencies]> = .init([])
    
    init(_ bindFailure: @escaping BindFail) {
       // apiGetCurrencies()
        self.failblock = bindFailure
    }
    
    /// apiSwapping
    func apiSwapping(address: String,fromCurrency: String,toCurrency: String,fromNetwork: String,toNetwork: String,fromAmount: String,toAmount: String,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
     
        repo?.apiSwapping(address: address,fromCurrency: fromCurrency,toCurrency: toCurrency,fromNetwork: fromNetwork,toNetwork: toNetwork,fromAmount: fromAmount,toAmount: toAmount,completion: { status,error,data  in
            if status {
                completion(true,error,data)
            } else {
                completion(false,error,data)
            }
        })
    }
    
    /// apiRangoSwappingQuote
    func apiRangoQuoteSwapping(address: String,fromToken: Token,toToken: Token,fromAmount: String,fromWalletAddress:String,toWalletAddress:String,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        
        repo?.apiRangoQuoteSwapping(walletAddress : address,fromToken: fromToken,toToken: toToken,fromAmount:fromAmount,fromWalletAddress:fromWalletAddress,toWalletAddress:toWalletAddress,completion: { status,error,data  in
            if status {
                completion(true,error,data)
            } else {
                completion(false,error,data)
            }
        })
    }
    
    ///
    /// apiRangoSwapping
    func apiRangoSwapping(address: String,fromToken: Token,toToken: Token,fromAmount: String,fromWalletAddress:String,toWalletAddress:String,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        
        repo?.apiRangoSwapping(walletAddress : address,fromToken: fromToken,toToken: toToken,fromAmount: fromAmount,fromWalletAddress:fromWalletAddress,toWalletAddress:toWalletAddress,completion: { status,error,data  in
            if status {
                completion(true,error,data)
            } else {
                completion(false,error,data)
            }
        })
    }
    
    /// apiSwapping
    func apiGetTransactionStatus(_ transactionID: String?,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
     
        repo?.apiGetTransactionStatus(transactionID,completion: { status,error,data  in
            if status {
                completion(true,error,data)
            } else {
                self.failblock?(false, error)
            }
        })
    }
    
//     apiGetCurrencies
//    func apiGetCurrencies() {
//
//        repo?.apiGetCurrencies(completion: { assets, status, msg in
//            if status {
//                self.currencies.value = assets ?? []
//            } else {
//                self.failblock?(false, msg)
//            }
//        })
//    }
    
    /// apiOKTSwapping
    func apiOKTSwapping(fromTokenAddress: String,toTokenAddress: String,amount: String,chainId: String,userWalletAddress: String,slippage: String,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        
        repo?.apiOKTSwapping(fromTokenAddress: fromTokenAddress, toTokenAddress: toTokenAddress, amount: amount, chainId: chainId, userWalletAddress: userWalletAddress, slippage: slippage, completion: { status, err, data in
            if status {
                completion(true,err,data)
            } else {
//                self.failblock?(false, err)
                completion(false,err,data)
            }
        })
        
    }
    /// apiGetExchangePairs
    func apiGetExchangePairs(fromCurrency: String,fromNetwork: String,toNetwork: String,completion: @escaping (([ExchangePairsData]?,Bool,String) -> Void)) {
        
        repo?.apiGetExchangePairs(fromCurrency: fromCurrency, fromNetwork: fromNetwork, toNetwork: toNetwork, completion: { pairdata, status, err in
            if status {
                completion(pairdata,true,err)
            } else {
                self.failblock?(false, err)
            }
        })
    }
    func apiOKTApproveSwap(tokenContractAddress: String,approveAmount: String,chainId: String,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        
        repo?.apiOKTApproveSwap(tokenContractAddress: tokenContractAddress,approveAmount: approveAmount,chainId: chainId ,completion: { status, err, data in
            if status {
                completion(true,err,data)
            } else {
                self.failblock?(false, err)
            }
        })
        
    }
}

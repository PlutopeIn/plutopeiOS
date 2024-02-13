//
//  CurrencyViewModel.swift
//  Plutope
//
//  Created by Priyanka Poojara on 05/07/23.
//

import Foundation

class CurrencyViewModel {
    
    private var failblock: BindFail?
    private lazy var repo: CurrencyRepo? = CurrencyRepo()
    
    var currencyData: Observable<[CurrencyList]> = .init([])
    
    init(_ bindFailure: @escaping BindFail) {
        self.failblock = bindFailure
    }
        
    func apiGet( completion: @escaping (([CurrencyList]?,Bool,String) -> Void)) {
        repo?.apiGetCurrencyList(completion: { currencyData, status, message in
            if status {
                completion(currencyData, true, "")
            } else {
                completion(nil, false, message)
            }
        })
    }
}

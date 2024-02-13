//
//  CurrencyRepo.swift
//  Plutope
//
//  Created by Priyanka Poojara on 05/07/23.
//

import UIKit
import DGNetworkingServices

class CurrencyRepo {
    
    func apiGetCurrencyList(completion: @escaping([CurrencyList]?, Bool, String) -> Void) {
        
        guard let url = Bundle.main.url(forResource: "CurrencyData", withExtension: "json"),
        let data = try? Data(contentsOf: url) else {
            completion(nil, false, "File not found")
            return
        }
        let decoder = JSONDecoder()
        do {
            let jsonData = try decoder.decode([CurrencyList].self, from: data)
            completion(jsonData, true, "")
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil, false, "Couldn't fetch data \(error)")
        }
        
    }
}

//
//  BuyCoin+APIS.swift
//  Plutope
//
//  Created by Mitali Desai on 14/07/23.
//

import Foundation

// MARK: APIS
extension BuyCoinViewController {
    func getOnMetaBestPrice(buyTokenSymbol: String, chainId: String, fiatCurrency: String, fiatAmount: String, buyTokenAddress: String, completion: @escaping APICompletionHandler) {
        viewModel.apiGetOnMetaBestPrice(buyTokenSymbol: buyTokenSymbol, chainId: chainId,
                                        fiatCurrency: fiatCurrency, fiatAmount: fiatAmount, senderAddress:"", buyTokenAddress: buyTokenAddress) { status, _, data in
            completion(status, data)
        }
    }
    
    func getChangeNowBestPrice(fromCurrency: String, toCurrency: String, fromAmount: String, completion: @escaping APICompletionHandler) {
        viewModel.apiGetChangeNowBestPrice(fromCurrency: fromCurrency, toCurrency: toCurrency, fromAmount: fromAmount) { status, _, data in
            completion(status, data)
        }
    }
    
    func getOnRampBestPrice(coinCode: String, chainId: String, network: String, fiatAmount: String, currency: String,completion: @escaping APICompletionHandler) {
        viewModel.apiGetOnRampBestPrice(coinCode: coinCode, chainId: chainId, network: network, fiatAmount: fiatAmount, currency: currency) { status, _, data in
            completion(status, data)
        }
    }
    func getMeldBestPrice(sourceAmount: String,sourceCurrencyCode: String,destinationCurrencyCode: String,countryCode: String,completion: @escaping APICompletionHandler) {
        viewModel.apiGetMeldBestPrice(sourceAmount: sourceAmount, sourceCurrencyCode: sourceCurrencyCode, destinationCurrencyCode: destinationCurrencyCode, countryCode: countryCode) { status, _, data in
            completion(status, data)
        }
    }
    func getUnlimitBestPrice(payment: String,crypto: String,fiat: String,amount: String,region: String,completion: @escaping APICompletionHandler) {
        viewModel.apiGetUnlimitBestPrice(payment: payment, crypto: crypto, fiat: fiat, amount: amount, region: region) { status, _, data in
            completion(status, data)
        }
    }
}

// MARK: APIS
extension BuyCoinViewController {
    
    func checkAllAPIsCompleted() {
        // Determine the supported providers based on your logic
        apiCount += 1
        
        if apiCount == supportedProviders.count {
            getBestPriceFromAllBestPrices()
        }
    }
    
    func callAPIsAfterTaskCompletion() {
        guard let coinDetail = coinDetail, let selectedCurrency = selectedCurrency else {
            return
        }
        
        for provider in supportedProviders {
            switch provider {
                /// temporary hide onMeta code 
            case .onMeta:
                getOnMetaBestPrice(buyTokenSymbol: coinDetail.symbol?.lowercased() ?? "",
                                   chainId: coinDetail.chain?.chainId ?? "",
                                   fiatCurrency: selectedCurrency.symbol ?? "",
                                   fiatAmount: txtPrice.text ?? "",
                                   buyTokenAddress: coinDetail.address ?? "") { status, data in
                    self.handleAPIResponse(providerName: StringConstants.onMeta, status: status, data: data)
                }
            case .changeNow:
                let toCurrency = determineToCurrency(coinDetail: coinDetail)
                getChangeNowBestPrice(fromCurrency: selectedCurrency.symbol ?? "",
                                      toCurrency: toCurrency ,
                                      fromAmount: txtPrice.text ?? "") { status, data in
                    self.handleAPIResponse(providerName: StringConstants.changeNow, status: status, data: data)
                }
            case .onRamp:
                getOnRampBestPrice(coinCode: coinDetail.symbol ?? "",
                                   chainId: coinDetail.chain?.chainId ?? "",
                                   network: coinDetail.type ?? "",
                                   fiatAmount: txtPrice.text ?? "",
                                   currency: selectedCurrency.symbol ?? "") { status, data in
                    self.handleAPIResponse(providerName: StringConstants.onRamp, status: status, data: data)
                }
            case .meld:
                let countryCode = (selectedCurrency.symbol ?? "").prefix(2)
                getMeldBestPrice(sourceAmount: txtPrice.text ?? "",
                                 sourceCurrencyCode: selectedCurrency.symbol ?? "",
                                 destinationCurrencyCode: coinDetail.symbol ?? "",
                                 countryCode: "\(countryCode)") { status, data in
                    self.handleAPIResponse(providerName: StringConstants.meld, status: status, data: data)
                }
            case .alchemy:
                break
            case.unlimit:
                let crypto = "\(coinDetail.symbol ?? "")-\(coinDetail.type ?? "")"
                let countryCode = (selectedCurrency.symbol ?? "").prefix(2)
                getUnlimitBestPrice(payment: "BANKCARD", crypto: crypto, fiat: selectedCurrency.symbol ?? "", amount: txtPrice.text ?? "", region: "\(countryCode)") { status, data in
                    self.handleAPIResponse(providerName: StringConstants.unLimit, status: status, data: data)
                }
            }
        }
    }
  
    // Example of a separate function for determining toCurrency
    func determineToCurrency(coinDetail: Token) -> String {
        if coinDetail.address != "" {
            switch coinDetail.chain {
            case .polygon:
                return "\(coinDetail.symbol?.lowercased() ?? "")matic"
            case .binanceSmartChain:
                return "\(coinDetail.symbol?.lowercased() ?? "")bsc"
            case .ethereum:
                return "\(coinDetail.symbol?.lowercased() ?? "")"
            case .oKC:
                return ""
            case .bitcoin:
                return "\(coinDetail.symbol?.lowercased() ?? "")"
            default:
                return ""
            }
        } else {
            switch coinDetail.chain {
            case .polygon:
                return "\(coinDetail.symbol?.lowercased() ?? "")mainnet"
            case .binanceSmartChain:
                return "\(coinDetail.symbol?.lowercased() ?? "")bsc"
            case .ethereum:
                return "\(coinDetail.symbol?.lowercased() ?? "")"
            case .oKC:
                return ""
            case .bitcoin:
                return "\(coinDetail.symbol?.lowercased() ?? "")"
            default:
                return ""
            }
        }
    }
    
    func handleAPIResponse(providerName: String, status: Bool, data: [String: Any]?) {
        if status {
           
            switch providerName {
            case StringConstants.onMeta:
                if let providerIndex = allProviders.indices.first(where: { allProviders[$0].name == providerName }) {
                    allProviders[providerIndex].bestPrice = (data?["data"] as? [String: Any])?["receivedTokens"] as? String
                }
            case StringConstants.changeNow:
                if let providerIndex = allProviders.indices.first(where: { allProviders[$0].name == providerName }) {
                    allProviders[providerIndex].bestPrice = "\(data?["toAmount"] as? Double ?? 0.0)"
                }
            case StringConstants.onRamp:
                if let providerIndex = allProviders.indices.first(where: { allProviders[$0].name == providerName }) {
                    allProviders[providerIndex].bestPrice = "\(data?["quantity"] as? Double ?? 0.0)"
                }
            case StringConstants.meld:
                if let providerIndex = allProviders.indices.first(where: { allProviders[$0].name == providerName }),
                   let quotes = data?["quotes"] as? [[String: Any]] {
                    let destinationAmounts = quotes.compactMap { $0["destinationAmount"] as? Double }
                    let maxDestinationAmount = destinationAmounts.max() ?? 0.0
                    allProviders[providerIndex].bestPrice = "\(maxDestinationAmount)"
                } else {
                    if let providerIndex = allProviders.indices.first(where: { allProviders[$0].name == providerName }) {
                        allProviders[providerIndex].bestPrice = ""
                    }
                }
            case StringConstants.unLimit:
                if let providerIndex = allProviders.indices.first(where: { allProviders[$0].name == providerName }) {
                    let amount = "\(data?["amountOut"] ?? "")"
                    let bestPrice = Double(amount)
                    allProviders[providerIndex].bestPrice = "\(bestPrice ?? 0.0)"
                }
            default:
                break
            }
        } else {
            if let providerIndex = allProviders.indices.first(where: { allProviders[$0].name == providerName }) {
                allProviders[providerIndex].bestPrice = ""
            }
        }
        
        checkAllAPIsCompleted()
    }

    func getCountryCode(fromCurrencyCode currencyCode: String) -> String? {
        let identifiers = Locale.availableIdentifiers
        for identifier in identifiers {
            let locale = Locale(identifier: identifier)
            guard let localeCurrencyCode = locale.currencyCode,
                  let countryCode = locale.localizedString(forRegionCode: localeCurrencyCode),
                  localeCurrencyCode != currencyCode else {
                continue
            }
            
            return countryCode
        }
        
        return nil
    }

}

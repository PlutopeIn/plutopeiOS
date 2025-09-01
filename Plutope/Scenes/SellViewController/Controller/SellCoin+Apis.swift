//
//  SellCoin+Apis.swift
//  Plutope
//
//  Created by Mitali Desai on 26/07/23.
//

import Foundation

// MARK: APIS
extension SellCoinViewController {
    func getOnMetaBestPrice(buyTokenSymbol: String, chainId: String, fiatCurrency: String, fiatAmount: String, buyTokenAddress: String, completion: @escaping APICompletionHandler) {
        viewModel.apiGetOnMetaBestPrice(buyTokenSymbol: buyTokenSymbol, chainId: chainId, fiatCurrency: fiatCurrency, fiatAmount: fiatAmount, senderAddress: self.coinDetail?.chain?.walletAddress ?? "", buyTokenAddress: buyTokenAddress,type: .sell) { status, _, data in
            completion(status, data)
        }
    }
    
    func getChangeNowBestPrice(fromCurrency: String, toCurrency: String, fromAmount: String, completion: @escaping APICompletionHandler) {
        viewModel.apiGetChangeNowBestPrice(fromCurrency: fromCurrency, toCurrency: toCurrency, fromAmount: fromAmount,type: .sell) { status, _, data in
            completion(status, data)
        }
    }
    
    func getOnRampBestPrice(coinCode: String, chainId: String, network: String, fiatAmount: String, currency: String,completion: @escaping APICompletionHandler) {
        viewModel.apiGetOnRampBestPrice(coinCode: coinCode, chainId: chainId, network: network, fiatAmount: fiatAmount, currency: currency,type: .sell) { status, _, data in
            completion(status, data)
        }
    }
//    func getMeldBestPrice(sourceAmount: String,sourceCurrencyCode: String,destinationCurrencyCode: String,countryCode: String,completion: @escaping APICompletionHandler) {
//        viewModel.apiGetMeldBestPrice(sourceAmount: sourceAmount, sourceCurrencyCode: sourceCurrencyCode, destinationCurrencyCode: destinationCurrencyCode, countryCode: countryCode,type: .sell) { status, _, data in
//            completion(status, data)
//        }
//    }
}

// MARK: APIS
extension SellCoinViewController {
    
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
            case .onMeta:
                getOnMetaBestPrice(buyTokenSymbol: coinDetail.symbol?.lowercased() ?? "",
                                   chainId: coinDetail.chain?.chainId ?? "",
                                   fiatCurrency: selectedCurrency.symbol ?? "",
                                   fiatAmount: "\((Double(lblPrice.text ?? "") ?? 0.0) * (Double(coinDetail.price ?? "") ?? 0.0))",
                                   buyTokenAddress: coinDetail.address ?? "") { status, data in
                    self.handleAPIResponse(providerName: StringConstants.onMeta, status: status, data: data)
                }
            case .changeNow:
                
                var toCurrency : String? {
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
//                        case .opMainnet:
//                            return "\(coinDetail.symbol?.lowercased() ?? "")"
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
//                        case .opMainnet:
//                            return "\(coinDetail.symbol?.lowercased() ?? "")"
                        default:
                            return ""
                        }

                    }
                }
                getChangeNowBestPrice(fromCurrency: selectedCurrency.symbol ?? "",
                                      toCurrency: toCurrency ?? "",
                                      fromAmount: lblPrice.text ?? "") { status, data in
                    self.handleAPIResponse(providerName: StringConstants.changeNow, status: status, data: data)
                }
            case .onRamp:
                getOnRampBestPrice(coinCode: coinDetail.symbol ?? "",
                                   chainId: coinDetail.chain?.chainId ?? "",
                                   network: coinDetail.type ?? "",
                                   fiatAmount: lblPrice.text ?? "",
                                   currency: selectedCurrency.symbol ?? "") { status, data in
                    self.handleAPIResponse(providerName: StringConstants.onRamp, status: status, data: data)
                }
//            case .meld:
//                let countryCode = (selectedCurrency.symbol ?? "").prefix(2)
//                getMeldBestPrice(sourceAmount: lblPrice.text ?? "",
//                                 sourceCurrencyCode: selectedCurrency.symbol ?? "",
//                                 destinationCurrencyCode: coinDetail.symbol ?? "",
//                                 countryCode: "\(countryCode)") { status, data in
//                    self.handleAPIResponse(providerName: StringConstants.meld, status: status, data: data)
//                }
//            case .alchemy:
//                break
            }
        }
    }

    func handleAPIResponse(providerName: String, status: Bool, data: [String: Any]?) {
        if status {
            switch providerName {
            case StringConstants.onMeta:
                if let providerIndex = allProviders.indices.first(where: { allProviders[$0].name == providerName }) {
                    allProviders[providerIndex].bestPrice = "\((data?["data"] as? [String: Any])?["fiatAmount"] as? Double ?? 0.0)"
                }
            case StringConstants.changeNow:
                if let providerIndex = allProviders.indices.first(where: { allProviders[$0].name == providerName }) {
                    allProviders[providerIndex].bestPrice = "\(data?["toAmount"] as? Double ?? 0.0)"
                }
            case StringConstants.onRamp:
                if let providerIndex = allProviders.indices.first(where: { allProviders[$0].name == providerName }) {
                    allProviders[providerIndex].bestPrice = "\(data?["quantity"] as? Double ?? 0.0)"
                }
//            case StringConstants.meld:
//                if let providerIndex = allProviders.indices.first(where: { allProviders[$0].name == providerName }),
//                   let quotes = data?["quotes"] as? [[String: Any]] {
//                    let destinationAmounts = quotes.compactMap { $0["destinationAmount"] as? Double }
//                    let maxDestinationAmount = destinationAmounts.max() ?? 0.0
//                    allProviders[providerIndex].bestPrice = "\(maxDestinationAmount)"
//                } else {
//                    if let providerIndex = allProviders.indices.first(where: { allProviders[$0].name == providerName }) {
//                        allProviders[providerIndex].bestPrice = ""
//                    }
//                }
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

//
//  ProviderModel.swift
//  Plutope
//
//  Created by Priyanka Poojara on 21/06/23.
//
import Foundation
import UIKit

struct BuyCrypto {
    
    enum Domain: Equatable {
        case meld(
            name: String? = "",
            bestPrice: String? = "",
            countryCode: String? = "",
            sourceAmount: String? = "",
            sourceCurrencyCode: String? = "",
            destinationCurrencyCode: String? = "",
            walletAddress: String? = "",
          
            networkType: String? = "",
            tokenAddress: String? = ""
        )
        
        case onRamp(
            name: String? = "",
            bestPrice: String? = "",
            coinCode: String? = "",
            walletAddress: String? = "",
            fiatAmount: String? = "",
            networkType: String? = ""
        )
        
        case changeNow(
            name: String? = "",
            bestPrice: String? = "",
            from: String? = "",
            toAddress: String? = "",
            fiatMode: Bool? = false,
            amount: String? = "",
            recipientAddress: String? = ""
        )
        
        case onMeta(
            name: String? = "",
            bestPrice: String? = "",
            apiKey: String? = "",
            walletAddress: String? = "",
            fiatAmount: String? = "",
            chainId: String? = "",
            tokenAddress: String? = "",
            tokenSymbol: String? = ""
        )
        
        case alchemy(
            name: String? = "",
            bestPrice: String? = "",
            apiKey: String? = "",
            walletAddress: String? = "",
            fiatAmount: String? = "",
            chainId: String? = "",
            tokenAddress: String? = ""
        )
        case unlimit(
            name: String? = "",
            bestPrice: String? = "",
            merchantId: String = "",
            destinationCurrencyCode: String? = "",
            fiatAmount: String? = "",
            countryCode: String? = "",
            networkType  : String? = ""
           

        )
    }
    static func getMeldTokenName( destinationCurrencyCode: String? = "",networkType: String? = "",tokenAddress: String? = "") -> String {
        
        var toCurrency : String? {
            if tokenAddress != "" {
                switch networkType {
                case "POLYGON":
                    return destinationCurrencyCode!+"_POLYGON"
                case "BEP20":
                    return destinationCurrencyCode!+"_BSC"
                case "ERC20":
                    return "\(destinationCurrencyCode ?? "")_ETH"
                case "KIP20":
                    return  destinationCurrencyCode
                case "BTC":
                    return destinationCurrencyCode
                default:
                    return destinationCurrencyCode
                }
            } else {
                switch networkType {
                case "POLYGON":
                    return destinationCurrencyCode
                case "BEP20":
                    return destinationCurrencyCode!+"_BSC"
                case "ERC20":
                    return destinationCurrencyCode
                case "KIP20":
                    return destinationCurrencyCode
                case "BTC":
                    return destinationCurrencyCode
                default:
                    return destinationCurrencyCode
                }
            }
        }
        
        return "\(toCurrency ?? "")"
    }
    
    static func buildURL(for domain: Domain) -> String {
        switch domain {
        case .meld(
            _,_,
            let countryCode,
            let sourceAmount,
            let sourceCurrencyCode,
            let destinationCurrencyCode,
            let walletAddress,
            let networkType,
            let tokenAddress
        ):
           
            let toCurrency = self.getMeldTokenName(destinationCurrencyCode: destinationCurrencyCode,networkType: networkType,tokenAddress: tokenAddress)
            print(toCurrency)
            return "https://www.fluidmoney.xyz?publicKey=WQ4Ds5T7qMmwTitbyH6eVv:6385eFN8rGk4fubQx2quWB7B7bzGhWwaMdcG&countryCodeLocked=\(countryCode ?? "")&sourceAmountLocked=\(sourceAmount ?? "")&sourceCurrencyCodeLocked=\(sourceCurrencyCode ?? "")&destinationCurrencyCodeLocked=\(toCurrency )&walletAddressLocked=\(walletAddress ?? "")"
        case .onRamp(
            _,_,
            let coinCode,
            let walletAddress,
            let fiatAmount,
            let networkType
        ):
            return "https://onramp.money/main/buy/?appId=1&coinCode=\(coinCode ?? "")&walletAddress=\(walletAddress ?? "")&fiatAmount=\(fiatAmount ?? "")&network=\(networkType?.lowercased() ?? "")"
            
        case .changeNow(
            _,_,
            let from,
            let toAddress,
            let fiatMode,
            let amount,
            let recipientAddress
        ):
            return "https://changenow.io/exchange?from=\(from ?? "")&to=\(toAddress ?? "")&fiatMode=\(fiatMode ?? false)&amount=\(amount ?? "")&recipientAddress=\(recipientAddress ?? "")"
        case .onMeta(
            _,_,
            let apiKey,
            let walletAddress,
            let fiatAmount,
            let chainId,
            let tokenAddress,
            let tokenSymbol
        ):
            return "https://plutope.app/api/on-meta?walletAddress=\(walletAddress ?? "")&tokenSymbol=\(tokenSymbol ?? "")&tokenAddress=\(tokenAddress ?? "")&chainId=\(chainId ?? "" )&fiatAmount=\(fiatAmount ?? "")"
//            return """
//                let createWidget = new onMetaWidget({
//                    elementId: 'widget',
//                    apiKey: '\(apiKey ?? "")',
//                    walletAddress: '\(walletAddress ?? "")',
//                    fiatAmount: '\(fiatAmount ?? "")',
//                    chainId: '\(chainId ?? "")',
//                    tokenAddress: '\(tokenAddress ?? "")',
//                    tokenSymbol: '\(tokenSymbol ?? "")'
//                });
//                createWidget.init();
//                createWidget.on(eventType, callbackFn);
//            """
        case .alchemy(
            _,_,
            let _,
            let walletAddress,
            let fiatAmount,
            let networkType,
            let _
        ):
            return "https://ramp.alchemypay.org/?appId=&crypto=usdt&network=\(networkType ?? "")&fiat=\(fiatAmount ?? "")&country=US&address=\(walletAddress ?? "")"
        case .unlimit(
            _,_,
            let merchantId,
            let destinationCurrencyCode,
            let fiatAmount,
            let countryCode,
            let networkType
            
        ):
            var toCurrency: String? {
                let baseCurrency = destinationCurrencyCode ?? ""
                
                switch (networkType, baseCurrency) {
                case ("POLYGON", _):
                    return "\(baseCurrency)-POLYGON"
                case ("BEP20", _):
                    return "\(baseCurrency)-BSC"
                case ("ERC20", let currencyCode) where !currencyCode.isEmpty:
                    return "\(currencyCode)-ETH"
                case ("KIP20", _):
                    return baseCurrency
                case ("BTC", _):
                    return baseCurrency
                default:
                    return baseCurrency
                }
            }
            return "https://onramp.gatefi.com/?merchantId=\(merchantId)&cryptoCurrency=\(toCurrency ?? "")&fiatAmount=\(fiatAmount ?? "")&fiatCurrency=\(countryCode ?? "")"
        }
    }
}

struct SellCrypto {
    
    enum Domain: Equatable {
//        case meld(
//            name: String? = "",
//            bestPrice: String? = "",
//            countryCode: String? = "",
//            sourceAmount: String? = "",
//            sourceCurrencyCode: String? = "",
//            destinationCurrencyCode: String? = "",
//            walletAddress: String? = "",
//            pubKey: String? = ""
//        )
        
        case onRamp(
            name: String? = "",
            bestPrice: String? = "",
            coinCode: String? = "",
            walletAddress: String? = "",
            coinAmount: String? = "",
            networkType: String? = ""
        )
        
        case changeNow(
            name: String? = "",
            bestPrice: String? = "",
            from: String? = "",
            toAddress: String? = "",
            fiatMode: Bool? = false,
            amount: String? = "",
            recipientAddress: String? = ""
        )
        
        case onMeta(
            name: String? = "",
            bestPrice: String? = "",
            apiKey: String? = "",
            walletAddress: String? = "",
            fiatAmount: String? = "",
            chainId: String? = "",
            tokenAddress: String? = "",
            tokenSymbol: String? = ""
        )
    }
    
    static func buildURL(for domain: Domain) -> String {
        switch domain {
//        case .meld(
//            _,_,
//            let countryCode,
//            let sourceAmount,
//            let sourceCurrencyCode,
//            let destinationCurrencyCode,
//            let walletAddress,
//            _
//        ):
//            return "https://www.fluidmoney.xyz?countryCode=\(countryCode ?? "")&sourceAmount=\(sourceAmount ?? "")&sourceCurrencyCode=\(sourceCurrencyCode ?? "")&destinationCurrencyCode=\(destinationCurrencyCode ?? "")&walletAddress=\(walletAddress ?? "")"
//
        case .onRamp(
            _,_,
            let coinCode,
            let walletAddress,
            let coinAmount,
            let networkType
        ):
            return "https://onramp.money/main/sell/?appId=1&coinCode=\(coinCode ?? "")&walletAddress=\(walletAddress ?? "")&coinAmount=\(coinAmount ?? "")&network=\(networkType?.lowercased() ?? "")"
            
        case .changeNow(
            _,_,
            let from,
            let toAddress,
            let fiatMode,
            let amount,
            let recipientAddress
        ):
            return "https://changenow.io/exchange?from=\(from ?? "")&to=\(toAddress ?? "")&fiatMode=\(fiatMode ?? false)&amount=\(amount ?? "")&recipientAddress=\(recipientAddress ?? "")"
            
        case .onMeta(
            _,_,
            let apiKey,
            let walletAddress,
            let fiatAmount,
            let chainId,
            let tokenAddress,
            let tokenSymbol
        ):
            
            return """
                let createWidget = new onMetaWidget({
                    elementId: 'widget',
                    apiKey: '\(apiKey ?? "")',
                    walletAddress: '\(walletAddress ?? "")',
                    fiatAmount: '\(fiatAmount ?? "")',
                    chainId: '\(chainId ?? "")',
                    tokenSymbol: '\(tokenSymbol ?? "")',
                    offRamp: 'enabled',
                    onRamp: 'disabled'
                });
                createWidget.init();
                createWidget.on(eventType, callbackFn);
            """
        }
    }
}

struct BuyProviders {
    let imageUrl: UIImage?
    let name: String?
    var bestPrice: String?
}

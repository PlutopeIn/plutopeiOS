//
//  ProviderRepo.swift
//  Plutope
//
//  Created by Mitali Desai on 11/07/23.
//

import Foundation
import DGNetworkingServices
import CryptoSwift
import NIOHTTP1

enum ProviderType {
    case sell
    case buy
    case swap
}

// MARK: ProviderRepo
class ProviderRepo {
    
    /// apiGetOnMetaBestPrice
    func apiGetOnMetaBestPrice(buyTokenSymbol: String,chainId: String,fiatCurrency: String,fiatAmount: String,buyTokenAddress: String,senderAddress: String,type : ProviderType = .buy, completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        
        var param : [String : Any] {
            if type == .buy {
                return ["buyTokenSymbol": buyTokenSymbol.uppercased(),
                        "chainId": Int(chainId) ?? 0,
                        "fiatCurrency": fiatCurrency.uppercased(),
                        "fiatAmount": Double(fiatAmount) ?? 0.0,
                        "buyTokenAddress": buyTokenAddress.lowercased()]
                
            } else {
                return ["sellTokenSymbol": buyTokenSymbol.uppercased(),
                        "chainId": Int(chainId) ?? 0,
                        "fiatCurrency": fiatCurrency.uppercased(),
                        "fiatAmount": Double(fiatAmount) ?? 0.0,
                        "sellTokenAddress": buyTokenAddress,
                        "senderAddress": senderAddress]
            }
            
        }
        
        print("onmeta",param)
        
        var apiURL : String {
            if type == .buy {
                return "https://api.onmeta.in/v1/quote/buy"
            } else {
                return "https://api.onmeta.in/v1/quote/sell"
            }
        }
        
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiURL), HttpMethod: .post, parameters: param, headers: APIKey.onMetaHeader) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!)
                    print(data)
                    completion(true,"",data as? [String: Any])
                } catch(let error) {
                    print(error)
                    completion(false,error.localizedDescription,nil)
                }
            } else {
                completion(false,error?.rawValue ?? "",nil)
            }
        }
    }
    
    /// apiGetChangeNowBestPrice
    func apiGetChangeNowBestPrice(fromCurrency: String,toCurrency: String,fromAmount: String,type : ProviderType = .buy,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        // https://api.changenow.io/v2/markets/estimate?fromCurrency=inr&toCurrency=usdt&fromAmount=1000&toAmount=null&type=direct
        var apiURL : String {
            if type == .buy {
                return "https://api.changenow.io/v2/markets/estimate?fromCurrency=\(fromCurrency)&toCurrency=\(toCurrency)&fromAmount=\(fromAmount)"
            } else {
                return "https://api.changenow.io/v2/markets/estimate?fromCurrency=\(toCurrency)&toCurrency=\(fromCurrency)&fromAmount=\(fromAmount)"
            }
        }
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiURL), HttpMethod: .get, parameters: nil, headers: APIKey.changeNowAPIHeader) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!)
                    completion(true,"",data as? [String: Any])
                } catch(let error) {
                    print(error)
                    completion(false,error.localizedDescription,nil)
                }
            } else {
                completion(false,error?.rawValue ?? "",nil)
            }
        }
    }
    
    /// apiGetOnRampBestPrice
    func apiGetOnRampBestPrice(coinCode: String,chainId: String,network: String,fiatAmount: String,currency: String,type : ProviderType = .buy,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        
//        1 -> INR (Indian rupee)
//        2 -> TRY (Turkish Lira)
//        3 -> Arab Emirates Dirham (AED)
//        4 -> Mexican Peso (MXN)
        
        var fiatType : String? {
            switch currency {
            case "INR":
                return "1"
            case "TRY":
                return "2"
            case "AED":
                return "3"
            case "MXN":
                return "4"
            default:
                return ""
            }
        }
        
        var networkType : String? {
            if network.lowercased() == "polygon" {
                return "matic20"
            } else {
                return network
            }
        }
        
        var param : [String : Any] {
            if type == .buy {
                return ["coinCode": coinCode.lowercased(),
                        "chainId": chainId,
                        "network": networkType?.lowercased() ?? "",
                        "fiatAmount": fiatAmount,
                        "fiatType": fiatType ?? "",
                        "type": "1"]
                
            } else {
                return ["coinCode": coinCode.lowercased(),
                        "chainId": chainId,
                        "network": networkType?.lowercased() ?? "",
                        "quantity": fiatAmount,
                        "fiatType": fiatType ?? "",
                        "type": "2"]
            }
            
        }
        
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let payload: [String: Any] = [
            "timestamp": timestamp,
            "body": param
        ]

        // Convert payload to base64
        guard let payloadData = try? JSONSerialization.data(withJSONObject: payload, options: [])
             else {
            print("Failed to encode payload")
            return
        }
        let payloadBase64 = payloadData.base64EncodedString()

        // Generate the signature using the API secret
        let secret = APIKey.onRampSecurityKey
        guard let signatureData = try? HMAC(key: secret.bytes, variant: .sha2(.sha512))
                .authenticate(payloadBase64.bytes) else {
            print("Failed to generate signature")
            return
        }
        let signature = signatureData.toHexString()

        // Set the request headers and data
        let headers = [
            "X-ONRAMP-SIGNATURE": signature,
            "X-ONRAMP-APIKEY": APIKey.onRampHeaderKey,
            "X-ONRAMP-PAYLOAD": payloadBase64
        ]

        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: "https://api.onramp.money/onramp/api/v2/common/transaction/quotes"), HttpMethod: .post, parameters: param, headers: headers) { status, error, data in
            if status {
                do {
        
                    let data = try JSONSerialization.jsonObject(with: data!) as? [String: Any]
                    let status = data?["status"] as? Int
                    if status == 1 {
                        completion(true,"",data?["data"] as? [String: Any])
                    } else {
                        print(error)
                        completion(false,error?.localizedDescription ?? "",nil)
                    }
                    
                } catch(let error) {
                    print(error)
                    completion(false,error.localizedDescription,nil)
                }
            } else {
                completion(false,error?.rawValue ?? "",nil)
            }
        }
    }
    
    /// apiGetMeldBestPrice
    func apiGetMeldBestPrice(sourceAmount: String,sourceCurrencyCode: String,destinationCurrencyCode: String,countryCode: String,type : ProviderType = .buy,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        
        let param = ["sourceAmount": sourceAmount,
                     "sourceCurrencyCode": sourceCurrencyCode,
                     "destinationCurrencyCode": destinationCurrencyCode,
                     "countryCode": countryCode]
        print("meld-PAram",param)
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: "https://api.meld.io/payments/crypto/quote"), HttpMethod: .post, parameters: param, headers: APIKey.meldApiHeader) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!)
                    completion(true,"",data as? [String: Any])
                } catch(let error) {
                    print(error)
                    completion(false,error.localizedDescription,nil)
                }
            } else {
                completion(false,error?.rawValue ?? "",nil)
            }
        }
    }
    /// apiGetunlimitBestPrice
    func apiGetUnlimitBestPrice(payment: String,crypto: String,fiat: String,amount: String,region: String,completion: @escaping ((Bool,String,[String: Any]?) -> Void)) {
        
        var apiURL = "https://plutope.app/api/unlimit-quote-buy?payment=\(payment)&crypto=\(crypto)&fiat=\(fiat)&amount=\(amount)&region=\(region)"
        
        DGNetworkingServices.main.dataRequest(Service: NetworkURL(withURL: apiURL), HttpMethod: .get, parameters: nil, headers: nil) { status, error, data in
            if status {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!)
                    completion(true,"",data as? [String: Any])
                } catch(let error) {
                    print(error)
                    completion(false,error.localizedDescription,nil)
                }
            } else {
                completion(false,error?.rawValue ?? "",nil)
            }
        }
    }
}

//
//  BrowserCommand.swift
//  Plutope
//
//  Created by Trupti Mistry on 13/03/24.
//

// Copyright DApps Platform Inc. All rights reserved.

import Foundation

public struct DappCommand: Decodable {
    public let name: Method
    public let id: Int
    public let object: String
}


struct DappCallback {
    let id: Int
    let value: DappCallbackValue
}
enum DappCallbackValue {
    case signTransaction(Data)
    case sentTransaction(Data)
    case signMessage(Data)
    case signPersonalMessage(Data)
    case signTypedMessage(Data)

    var object: String {
        switch self {
        case .signTransaction(let data):
            return data.hexEncoded
        case .sentTransaction(let data):
            return data.hexEncoded
        case .signMessage(let data):
            return data.hexEncoded
        case .signPersonalMessage(let data):
            return data.hexEncoded
        case .signTypedMessage(let data):
            return data.hexEncoded
        }
    }
}


public struct AddCustomChainCommand: Decodable {
    // Single case enum just useful for validation
    public enum Method: String, Decodable {
        case walletAddEthereumChain

        public init?(string: String) {
            if let str = Method(rawValue: string) {
                self = str
            } else {
                return nil
            }
        }
    }

    public let name: Method
    public let id: Int
    public let object: WalletAddEthereumChainObject
}

public struct SwitchChainCommand: Decodable {
    // Single case enum just useful for validation
    public enum Method: String, Decodable {
        case walletSwitchEthereumChain

        public init?(string: String) {
            if let strs = Method(rawValue: string) {
                self = strs
                self = strs
            } else {
                return nil
            }
        }
    }

    public let name: Method
    public let id: Int
//    public let object: WalletSwitchEthereumChainObject
}

public enum DappOrWalletCommand {
    case eth(String)
    case walletAddEthereumChain(AddCustomChainCommand)
    case walletSwitchEthereumChain(SwitchChainCommand)

    public var id: Int {
        switch self {
        case .eth(_):
            return 1
        case .walletAddEthereumChain(_):
            return 1
        case .walletSwitchEthereumChain(_):
            return 1
        }
    }
}

public struct WalletAddEthereumChainObject: Decodable, CustomStringConvertible {
    public struct NativeCurrency: Decodable, CustomStringConvertible {
        public let name: String
        public let symbol: String
        public let decimals: Int

        public var description: String {
            return "{name: \(name), symbol: \(symbol), decimals:\(decimals) }"
        }
        public init(name: String, symbol: String, decimals: Int) {
            self.name = name
            self.symbol = symbol
            self.decimals = decimals
        }
    }

    public struct ExplorerUrl: Decodable {
        let name: String
        public let url: String

        enum CodingKeys: CodingKey {
            case name
            case url
        }

        public init(name: String, url: String) {
            self.url = url
            self.name = name
        }

        public init(from decoder: Decoder) throws {
            do {
                let container = try decoder.singleValueContainer()
                url = try container.decode(String.self)
                name = String()
            } catch {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                name = try container.decode(String.self, forKey: .name)
                url = try container.decode(String.self, forKey: .url)
            }
        }
    }

    public let nativeCurrency: NativeCurrency?
    public var blockExplorerUrls: [ExplorerUrl]?
    public let chainName: String?
    public let chainId: String
    public let rpcUrls: [String]?

//    public var server: RPCServer? {
//        return Int(chainId0xString: chainId).flatMap { RPCServer(chainIdOptional: $0) }
//    }

    public init(nativeCurrency: NativeCurrency?, blockExplorerUrls: [ExplorerUrl]?, chainName: String?, chainId: String, rpcUrls: [String]?) {
        self.nativeCurrency = nativeCurrency
        self.blockExplorerUrls = blockExplorerUrls
        self.chainName = chainName
        self.chainId = chainId
        self.rpcUrls = rpcUrls
    }

    public var description: String {
        return "{ blockExplorerUrls: \(String(describing: blockExplorerUrls)), chainName: \(String(describing: chainName)), chainId: \(String(describing: chainId)), rpcUrls: \(String(describing: rpcUrls)), nativeCurrency: \(String(describing: nativeCurrency)) }"
    }
}


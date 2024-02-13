//
//  ChainData.swift
//  PlutoPe
//
//  Created by Admin on 02/06/23.
//

import Foundation
// import WalletCore
import Web3
import CGWallet
import UIKit
enum NetworkType {
    case mainnet
    case testnet
}

public enum CoinType: UInt32, CaseIterable {
    case aeternity = 457
    case aion = 425
    case binance = 714
    case bitcoin = 0
    case bitcoinCash = 145
    case bitcoinGold = 156
    case callisto = 820
    case cardano = 1815
    case cosmos = 118
    case dash = 5
    case decred = 42
    case digiByte = 20
    case dogecoin = 3
    case eos = 194
    case wax = 14001
    case ethereum = 60
    case ethereumClassic = 61
    case fio = 235
    case goChain = 6060
    case groestlcoin = 17
    case icon = 74
    case ioTeX = 304
    case kava = 459
    case kin = 2017
    case litecoin = 2
    case monacoin = 22
    case nebulas = 2718
    case nuls = 8964
    case nano = 165
    case near = 397
    case nimiq = 242
    case ontology = 1024
    case poanetwork = 178
    case qtum = 2301
    case xrp = 144
    case solana = 501
    case stellar = 148
    case tezos = 1729
    case theta = 500
    case thunderCore = 1001
    case neo = 888
    case tomoChain = 889
    case tron = 195
    case veChain = 818
    case viacoin = 14
    case wanchain = 5718350
    case zcash = 133
    case firo = 136
    case zilliqa = 313
    case zelcash = 19167
    case ravencoin = 175
    case waves = 5741564
    case terra = 330
    case terraV2 = 10000330
    case harmony = 1023
    case algorand = 283
    case kusama = 434
    case polkadot = 354
    case filecoin = 461
    case multiversX = 508
    case bandChain = 494
    case smartChainLegacy = 10000714
    case smartChain = 20000714
    case oasis = 474
    case polygon = 966
    case thorchain = 931
    case bluzelle = 483
    case optimism = 10000070
    case zksync = 10000324
    case arbitrum = 10042221
    case ecochain = 10000553
    case avalancheCChain = 10009000
    case xdai = 10000100
    case fantom = 10000250
    case cryptoOrg = 394
    case celo = 52752
    case ronin = 10002020
    case osmosis = 10000118
    case ecash = 899
    case cronosChain = 10000025
    case smartBitcoinCash = 10000145
    case kuCoinCommunityChain = 10000321
    case boba = 10000288
    case metis = 1001088
    case aurora = 1323161554
    case evmos = 10009001
    case nativeEvmos = 20009001
    case moonriver = 10001285
    case moonbeam = 10001284
    case kavaEvm = 10002222
    case klaytn = 10008217
    case meter = 18000
    case okxchain = 996
    case nervos = 309
    case everscale = 396
    case aptos = 637
    case hedera = 3030
    case secret = 529
    case nativeInjective = 10000060
    case agoric = 564
    case ton = 607
    case sui = 784
    case stargaze = 20000118
    case polygonzkEVM = 10001101
    case juno = 30000118
    case stride = 40000118
    case axelar = 50000118
    case crescent = 60000118
    case kujira = 70000118
    case ioTeXEVM = 10004689
    case nativeCanto = 10007700
    case comdex = 80000118
    case neutron = 90000118
    case sommelier = 11000118
    case fetchAI = 12000118
    case mars = 13000118
    case umee = 14000118
    case coreum = 10000990
    case quasar = 15000118
    case persistence = 16000118
    case akash = 17000118
    case noble = 18000118
    case scroll = 534353
    case rootstock = 137
}
protocol ChainDetails {
    var coinType: CoinType { get  }
    var walletAddress: String? { get  }
    var rpcURL: String { get  }
//    var tokens: [Token] { get  }
    var icon: String { get  }
    var decimals: Int { get  }
    var name: String { get  }
    var symbol: String { get  }
    var tokenStandard: String { get  }
    var chainIdHex: String { get  }
    var privateKey: String? { get  }
    var buyProviders: [BuyCrypto.Domain] { get  }
    var sellProviders: [SellCrypto.Domain] { get  }
    var swapProviders: [SwapCrypto.SwapCryptoDomain] { get  }
    var chainDefaultImage: UIImage { get }
}

enum Chain: ChainDetails {
    
    case ethereum
    case binanceSmartChain
    case polygon
    case oKC
    case bitcoin
    var name: String {
        switch self {
        case .ethereum:
            return "Ethereum"
        case .binanceSmartChain:
            return "BNB Smart Chain"
        case .polygon:
            return "Polygon" 
        case .oKC:
            return "OKschain"
        case .bitcoin:
            return "Bitcoin"
        }
        
    }
    
    var chainName: String {
        switch self {
        case .ethereum:
            return DataStore.networkEnv == .mainnet ? "eth" : "goerli"
        case .binanceSmartChain:
            return DataStore.networkEnv == .mainnet ? "bsc" : "bsctestnet"
        case .polygon:
            return DataStore.networkEnv == .mainnet ? "polygon" : "mumbai"
        case .oKC:
            return "okc"
        case .bitcoin:
            return "btc"
        }
        
    }
    
    var symbol: String {
        switch self {
        case .ethereum:
            return "ETH"
        case .binanceSmartChain:
            return "BNB"
        case .polygon:
            return "MATIC"
        case .oKC:
            return "OKT"
        case .bitcoin:
            return "btc"
        }
    }
    
    var tokenStandard: String {
        switch self {
        case .ethereum:
            return "ERC20"
        case .binanceSmartChain:
            return "BEP20"
        case .polygon:
            return "POLYGON"
        case .oKC:
            return "KIP20"
        case .bitcoin:
            return "BTC"
        }
    }
    
    var chainIdHex: String {
        switch self {
        case .ethereum:
            return DataStore.networkEnv == .mainnet ? "0x1": "0x5"
        case .binanceSmartChain:
            return DataStore.networkEnv == .mainnet ? "0x38": "0x61"
        case .polygon:
            return DataStore.networkEnv == .mainnet ? "0x89": "0x13881"
        case .oKC:
            return DataStore.networkEnv == .mainnet ? "0x42": "0x41"
        case .bitcoin:
            return "0xc6"
        }
    }
    
    var chainId: String {
        switch self {
        case .ethereum:
            return DataStore.networkEnv == .mainnet ? "1": "5"
        case .binanceSmartChain:
            return DataStore.networkEnv == .mainnet ? "56": "97"
        case .polygon:
            return DataStore.networkEnv == .mainnet ? "137": "80001"
        case .oKC:
            return DataStore.networkEnv == .mainnet ? "66": "65"
        case .bitcoin:
            return "198"
        }
    }
    
    var coinType: CoinType {
        switch self {
        case .ethereum:
            return .ethereum
        case .binanceSmartChain:
            return .smartChain
        case .polygon:
            return .polygon
        case .oKC:
            return .okxchain
        case .bitcoin:
            return .bitcoin
        }
    }
    
    var icon: String {
        switch self {
        case .ethereum:
            return "https://cryptologos.cc/logos/ethereum-eth-logo.png?v=025"
        case .binanceSmartChain:
            return "https://assets.coingecko.com/coins/images/825/small/binance-coin-logo.png?1547034615"
        case .polygon:
            return "https://i.imgur.com/uIExoAr.png"
        case .oKC:
            return "https://stakingcrypto.info/static/assets/coins/okt-logo.png"
        case .bitcoin:
            return "https://assets.coingecko.com/coins/images/1/small/bitcoin.png?1696501400"
        }
    }
    
    var walletAddress: String? {
        return WalletData.shared.getPublicWalletAddress(coinType: coinType)
       // return WalletData.shared.wallet?.getAddressForCoin(coin: coinType)
    }
    
    var privateKey: String? {
     
        return WalletData.shared.getPrivateKeyData(coinType: coinType)
       // return WalletData.shared.wallet?.getKeyForCoin(coin: coinType).data.hexString
    }
    
    var rpcURL: String {
        
        switch self {
        case .ethereum:
           return DataStore.networkEnv == .mainnet ? "https://ethereum.publicnode.com": "https://goerli.blockpi.network/v1/rpc/public"    // old mainNet rpc url https://eth.llamarpc.com
        case .binanceSmartChain:
            return DataStore.networkEnv == .mainnet ? "https://bsc-mainnet.nodereal.io/v1/64a9df0874fb4a93b9d0a3849de012d3": "https://bsc-testnet.publicnode.com"
        case .polygon:
            return DataStore.networkEnv == .mainnet ? "https://polygon-rpc.com/": "https://polygon-mumbai.infura.io/v3/4458cf4d1689497b9a38b1d6bbf05e78"
        case .oKC:
            return DataStore.networkEnv == .mainnet ? "https://exchainrpc.okex.org": "https://exchaintestrpc.okex.org"
        case .bitcoin:
            return DataStore.networkEnv == .mainnet ? "https://rpc.bitchain.biz" : ""
        }
        
    }
    
    var defaultGasLimit: BigUInt {
        
        switch self {
        case .ethereum:
            return 90000
        case .binanceSmartChain:
            return 21000
        case .polygon:
            return 96000
        case .oKC:
            return 21000
        case .bitcoin:
            return 21000
        }
        
    }
    
    func getCoinType() -> CoinType {
            return coinType
        }
    
//    func getCoinType() {
//            // You can access ethereumChain here or in any other instance method
//            let coinType = coinType
//            print("Coin Type: \(coinType)")
//        }
//    var tokens: [Token] {
//        var fileName: String {
//            switch self {
//            case .ethereum:
//                return "eth_tokenlist"
//            case .binanceSmartChain:
//                return "bsc_tokenlist"
//            case .oKC:
//                return "okx_tokenlist"
//            case .polygon:
//                return "polygon_tokenlist"
//            }
//        }
//        return loadJson(filename: fileName)
//    }
    
    var decimals: Int {
        return 18
    }
    
    var chainDefaultImage: UIImage {
        switch self {
        case .ethereum:
            return UIImage.icEth
        case .polygon:
            return UIImage.icPolygon
        case .binanceSmartChain:
            return UIImage.icBnb
        case .oKC:
            return UIImage.icOkc
        case .bitcoin:
            return UIImage.icBTC
        }
    }
    
    var buyProviders: [BuyCrypto.Domain] {
        switch self {
            
        case .ethereum, .binanceSmartChain, .polygon:
            return [
                .meld(),
                .onRamp(),
                .onMeta(),
                .changeNow(),
                .unlimit()
            ]
        case .oKC:
            return [.meld()]
        case .bitcoin:
            return [
                .meld(),
                .onRamp(),
                .onMeta(),
                .changeNow(),
                .unlimit()
            ]
        }
    }
    
    var swapProviders: [SwapCrypto.SwapCryptoDomain] {
       
            return [
               
                .changeNow(),
                .okx(),
                .rango()
            ]
     
    }
    var sellProviders: [SellCrypto.Domain] {
        switch self {
            
        case .ethereum, .binanceSmartChain, .polygon:
            return [
                .onRamp(),
                .onMeta(),
                .changeNow()
            ]
        case .oKC:
            return []
        case .bitcoin:
            return [
                .changeNow()
            ]
        }
    }
    
}

//
//  WalletDashboardModel.swift
//  Plutope
//
//  Created by Priyanka Poojara on 13/06/23.
//
import UIKit

// MARK: - NFT data
struct NFTData: Codable {
    let total: String?
    let cursor: String?
    let page, pageSize: Int?
    let result: [NFTList]?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case total
        case cursor
        case page
        case pageSize = "page_size"
        case result, status
    }
}

// MARK: - NFT list
struct NFTList: Codable {
    let tokenAddress, tokenID: String?
    let ownerOf: String?
    let blockNumber, blockNumberMinted, tokenHash, amount: String?
    let contractType: String?
    let name: String?
    let symbol: String?
    let tokenURI: String?
    let metadata, lastTokenURISync, lastMetadataSync: String?
    let minterAddress: String?
    let possibleSpam: Bool?
 
    enum CodingKeys: String, CodingKey {
        case tokenAddress = "token_address"
        case tokenID = "token_id"
        case ownerOf = "owner_of"
        case blockNumber = "block_number"
        case blockNumberMinted = "block_number_minted"
        case tokenHash = "token_hash"
        case amount
        case contractType = "contract_type"
        case name, symbol
        case tokenURI = "token_uri"
        case metadata
        case lastTokenURISync = "last_token_uri_sync"
        case lastMetadataSync = "last_metadata_sync"
        case minterAddress = "minter_address"
        case possibleSpam = "possible_spam"
    }
}

enum ContractType: String, Codable {
    case erc721 = "ERC721"
}

enum OwnerOf: String, Codable {
    case the0X679C1F5170B5Cc6Bb943C33D4F59B44F9A8E306E = "0x679c1f5170b5cc6bb943c33d4f59b44f9a8e306e"
}

enum Name: String, Codable {
    case cryptoBeetles = "CryptoBeetles"
    case priyanka = "Priyanka"
}

enum Symbol: String, Codable {
    case cbeet = "CBEET"
    case pry = "PRY"
}
struct DashboardTrnsactions {
    var image :UIImage
    var name : String
}
// MARK: - NFTDataNewElement
struct NFTDataNewElement: Codable {
    let chain: String?
    let contractType: String?
    let tokenAddress, tokenID: String?
    let tokenURI: String?
    let metadata: MetadataNew?
    let name, symbol: String?
    let amount: Int?
    let blockNumber: String?
    let ownerOf: String?
    let tokenHash, lastMetadataSync, lastTokenURISync: String?
    let possibleSpam: Bool?
    let blockNumberMinted: String?

    enum CodingKeys: String, CodingKey {
        case chain, contractType, tokenAddress
        case tokenID = "tokenId"
        case tokenURI = "tokenUri"
        case metadata, name, symbol, amount, blockNumber, ownerOf, tokenHash, lastMetadataSync
        case lastTokenURISync = "lastTokenUriSync"
        case possibleSpam, blockNumberMinted
    }
}



// MARK: - Metadata
struct MetadataNew: Codable {
    let name, symbol, description: String?
    let image: String?
    let externalURL: String?
    let attributes: [Attribute]?
    let level: String?
    let price: Int?
//    let creators: [JSONAny]?
    let collection: Collection?
    let sellerFeeBasisPoints: Int?

    enum CodingKeys: String, CodingKey {
        case name, symbol, description, image
        case externalURL = "external_url"
        case attributes, level, price, collection
        case sellerFeeBasisPoints = "seller_fee_basis_points"
        //creators
    }
}

// MARK: - Attribute
struct Attribute: Codable {
    let traitType: String?
    let value: String?
    let key: Key?
    let energy, durability: Int?
    let level: String?

    enum CodingKeys: String, CodingKey {
        case traitType = "trait_type"
        case value, key, energy, durability, level
    }
}

enum Key: String, Codable {
    case website = "Website :"
}

// MARK: - Collection
struct Collection: Codable {
    let name, family: String?
}



typealias NFTDataNew = [NFTDataNewElement]

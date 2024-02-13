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

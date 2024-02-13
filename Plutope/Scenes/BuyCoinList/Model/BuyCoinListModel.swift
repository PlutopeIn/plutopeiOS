//
//  BuyCoinListModel.swift
//  Plutope
//
//  Created by Priyanka Poojara on 08/06/23.
//
import UIKit
struct BuyCoinListData {
    let data: [PurchasedCoinData]
}
struct PurchasedCoinData {
    let image: UIImage
    let coinName: String
    let symbol: String?
    let coinPrice: String?
    
    let coinQuantity: String?
    let coinAmount: String?
}

//
//  UnitConverter.swift
//  PlutoPe
//
//  Created by Admin on 02/06/23.
//
import Foundation
import BigInt
import Web3
class UnitConverter {
    
    /// convertToWei
    static func convertToWei(_ usdtAmount: Double,_ decimal: Double) -> BigInt {
        let weiAmount = BigInt(usdtAmount * pow(10, decimal))
        return weiAmount
    } 
    /// cconvert weiToGwei
    static func weiToGwei(_ wei: BigInt) -> BigInt {
        let gweiFactor = BigInt(10).power(9)
        return wei / gweiFactor
    }
    /// cconvert gweiToWei
    static func gweiToWei(_ gwei: BigInt) -> BigInt {
        let gweiFactor = BigInt(10).power(9)
        return gwei * gweiFactor
    }
    /// etherToWei
    static func etherToWei(_ ether: Double) -> BigInt {
        let weiPerEther = BigInt(1_000_000_000_000_000_000)
        let weiValue = BigInt(ether * Double(weiPerEther))
        return weiValue
    }
    
    /// convertWeiToEther
    static func convertWeiToEther(_ wei: String, _ decimal: Int) -> String? {
        let ether = (Decimal(string: wei) ?? 0) / pow(10, decimal)
        return "\(ether)"
    }
    
    static func formatPrice(_ price: String?, withCurrency currency: String) -> String {
        let formattedPrice = String(format: "%.2f", Double(price ?? "") ?? 0.0)
        return "\(currency)\(formattedPrice)"
    }
    
    static func formatQuantity(_ quantity: Double, symbol: String?) -> String {
        let balanceString = quantity
        let balance = Double(balanceString)
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        
        if let formattedBalance = formatter.string(from: NSNumber(value: balance)) {
            return formattedBalance + " \(symbol ?? "")"
        } else {
            return ""
        }
        
    }
    
    static func formatAmount(_ amount: Double, withCurrency currency: String) -> String {
        let roundedValue = String(format: "%.2f", amount)
        return amount > 0 ? "\(currency)\(roundedValue)" : ""
    }
    
    static func formatPriceChangeImpact(_ impact: Double) -> String {
        return impact >= 0 ? "+\(impact)%" : "\(impact)%"
    }
    
    static  func hexStringToBigInteger(hex: String) -> BigInt? {
        // Remove "0x" prefix if present
        var hexString = hex
        if hexString.hasPrefix("0x") {
            hexString = String(hexString.dropFirst(2))
        }

        // Convert hex string to BigInt
        return BigInt(hexString, radix: 16)
    }
    
}

public class ReaderWriterLock {
    private let queue = DispatchQueue(label: "com.domain.app.plutope", attributes: .concurrent)
    
    public func concurrentlyRead<T>(_ block: (() throws -> T)) rethrows -> T {
        return try queue.sync {
            try block()
        } 
    } 
    
    public func exclusivelyWrite(_ block: @escaping (() -> Void)) {
        queue.async(flags: .barrier) {
            block()
        } 
    } 
} 

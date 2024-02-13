//
//  ValidationExtension.swift
//  Plutope
//
//  Created by Mitali Desai on 19/06/23.
//
import Foundation
import UIKit
extension UITextField {
    func validatePassword() -> Bool {
        guard let text = self.text else {
            return false
        }
        
        let passwordRegex = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#^!%*?&])[A-Za-z\d@$#!%*?&]{8,}$"#
        do {
            let regex = try NSRegularExpression(pattern: passwordRegex)
            let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return !matches.isEmpty
        } catch {
            return false
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String {
//    func validateContractAddress() -> Bool {
//        let addressRegex = "^0x[0-9a-fA-F]{40}$"
//        let addressPredicate = NSPredicate(format: "SELF MATCHES %@", addressRegex)
//        return addressPredicate.evaluate(with: self)
//    }
    func validateContractAddress() -> Bool {
        let ethereumPattern = "^0x[0-9a-fA-F]{40}$"
        let customBCPattern = "^(bc1|[13])[a-zA-HJ-NP-Z0-9]{25,39}$"

        let ethereumPredicate = NSPredicate(format: "SELF MATCHES %@", ethereumPattern)
        let customBCPredicate = NSPredicate(format: "SELF MATCHES %@", customBCPattern)

        return ethereumPredicate.evaluate(with: self) || customBCPredicate.evaluate(with: self)
    }
    func validateBTCAddress() -> Bool {
        let customBCPattern = "^(bc1|[13])[a-zA-HJ-NP-Z0-9]{25,39}$"
        let customBCPredicate = NSPredicate(format: "SELF MATCHES %@", customBCPattern)

        return customBCPredicate.evaluate(with: self)
    }
}

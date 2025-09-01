//
//  AppFont.swift
//  Plutope
//
//  Created by Priyanka Poojara on 06/06/23.
//
import Foundation
import UIKit
// MARK: Protocol to Change font size and font style
protocol AppFontProtocol {
    var value: UIFont { get }
}
// MARK: Enum for application font and size
enum AppFont: AppFontProtocol {
    
    var value: UIFont {
        switch self {
       
        case .violetRegular(let size):
            return UIFont(name: "violet_sans", size: size) ?? UIFont.systemFont(ofSize: size)

        case .regular(let size):
            return UIFont(name: "inter", size: size) ?? UIFont.systemFont(ofSize: size)
            
     
        }
    }
    case violetRegular(_ size: CGFloat)
    case regular(_ size: CGFloat)
  
}

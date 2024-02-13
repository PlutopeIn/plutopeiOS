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
        case .bold(let size):
            return UIFont(name: "SFPro_bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
            
        case .light(let size):
            return UIFont(name: "SFPro_light", size: size) ?? UIFont.boldSystemFont(ofSize: size)
            
        case .medium(let size):
            return UIFont(name: "SFPro_medium", size: size) ?? UIFont.systemFont(ofSize: size)
        case .regular(let size):
            return UIFont(name: "SFPro_regular", size: size) ?? UIFont.systemFont(ofSize: size)
            
        case .semiBold(let size):
            return UIFont(name: "SFPro_semibold", size: size) ?? UIFont.systemFont(ofSize: size)
            
        }
    }
    case bold(_ size: CGFloat)
    case light(_ size: CGFloat)
    case medium(_ size: CGFloat)
    case regular(_ size: CGFloat)
    case semiBold(_ size: CGFloat)
}

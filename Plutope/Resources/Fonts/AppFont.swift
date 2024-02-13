//
//  AppFont.swift
//  TestEZ
//
//  Created by Priyanka Poojara on 12/04/23.
//

import UIKit

// MARK: Protocol to Chnage font size and font style

protocol AppFontProtocol {
    var value : UIFont { get }
}

// MARK: Enum for application font and size
enum AppFont : AppFontProtocol {
    
    var value: UIFont {
        
        switch self {
        case .bold(let size):
            return UIFont(name: "Quicksand-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
            
        case .light(let size):
            return UIFont(name: "Quicksand-Light", size: size) ?? UIFont.boldSystemFont(ofSize: size)
            
        case .medium(let size):
            return UIFont(name: "Quicksand-Medium", size: size) ?? UIFont.systemFont(ofSize: size)

        case .regular(let size):
            return UIFont(name: "Quicksand-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
            
        case .semiBold(let size)
            return UIFont(name: "Quicksand-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size)
            
        }
    }

    case bold(_ size : CGFloat)
    case light(_ size : CGFloat)
    case regular(_ size : CGFloat)
    case medium(_ size : CGFloat)
    case semiBold(_ size: CGFloat)
}

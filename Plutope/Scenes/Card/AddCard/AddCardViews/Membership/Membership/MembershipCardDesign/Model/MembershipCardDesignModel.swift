//
//  MembershipCardDesignModel.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/08/23.
//

import Foundation
protocol MembershipCard {
    var title: String { get }
}

enum MembershipCardData: MembershipCard {
    
    case standardMail
    case professionalMail
    case businessMail
   
    var title: String {
        switch self {
        case .standardMail:
            return StringConstants.StandardMail
        case .professionalMail:
            return StringConstants.StandardMail
        case .businessMail:
            return StringConstants.StandardMail
        }
    }
}
    

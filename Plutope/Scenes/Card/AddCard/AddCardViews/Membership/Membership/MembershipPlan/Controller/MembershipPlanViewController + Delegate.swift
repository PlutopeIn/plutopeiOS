//
//  MembershipPlanViewController + Delegate.swift
//  Plutope
//
//  Created by Trupti Mistry on 09/08/23.
//

import Foundation
import UIKit

extension MembershipPlanViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let membershipTypes = [MembershipData.basic, MembershipData.professional, MembershipData.business, MembershipData.platinumElite]
        
        guard indexPath.row < membershipTypes.count else {
            return
        }
        
        let selectedMembership = membershipTypes[indexPath.row]
        lblType.text = selectedMembership.title
        lblPrice.text = selectedMembership.price
        selectedPlanPrice = selectedMembership.price
        ivBackground.image = indexPath.row % 2 == 0 ? UIImage.ivMembership1 : UIImage.ivMembership2
        btnSelectCard.setTitle(selectedMembership.btnTitle, for: .normal)
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? PhraseViewCell {
            let topGradientColors: [UIColor] = [.cC693FE, .c48C6EF, .cC693FE, .c48C6EF]
            let bottomGradientColors: [UIColor] = [.c9654D9, .c6F86D6, .c9654D9, .c6F86D6]
            let gradientIndex = indexPath.row % 4
            selectedCell.bgView.topGradientColor = topGradientColors[gradientIndex]
            selectedCell.bgView.bottomGradientColor = bottomGradientColors[gradientIndex]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let deselectedCell = collectionView.cellForItem(at: indexPath)  as? PhraseViewCell {
            
            deselectedCell.bgView.topGradientColor = UIColor.c202148
            deselectedCell.bgView.bottomGradientColor = UIColor.c202148
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.clvMembershipType.frame.width / 4, height: 45)
    }
}

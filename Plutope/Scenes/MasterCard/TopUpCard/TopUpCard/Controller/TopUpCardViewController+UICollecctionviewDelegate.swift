//
//  TopUpCardViewController+UICollecctionviewDelegate.swift
//  Plutope
//
//  Created by Trupti Mistry on 28/05/24.
//

import Foundation
import UIKit
// MARK: - UICollectionView Delegate

extension TopUpCardViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        let cell = clvPrice.cellForItem(at: indexPath) as? WalletPriceClvCell
        let data = priceDataValueArr[indexPath.row]
        let numberString = data.description.filter { "0123456789".contains($0) }
        print(numberString)
        txtGet.text = numberString
        isFromCollectionView = true
        textFieldDidChangeSelection(txtGet)
    }

}
// MARK: - UICollectionView DelegateFlowLayout
extension TopUpCardViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (Int(clvPrice.frame.width) / priceDataValueArr.count) , height: 55)
    }
}

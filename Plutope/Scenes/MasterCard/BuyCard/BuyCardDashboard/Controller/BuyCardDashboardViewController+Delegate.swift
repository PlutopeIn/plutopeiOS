//
//  BuyCardDashboardViewController+Delegate.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/06/24.
//

import Foundation
import UIKit
//// MARK: - UICollectionView Delegate
//
//extension BuyCardDashboardViewController : UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = clvPrice.cellForItem(at: indexPath) as? WalletPricelblYouGetClvCell
//        let data = priceDataValueArr[indexPath.row]
//        let numberString = data.description.filter { "0123456789".contains($0) }
//        print(numberString)
//        txtPay.text = numberString
//        textFieldDidChangeSelection(txtPay)
//    }
//}
//// MARK: - UICollectionView DelegateFlowLayout
//extension BuyCardDashboardViewController : UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            return CGSize(width: (Int(clvPrice.frame.width) / priceDataValueArr.count) , height: 55)
//
//    }
//}

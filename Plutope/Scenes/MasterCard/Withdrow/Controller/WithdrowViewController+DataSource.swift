//
//  WithdrowViewController+DataSource.swift
//  Plutope
//
//  Created by sonoma on 02/07/24.
//

import Foundation
import UIKit

//extension WithdrowViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return collectionListArray.count
////        return 5
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//       
//            let cell = self.clvPrice.dequeueReusableCell(withReuseIdentifier: "WalletPriceClvCell", for: indexPath) as? WalletPriceClvCell
//           
//        cell?.lblData.text = collectionListArray[indexPath.row]
//            return cell!
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//      
//            let label = UILabel(frame: CGRect.zero)
//            label.text = collectionListArray[indexPath.row] as? String ?? ""
//            label.sizeToFit()
//            
//            return CGSize(width: label.frame.width + 40, height: 45)
//    }
//}

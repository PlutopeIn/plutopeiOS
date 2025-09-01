//
//  SwapViewController+CLVDelegateDataSourse.swift
//  Plutope
//
//  Created by Trupti Mistry on 30/07/24.
//

import Foundation

import UIKit
// MARK: - UICollectionView DataSource
extension SwapViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quickSwapPairList.count
       // return priceDataValueArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.clvQuickSwap.dequeueReusableCell(indexPath: indexPath) as QuickSwapViewCell
        let pair = quickSwapPairList[indexPath.item]
                let token1 = pair.0
                let token2 = pair.1
                
        cell.lblSwapCoins.text = "\(token1?.symbol ?? "") - \(token2?.symbol ?? "")"
//        cell.ivCoin.image = UIImage(named: token1?.logoURI ?? "")
        cell.ivCoin.sd_setImage(with: URL(string: token1?.logoURI ?? ""))
        cell.lblSwapCoins.font = AppFont.violetRegular(13.78).value
        cell.mainView.RoundMe(Radius: 21.5)
        // Alternate the background color
                if indexPath.row % 2 == 0 {
                    cell.mainView.backgroundColor = UIColor.c2B5AF31F
                } else {
                    cell.mainView.backgroundColor = UIColor.c38FF8E26 
                }
        return cell
    }
}
// MARK: - UICollectionView Delegate

extension SwapViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
//        let cell = clvQuickSwap.cellForItem(at: indexPath) as? QuickSwapViewCell
        let pair = quickSwapPairList[indexPath.item]
                let token1 = pair.0
                let token2 = pair.1
        
        self.payCoinDetail = token1
        self.getCoinDetail = token2
        viewProvider.isHidden = true
        self.lblFindProvider.text = ""
        lblChooseProvider.isHidden = true
        setCoinDetail()
    }

}
// MARK: - UICollectionView DelegateFlowLayout
extension SwapViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 20)/2.5, height: 55)
    }
}

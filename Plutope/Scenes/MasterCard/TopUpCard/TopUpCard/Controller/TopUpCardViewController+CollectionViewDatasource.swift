//
//  TopUpCardViewController+CollectionViewDatasource.swift
//  Plutope
//
//  Created by Trupti Mistry on 27/05/24.
//

import UIKit
// MARK: - UICollectionView DataSource
extension TopUpCardViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return priceDataValueArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.clvPrice.dequeueReusableCell(indexPath: indexPath) as WalletPriceClvCell
        cell.lblData.text = priceDataValueArr[indexPath.row].description
        cell.isSelected = true
        return cell
    }
}

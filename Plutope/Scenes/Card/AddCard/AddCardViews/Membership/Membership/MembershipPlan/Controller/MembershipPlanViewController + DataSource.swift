//
//  MembershipPlanViewController + DataSource.swift
//  Plutope
//
//  Created by Trupti Mistry on 09/08/23.
//

import Foundation
import UIKit

extension MembershipPlanViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMembersipTypeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = clvMembershipType.dequeueReusableCell(indexPath: indexPath) as PhraseViewCell
        
        let data = arrMembersipTypeData[indexPath.row]
        cell.bgView.layer.cornerRadius = 18
        cell.lblPhrase.textAlignment = .center
        cell.viewNumber.isHidden = true
        cell.lblPhrase.text = data.title
        cell.bgView.topGradientColor = UIColor.c202148
        cell.bgView.bottomGradientColor = UIColor.c202148
        cell.lblPhrase.font = AppFont.semiBold(11).value
        
        return cell
    }
}

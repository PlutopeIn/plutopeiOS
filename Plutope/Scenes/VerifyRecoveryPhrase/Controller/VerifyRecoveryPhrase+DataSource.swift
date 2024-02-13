//
//  VerifyRecoveryPhrase+DataSource.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
extension VerifyRecoveryPhraseViewController: UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case clvVerifyPhrase:
            return arrSecretPhrase.count
            
        case clvGuessCorrectPhrase:
            return arrGuessSecretPhrase.count
        
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        
        case clvVerifyPhrase:
            
            let cell = clvVerifyPhrase.dequeueReusableCell(indexPath: indexPath) as PhraseViewCell
            let data = arrSecretPhrase[indexPath.row]
            
            cell.lblNumber.text = "\(indexPath.row + 1)."
            cell.lblPhrase.text = data.phrase
            return cell
        
        case clvGuessCorrectPhrase:
            
            let cell = clvGuessCorrectPhrase.dequeueReusableCell(indexPath: indexPath) as PhraseViewCell
            let data = arrGuessSecretPhrase[indexPath.row]
            cell.bgView.backgroundColor = UIColor.c121C3D
            cell.lblPhrase.textAlignment = .center
            cell.viewNumber.isHidden = true
            cell.lblPhrase.text = data.phrase
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
}

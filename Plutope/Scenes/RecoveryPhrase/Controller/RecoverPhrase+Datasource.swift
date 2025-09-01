//
//  RecoverPhrase+Delegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import UIKit
extension RecoveryPhraseViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSecretPhrase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clvPhrase.dequeueReusableCell(indexPath: indexPath) as PhraseViewCell
        
        cell.lblNumber.text = "\(indexPath.row + 1)."
        cell.lblPhrase.text = arrSecretPhrase[indexPath.row].phrase

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 50)/2, height: 47)
    }
}

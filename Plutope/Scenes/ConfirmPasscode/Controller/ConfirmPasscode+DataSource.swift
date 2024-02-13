//
//  ConfirmPasscode+DataSource.swift
//  Plutope
//
//  Created by Priyanka Poojara on 06/06/23.
//
import UIKit
extension ConfirmPasscodeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clvKeyboard.dequeueReusableCell(indexPath: indexPath) as KeyboardViewCell
        let number = indexPath.row + 1
        
        switch number {
        case 10:
            //cell.txtNumber.text = "Cancel"
            cell.txtNumber.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: "")
            cell.txtNumber.font = AppFont.medium(15).value
        case 11:
            cell.txtNumber.text = "0"
        case 12:
            cell.txtNumber.isHidden = true
            cell.viewCancel.isHidden = false
        default:
            cell.txtNumber.text = "\(number)"
        }
        
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (clvKeyboard.frame.width) / 3, height: clvKeyboard.frame.height / 4)
        
    }
    
}

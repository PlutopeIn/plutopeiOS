//
//  BuyCoin+DataSource.swift
//  Plutope
//
//  Created by Priyanka Poojara on 12/06/23.
//
import UIKit
extension BuyCoinViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clvKeyboard.dequeueReusableCell(indexPath: indexPath) as KeyboardViewCell
        let number = indexPath.row + 1
        
        cell.txtNumber.font = AppFont.violetRegular(34).value
        switch number {
        case 1:
           // cell.topLable.isHidden = true
            cell.leftLable.isHidden = true
            cell.txtNumber.text = "\(number)"
        case 2:
         //   cell.topLable.isHidden = true
            cell.txtNumber.text = "\(number)"
        case 3:
        //    cell.topLable.isHidden = true
            cell.rightLable.isHidden = true
            cell.txtNumber.text = "\(number)"
        case 4:
            cell.leftLable.isHidden = true
            cell.txtNumber.text = "\(number)"
        case 5:
            // cell.topLable.isHidden = true
            cell.txtNumber.text = "\(number)"
        case 6:
            cell.rightLable.isHidden = true
            cell.txtNumber.text = "\(number)"
        case 7:
            cell.leftLable.isHidden = true
            cell.txtNumber.text = "\(number)"
            
        case 8:
           // cell.topLable.isHidden = true
            cell.txtNumber.text = "\(number)"
            
        case 9:
            cell.rightLable.isHidden = true
            cell.txtNumber.text = "\(number)"
           
        case 10:
         //   cell.bottomLable.isHidden = true
            cell.leftLable.isHidden = true
            //cell.txtNumber.text = "Cancel"
            cell.txtNumber.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: "")
            cell.txtNumber.font = AppFont.regular(15).value
        case 11:
          //  cell.bottomLable.isHidden = true
            cell.txtNumber.text = "0"
        case 12:
           // cell.bottomLable.isHidden = true
            cell.txtNumber.isHidden = true
            cell.viewCancel.isHidden = false
            cell.rightLable.isHidden = false
        default:
            break
//            cell.txtNumber.text = "\(number)"
        }
        
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (clvKeyboard.frame.width) / 3, height: clvKeyboard.frame.height / 4)
        
    }
    
}

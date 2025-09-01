
//
//  VerifyRecoveryPhrase+Delegate.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
extension VerifyRecoveryPhraseViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /// Did select cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        switch collectionView {
        case clvVerifyPhrase:
            movePhrase(from: &arrSecretPhrase, to: &arrGuessSecretPhrase, at: indexPath)
        case clvGuessCorrectPhrase:
            movePhrase(from: &arrGuessSecretPhrase, to: &arrSecretPhrase, at: indexPath)
        default:
            break
        }
        
        updatePhraseComparison()
        
        DispatchQueue.main.async {
            self.clvVerifyPhrase.reloadData()
            self.clvGuessCorrectPhrase.reloadData()
        }
    }
    
    /// Phrase swaping
    func movePhrase(from source: inout [SecretPhraseDataModel], to destination: inout [SecretPhraseDataModel], at indexPath: IndexPath) {
        let array = source[indexPath.row]
        
        if let index = source.firstIndex(where: { $0.phrase == array.phrase }) {
            destination.append(SecretPhraseDataModel(number: destination.count + 1, phrase: source[index].phrase))
            source.remove(at: index)
        }
    }
    
    /// Validation for correct incorrect phrase entry
    func updatePhraseComparison() {
        guard let arrMnemonic = mnemonic?.components(separatedBy: " ") else {
            return
        }
        
        for (idx, secretPhrase) in arrSecretPhrase.enumerated() {
            if arrMnemonic[idx] != secretPhrase.phrase {
                lblError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.invalidordertryagain, comment: "")
                lblError.textColor = UIColor.cD50000
            } else {
                lblError.text = ""
                lblError.textColor = UIColor.clear
            }
        }
        
        /// Done button validation
        let isPhraseMatched = arrMnemonic == arrSecretPhrase.map({ $0.phrase })
        if isPhraseMatched {
            lblError.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.welldone, comment: "")
            lblError.textColor = UIColor.c099817
        }
        btnDone.alpha = isPhraseMatched ? 1: 0.5
        btnDone.isEnabled = isPhraseMatched
    }
    
    /// Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case clvVerifyPhrase:
            return CGSize(width: (screenWidth - 50) / 2, height: 47)
            
        case clvGuessCorrectPhrase:
            return CGSize(width: (screenWidth - 32) / 4, height: 37)
            
        default:
            return CGSize.zero
        }
    }
    
}

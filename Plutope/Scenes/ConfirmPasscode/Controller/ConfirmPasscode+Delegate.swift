//
//  ConfirmPasscode+Delegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 06/06/23.
//
import UIKit
extension ConfirmPasscodeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        guard let cell = clvKeyboard.cellForItem(at: indexPath) as? KeyboardViewCell else { return }
        let number = indexPath.row + 1
        
        // animateCellSelection(cell)
        
        switch number {
            
        case 10:
            /// Cancel Action
            clearPasscode()
            
        case 12:
            /// Delete Action
            deletePasscodeDigit()
            
        default:
            /// Number pad action
            enterPasscodeDigit(cell.txtNumber.text)
            checkPasscodeValidity()
           
        }
        
    }
    
     func clearPasscode() {
        passcode = ""
        viewSecureText.forEach { view in
            view.imageTintColor = UIColor.c75769D
        }
        
    }
    private func deletePasscodeDigit() {
        for view in viewSecureText.reversed() where view.tintColor == UIColor.systemBlue {
            view.imageTintColor = UIColor.c75769D
            passcode?.removeLast()
            return
        }
        
    }
    
    private func enterPasscodeDigit(_ digit: String?) {
        let dynamicLightBlueColor = UIColor { traitCollection in
                  return traitCollection.userInterfaceStyle == .dark ? UIColor(red: 15/255, green: 47/255, blue: 128/255, alpha: 1.0) : UIColor(red: 43/255, green: 90/255, blue: 243/255, alpha: 1.0)
              }
        guard let digit = digit else { return }
        
        if passcode?.count ?? 0 < 6 {
            passcode = (passcode ?? "") + digit
        }
        
        let currentIndex = (passcode?.count ?? 0) - 1
        
        if currentIndex >= 0 && currentIndex < viewSecureText.count {
            viewSecureText[currentIndex].imageTintColor = UIColor.systemBlue
        }
       
    }
    private func checkPasscodeValidity() {
        guard let text = passcode, text.count == 6 else {
            return
        }
        
        if createPasscode == text {
            UserDefaults.standard.set(createPasscode, forKey: DefaultsKey.appPasscode)
            handleCorrectPasscode()
        } else {
            handleInvalidPasscode()
        }
    }
    
    private func handleInvalidPasscode() {
        if passcode?.count == 6 {
            viewSecureText.forEach { view in
                view.imageTintColor = UIColor.red
            }
            // Create a shake animation for horizontal movement
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 0.07
            animation.repeatCount = 3
            animation.autoreverses = true
            animation.byValue = 10.0 // Adjust the value for the desired shake distance
            
            // Apply the animation to your view (or views)
            for view in viewSecureText {
                view.layer.add(animation, forKey: "shake")
            }
            
            // Clear the passcode after the shake animation completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.clearPasscode()
            }
        }
    }
    
    private func handleCorrectPasscode() {
        if isFromSecurity {
            if let securityViewController = navigationController?.viewControllers.first(where: { $0 is SecurityViewController }) {
                navigationController?.popToViewController(securityViewController, animated: true)
            }

        } else {
            if (UserDefaults.standard.object(forKey: DefaultsKey.isRestore) as? Bool) == true {
                let viewToNavigate = RestoreWalletViewController()
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            } else {
                let viewToNavigate = SecretPhraseBackupViewController()
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            }
        }
    }
}

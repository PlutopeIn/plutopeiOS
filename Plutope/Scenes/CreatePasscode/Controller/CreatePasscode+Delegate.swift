//
//  CreatePasscode+Delegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 06/06/23.
//
import UIKit
import SDWebImage
extension CreatePasscodeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = clvKeyboard.cellForItem(at: indexPath) as? KeyboardViewCell else { return }
        let number = indexPath.row + 1
        
//        animateCellSelection(cell)
        
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
        viewSecuredText.forEach { view in
            view.imageTintColor = UIColor.c75769D
        }
    }
    private func deletePasscodeDigit() {
        
        for view in viewSecuredText.reversed() where view.tintColor == UIColor.c00C6FB {
            view.imageTintColor = UIColor.c75769D
            passcode?.removeLast()
            return
        }
    
    }
    
    private func enterPasscodeDigit(_ digit: String?) {
        guard let digit = digit else { return }
        
        if passcode?.count ?? 0 < 6 {
            passcode = (passcode ?? "") + digit
        }
        
        let currentIndex = (passcode?.count ?? 0) - 1
        
        if currentIndex >= 0 && currentIndex < viewSecuredText.count {
            viewSecuredText[currentIndex].imageTintColor = UIColor.c00C6FB
        }
    }
    private func checkPasscodeValidity() {
        
        guard let text = passcode, text.count == 6 else {
            return
        }
        
        DispatchQueue.main.async {
            if UserDefaults.standard.object(forKey: DefaultsKey.appPasscode) == nil {
                let viewToNavigate = ConfirmPasscodeViewController()
                viewToNavigate.createPasscode = self.passcode ?? ""
                viewToNavigate.isFromSecurity = self.isFromSecurity
                self.navigationController?.pushViewController(viewToNavigate, animated: true)
            } else if let savedPasscode = UserDefaults.standard.string(forKey: DefaultsKey.appPasscode), savedPasscode == self.passcode {
                self.verifyPassDelegate?.verifyPasscode(isVerify: true)
            } else {
                self.handleInvalidPasscode()
            }
        }
        
    }
    
    private func handleInvalidPasscode() {
        if passcode?.count == 6 {
            // Change the background color to red
            for view in viewSecuredText {
                view.imageTintColor = UIColor.cD50000
            }

            // Create a shake animation for horizontal movement
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 0.07
            animation.repeatCount = 3
            animation.autoreverses = true
            animation.byValue = 10.0 // Adjust the value for the desired shake distance
            
            // Apply the animation to your view (or views)
            for view in viewSecuredText {
                view.layer.add(animation, forKey: "shake")
            }
            
            // Clear the passcode after the shake animation completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.clearPasscode()
            }
        }
    }
}

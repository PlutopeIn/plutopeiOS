//
//  CustomTextField.swift
//  Plutope
//
//  Created by Priyanka Poojara on 05/06/23.
//
import UIKit
//@IBDesignable class customTextField: UITextField {
//
//    @IBInspectable
//    var leftSpacing: CGFloat = 0{
//        didSet{
//            setTextField(RightSpacing: rightSpacing, LeftSpacing: leftSpacing)
//        }
//    }
//
//    @IBInspectable
//    var rightSpacing: CGFloat = 0{
//        didSet{
//            setTextField(RightSpacing: rightSpacing, LeftSpacing: leftSpacing)
//        }
//    }
//
//    private func setTextField(RightSpacing: CGFloat = 0, LeftSpacing: CGFloat = 0) {
//
//        let leftIconContainerView: UIView = UIView(frame:CGRect(x: 20, y: 0, width: LeftSpacing, height: self.frame.height))
//        leftView = leftIconContainerView
//        leftViewMode = .always
//        let rightIconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: RightSpacing, height: self.frame.height))
//        rightView = rightIconContainerView
//        rightViewMode = .always
//    }
//
//}
@IBDesignable
class customTextField: UITextField {
    
    @IBInspectable
    var leftSpacing: CGFloat = 0 {
        didSet {
            setTextField(rightSpacing: rightSpacing, leftSpacing: leftSpacing)
        }
    }
    
    @IBInspectable
    var rightSpacing: CGFloat = 0 {
        didSet {
            setTextField(rightSpacing: rightSpacing, leftSpacing: leftSpacing)
        }
    }
    override func awakeFromNib() {
           super.awakeFromNib()
           setupLanguageChangeObserver()
           setTextField(rightSpacing: rightSpacing, leftSpacing: leftSpacing)
       }
    private func setupLanguageChangeObserver() {
        NotificationCenter.default.addObserver(forName: Notification.Name("LanguageDidChange"), object: nil, queue: .main) { [weak self] _ in
            self?.setTextField()
        }
    }
    private func setTextField(rightSpacing: CGFloat = 0, leftSpacing: CGFloat = 0) {
        let leftIconContainerView = UIView(frame: CGRect(x: 20, y: 0, width: leftSpacing, height: self.frame.height))
        let rightIconContainerView = UIView(frame: CGRect(x: 20, y: 0, width: rightSpacing, height: self.frame.height))

        // Check the current language direction
        let isRTL = LocalizationSystem.sharedInstance.getLanguage() == "ar"
        
        // Adjust positions based on language direction
        if isRTL {
            leftIconContainerView.frame.origin.x = self.frame.width - leftSpacing
            rightIconContainerView.frame.origin.x = self.frame.width - rightSpacing
            textAlignment = .left
        } else {
            textAlignment = .left
        }
        
        leftView = leftIconContainerView
        leftViewMode = .always
        
        rightView = rightIconContainerView
        rightViewMode = .always
    }
}

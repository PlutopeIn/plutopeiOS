//
//  ViewExtension.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import UIKit
extension UIViewController {
    
    func defineHeader(headerView: UIView, titleText: String, btnBackHidden: Bool = false, popToRoot: Bool = false, btnRightImage: UIImage? = nil, btnRightAction: ( () -> Void)? = nil, btnBackAction: ( () -> Void)? = nil, completion: ((_ status: Bool, _ message: String) -> Void)? = nil) {
       
        
        let header = Bundle.main.loadNibNamed("NavigationView", owner: nil, options: nil)?.first as? NavigationView

        header?.currentViewController = self.navigationController ?? UINavigationController()
        header?.popRoot = popToRoot
        
        header?.lblTitle.text = titleText
        header?.languageUpdateHandler = completion
        header?.btnBack.isHidden = btnBackHidden
        
        header?.btnRight.setImage(btnRightImage, for: .normal)
        
        if let rightAction = btnRightAction {
            header?.btnRight.addTarget(self, action: #selector(handleBtnRightTap(_:)), for: .touchUpInside)
            header?.btnRight.tag = 1
            objc_setAssociatedObject(self, &AssociatedKeys.rightActionClosure, rightAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        if let backAction = btnBackAction {
            header?.btnBack.addTarget(self, action: #selector(handleBtnBackTap(_:)), for: .touchUpInside)
            header?.btnBack.tag = 1
            header?.actionActive = true
            objc_setAssociatedObject(self, &AssociatedKeys.backActionClosure, backAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        headerView.addSubview(header ?? UIView())
        header?.translatesAutoresizingMaskIntoConstraints = false
        header?.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        header?.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        header?.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        header?.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        
    }
    
    @objc private func handleBtnRightTap(_ sender: UIButton) {
        if sender.tag == 1 {
            if let rightAction = objc_getAssociatedObject(self, &AssociatedKeys.rightActionClosure) as? () -> Void {
                rightAction()
            }
        }
    }
    
    @objc private func handleBtnBackTap(_ sender: UIButton) {
        if sender.tag == 1 {
            if let backAction = objc_getAssociatedObject(self, &AssociatedKeys.backActionClosure) as? () -> Void {
                backAction()
            }
        }
    }
    
    private struct AssociatedKeys {
        static var rightActionClosure = "rightActionClosure"
        static var backActionClosure = "backActionClosure"
    }
}

extension UIView {
   func hideContentOnScreenCapture() {
       DispatchQueue.main.async {
           let field = UITextField()
           field.isSecureTextEntry = true
           self.addSubview(field)
           field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
           field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
           self.layer.superlayer?.addSublayer(field.layer)
           field.layer.sublayers?.first?.addSublayer(self.layer)
       }
   }
}
extension String {
    func formatAmountInArabicStyle() -> String {
        guard let doubleValue = Double(self) else {
            return "Invalid amount"
        }

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 6
        numberFormatter.maximumFractionDigits = 6
        numberFormatter.locale = Locale(identifier: "ar") // Use Arabic locale

        if let formattedAmount = numberFormatter.string(from: NSNumber(value: doubleValue)) {
            return formattedAmount
        } else {
            return "Error formatting amount"
        }
    }
    static func formattedString(from number: Double) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale.current

        return numberFormatter.string(from: NSNumber(value: number))
    }
}

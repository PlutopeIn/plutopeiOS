//
//  ViewExtension.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import UIKit
import FirebaseAnalytics


extension UIViewController {
    static func swizzleViewDidAppear() {
        let originalSelector = #selector(viewDidAppear(_:))
        let swizzledSelector = #selector(swizzled_viewDidAppear(_:))

        let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)

        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }

    @objc func swizzled_viewDidAppear(_ animated: Bool) {
        swizzled_viewDidAppear(animated) // Call original `viewDidAppear`

        let screenName = String(describing: type(of: self))
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenName
        ])
    }
}

extension UIViewController {
    func trackScreenView(screenName: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: String(describing: type(of: self))
        ])
    }
    
    func defineHeader(headerView: UIView, titleText: String, btnBackHidden: Bool = false, popToRoot: Bool = false, btnRightImage: UIImage? = nil, btnRightAction: ( () -> Void)? = nil, btnBackAction: ( () -> Void)? = nil, completion: ((_ status: Bool, _ message: String) -> Void)? = nil) {
       
        
        let header = Bundle.main.loadNibNamed("NavigationView", owner: nil, options: nil)?.first as? NavigationView

        header?.currentViewController = self.navigationController ?? UINavigationController()
        header?.popRoot = popToRoot
        
        header?.lblTitle.text = titleText
        header?.lblTitle.textColor = UIColor.label
        header?.lblTitle.font = AppFont.violetRegular(20).value
        header?.languageUpdateHandler = completion
        header?.btnBack.isHidden = btnBackHidden
//        header?.btnBack.cornerRadius = header?.btnBack.frame.height ?? 20
        header?.btnRight.setImage(btnRightImage, for: .normal)
        header?.btnRight.tintColor = UIColor.label
//        header?.btnRight.backgroundColor = UIColor.secondarySystemFill
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
        HapticFeedback.generate(.light)
        if sender.tag == 1 {
            if let rightAction = objc_getAssociatedObject(self, &AssociatedKeys.rightActionClosure) as? () -> Void {
                rightAction()
            }
        }
    }
    
    @objc private func handleBtnBackTap(_ sender: UIButton) {
        HapticFeedback.generate(.light)
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

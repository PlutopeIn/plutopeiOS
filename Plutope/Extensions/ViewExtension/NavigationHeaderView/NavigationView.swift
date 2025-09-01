//
//  NavigationView.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import UIKit
class NavigationView: UIView {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnRight: UIButton!
    
    var currentViewController: UINavigationController? = nil
    var popRoot: Bool = false
    var actionActive: Bool = false
    var languageUpdateHandler : ((Bool, String) -> Void)? = nil
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func actionNotification(_ sender: Any) {
        HapticFeedback.generate(.light)
        let viewToNavigate = NotificationViewController()
        viewToNavigate.hidesBottomBarWhenPushed = true
        currentViewController?.pushViewController(viewToNavigate, animated: true)
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        HapticFeedback.generate(.light)
        if !actionActive {
            if popRoot {
                currentViewController?.popToRootViewController(animated: true)
            } else {
                currentViewController?.popViewController(animated: true)
                currentViewController?.dismiss(animated: true, completion: nil)
                guard let sceneDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
                guard let viewController = sceneDelegate.window?.rootViewController else { return }
                viewController.dismiss(animated: true)
            }
        }
    }
}

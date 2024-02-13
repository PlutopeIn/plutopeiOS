//
//  PushNotificationViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 09/06/23.
//

import UIKit

class PushNotificationViewController: UIViewController {
    
    @IBOutlet weak var ivInfo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnCancel: GradientButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var cancelDelete: UIStackView!
    
    var deleteAction: (() -> Void)?
    var okAction: (() -> Void)?
   
    var alertData: CustomAlert? {
        didSet {
            if isViewLoaded {
                configureUIElements()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnCancel.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: ""), for: .normal)
        self.btnDelete.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.deletewallet, comment: ""), for: .normal)
        configureUIElements()
    }
    
    private func configureUIElements() {
        if let data = alertData {
            lblTitle.text = data.title
            lblTitle.isHidden = data.hideTitle
            
            lblMessage.textColor =  lblTitle.isHidden ? UIColor.white : UIColor.c75769D
            
            lblMessage.text = data.description
            lblMessage.isHidden = data.hideDesc
            
            ivInfo.isHidden = data.hideIcon
            
            cancelDelete.isHidden = data.hideButtons
            
            btnDelete.isHidden = data.hideButtons || data.hideDelete
        
            btnCancel.isHidden = data.hideButtons || data.hideCancel
            
            btnCross.isHidden = data.hideIcon
            
            btnDelete.setTitle(data.deleteTitle, for: .normal)
            
            ivInfo.image = data.setIcon
            
            btnCancel.setTitle(data.cancelTitle, for: .normal)
        }
    }
    
    @IBAction func actionCross(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        if alertData == .swapping {
            self.dismiss(animated: true) {
                self.okAction?()
            }
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        deleteAction?()
    }
}

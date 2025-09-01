//
//  MoreDetailViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/08/23.
//

import UIKit

class MoreDetailViewController: UIViewController {
    
    @IBOutlet weak var txtMobile: customTextField!
    @IBOutlet weak var ivCheckUncheck: UIImageView!
    @IBOutlet weak var viewCheckUncheck: UIView!
    @IBOutlet weak var btnNext: GradientButton!
    @IBOutlet weak var txtLanguage: customTextField!
    @IBOutlet weak var txtPassword: customTextField!
    @IBOutlet weak var txtEmail: customTextField!
    var isChecked: Bool = false
    let pickerView = UIPickerView()
    var arrLanguage = ["English","Chinese","Russian"]
    // Define a closure property that acts as a callback
    var onNextButtonTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewConfigure()
        viewCheckUncheck.addTapGesture {
            self.isChecked.toggle()
            if self.isChecked {
                self.ivCheckUncheck.image = UIImage.check
                self.btnNext.alpha = 1
                self.btnNext.isEnabled = true
            } else {
                self.ivCheckUncheck.image = UIImage.uncheck
                self.btnNext.alpha = 0.5
                self.btnNext.isEnabled = false
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                txtMobile.textAlignment = .right
                txtLanguage.textAlignment = .right
                txtPassword.textAlignment = .right
                txtEmail.textAlignment = .right
                
            } else {
                txtMobile.textAlignment = .left
                txtLanguage.textAlignment = .left
                txtPassword.textAlignment = .left
                txtEmail.textAlignment = .left
            }
            
        }
    private func pickerViewConfigure() {
        /// Configure picker view for challange type and Set delegates
        pickerView.delegate = self
        pickerView.dataSource = self
        txtLanguage.inputView = pickerView
        txtLanguage.delegate = self
    }
    @IBAction func actionNext(_ sender: Any) {
        onNextButtonTapped?()
    }
    
}

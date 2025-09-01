//
//  MembershipCardDesignViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/08/23.
//

import UIKit

class MembershipCardDesignViewController: UIViewController {
    
    // Define a closure property that acts as a callback
    @IBOutlet weak var ivCurruncySign: UIImageView!
    @IBOutlet weak var lblWalletCap: UILabel!
    @IBOutlet weak var txtShipping: customTextField!
    @IBOutlet weak var txtCurruncy: customTextField!
    @IBOutlet weak var btnContinue: GradientButton!
    @IBOutlet weak var lblPrice: UILabel!
    var receivedPlanPrice: String?
    var price = ""
    var onNextButtonTapped: ((_ data: String) -> Void)?
    
    var shippingListArr : [MembershipCardData] = [.standardMail,.professionalMail,.businessMail]
    var currencyData = DatabaseHelper.shared.retrieveData("Currencies") as? [Currencies]
    
    let curruncyPickerView = UIPickerView()
    let shippingPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: ""), for: .normal)
        self.lblWalletCap.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continues, comment: "")
        
        pickerViewConfigure()
        // Access the received data and use it as needed
        if let data = receivedPlanPrice {
            lblPrice.text = "\(data)"
            self.price = data
            print("Received data: \(data)")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                txtShipping.textAlignment = .right
                txtCurruncy.textAlignment = .right
            } else {
                txtShipping.textAlignment = .left
                txtCurruncy.textAlignment = .right
            }
            
        }
    private func pickerViewConfigure() {
        // Configure picker view for challange type
        curruncyPickerView.delegate = self
        curruncyPickerView.dataSource = self
        
        shippingPickerView.delegate = self
        shippingPickerView.dataSource = self
        
        txtCurruncy.inputView = curruncyPickerView
        txtShipping.inputView = shippingPickerView
        
        // Set delegates
        txtCurruncy.delegate = self
        txtShipping.delegate = self
        
    }
    @IBAction func btnContinueAction(_ sender: GradientButton) {
        
        onNextButtonTapped?(self.price)
    }
}

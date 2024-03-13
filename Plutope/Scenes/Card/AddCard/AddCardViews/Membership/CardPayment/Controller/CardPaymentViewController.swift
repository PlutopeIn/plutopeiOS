//
//  CardPaymentViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/08/23.
//

import UIKit

class CardPaymentViewController: UIViewController {

    @IBOutlet weak var txtPaymentMethod: customTextField!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnConfirm: GradientButton!
    
    var arrPaymentMothod = ["Crypto","Card"]
    let pickerView = UIPickerView()
    var receivedPlanPrice: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure picker view for challange type
        pickerViewConfigure()
        if let data = receivedPlanPrice {
          //  lblPrice.text = "\(data)"
            print("Received data: \(data)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                txtPaymentMethod.textAlignment = .right
            } else {
                txtPaymentMethod.textAlignment = .left
            }
            
        }
    private func pickerViewConfigure() {
        pickerView.delegate = self
        pickerView.dataSource = self
        txtPaymentMethod.inputView = pickerView
        // Set delegates
        txtPaymentMethod.delegate = self
    }
    @IBAction func btnConfirmAction(_ sender: GradientButton) {
    }
}

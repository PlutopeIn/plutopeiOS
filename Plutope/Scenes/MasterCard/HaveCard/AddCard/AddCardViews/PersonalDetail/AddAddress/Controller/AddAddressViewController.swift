//
//  AddAddressViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/08/23.
//

import UIKit

class AddAddressViewController: UIViewController {
    
    @IBOutlet weak var txtAddress1: customTextField!
    @IBOutlet weak var txtAddress2: customTextField!
    @IBOutlet weak var txtCity: customTextField!
    @IBOutlet weak var txtPostCode: customTextField!
    
    var onNextButtonTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                txtAddress1.textAlignment = .right
                txtAddress2.textAlignment = .right
                txtCity.textAlignment = .right
                txtPostCode.textAlignment = .right
                
            } else {
                txtAddress1.textAlignment = .left
                txtAddress2.textAlignment = .left
                txtCity.textAlignment = .left
                txtPostCode.textAlignment = .left
            }
            
        }
    @IBAction func actionNext(_ sender: Any) {
        onNextButtonTapped?()
    }
    
}

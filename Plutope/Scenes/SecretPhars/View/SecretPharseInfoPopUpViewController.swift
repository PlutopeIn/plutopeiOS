//
//  SecretPharseInfoPopUpViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 29/12/23.
//

import UIKit

class SecretPharseInfoPopUpViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnContinue: GradientButton!
    @IBOutlet weak var ivClose: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addTapGesture {
            self.dismiss(animated: true)
        }
        ivClose.addTapGesture {
            self.dismiss(animated: true)
        }
        mainView.clipsToBounds = true
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        mainView.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    @IBAction func btnContinueAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

//
//  ToPhonenumberPopUpVC.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/06/24.
//

import UIKit
protocol SetPhoneNumberDelegate : AnyObject {
    func setPhoneNumber(phoneNo : String)
   // func gotoSendDashboard()
}
class ToPhonenumberPopUpVC: UIViewController {

    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var lblheaderTitle: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtMobile: UILabel!
    @IBOutlet weak var headerView: UIView!
    weak var delegate : SetPhoneNumberDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        ivClose.addTapGesture {
            HapticFeedback.generate(.light)
            self.dismiss(animated: true)
        }
    }


    @IBAction func btnAllowAction(_ sender: Any) {
        HapticFeedback.generate(.light)
    }
    @IBAction func btnSaveAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        self.dismiss(animated: true) {
            self.delegate?.setPhoneNumber(phoneNo: self.txtMobile.text ?? "")
        }
       
    }

}

//
//  CardMainViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/05/24.
//

import UIKit

class CardMainViewController: UIViewController ,Reusable {

    @IBOutlet weak var tbvDetails: UITableView!
    @IBOutlet weak var headerView: UIView!
    var arrFeatures : [CardFeaturs] = []
    var kyclevel = ""
    var kycStatus = ""
    lazy var myTokenViewModel: MyTokenViewModel = {
        MyTokenViewModel { _ ,message in
        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        getKycStatus()
        // Navigation header
        defineHeader(headerView: headerView, titleText: "", btnBackHidden: false)
        self.arrFeatures = [CardFeaturs(name: "Profile"),CardFeaturs(name: "Kyc status"),CardFeaturs(name:"My Token"),CardFeaturs(name:"My card")]
        /// Table Register
        tableRegister()
    }
    /// Table Register
    func tableRegister() {
        tbvDetails.delegate = self
        tbvDetails.dataSource = self
        tbvDetails.register(CardMainViewCell.nib, forCellReuseIdentifier: CardMainViewCell.reuseIdentifier)

    }
    
    func getKycStatus() {
        DGProgressView.shared.showLoader(to: view)
        myTokenViewModel.kycStatusAPINew { status,msg, data in
            if status == 1 {
                DGProgressView.shared.hideLoader()
                self.kyclevel = data?.kycLevel ?? ""
                self.kycStatus = data?.kyc1ClientData?.status ?? ""
//                if data?.kyc1ClientData?.rejectFormattedMessage != "" {
//                    self.showSimpleAlert(Message:data?.kyc1ClientData?.rejectFormattedMessage ?? "")
//                }
                self.tbvDetails.reloadData()
                self.tbvDetails.restore()
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: "Server Error", font: AppFont.regular(15).value)
            }
        }
    }
}

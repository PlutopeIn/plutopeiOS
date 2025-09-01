//
//  MembershipPlanViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/08/23.
//

import UIKit

class MembershipPlanViewController: UIViewController {

    @IBOutlet weak var clvMembershipType: UICollectionView!
    @IBOutlet weak var ivBackground: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblCardType: UIStackView!
    @IBOutlet weak var lblDailyCardTopUp: UILabel!
    @IBOutlet weak var lblATMWithdrawels: UILabel!
    @IBOutlet weak var btnSelectCard: GradientButton!
    @IBOutlet weak var lblCryptoLiquidation: UILabel!
    @IBOutlet weak var lblGlobalSupport: UILabel!
    
    var selectedPlanPrice = ""
    var arrMembersipTypeData: [MembershipData] = [.basic,.professional,.business,.platinumElite]
 
    // Define a closure property that acts as a callback
    var onNextButtonTapped: ((_ data: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionViews()
    }
    
    /// Collection Register
    private func registerCollectionViews() {
        clvMembershipType.register(PhraseViewCell.nib, forCellWithReuseIdentifier: PhraseViewCell.reuseIdentifier)
        clvMembershipType.delegate = self
        clvMembershipType.dataSource = self
    }
    
    @IBAction func btnGetCardAction(_ sender: GradientButton) {
        onNextButtonTapped?(selectedPlanPrice)
    }
    
}

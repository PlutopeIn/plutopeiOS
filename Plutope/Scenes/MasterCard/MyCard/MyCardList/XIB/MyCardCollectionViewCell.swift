//
//  MyCardCollectionViewCell.swift
//  Plutope
//
//  Created by Pushpendra Rajput on 08/08/24.
//

import UIKit

class MyCardCollectionViewCell: UICollectionViewCell , Reusable{

    @IBOutlet weak var ivCardCompany: UIImageView!
    @IBOutlet weak var viewCard: UIView!
//    @IBOutlet weak var btnCheck: GradientButton!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblFreeze: UILabel!
    @IBOutlet weak var btnCancel: GradientButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var circularProgress: CircularProgressView!
    var additionalStatuses:[String] = []
    @IBOutlet weak var ivCard: UIImageView!
    @IBOutlet weak var lblTokkenAddress: UILabel!
    @IBOutlet weak var lblToken: UILabel!
    var cardRequestId :Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

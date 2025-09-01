//
//  MyCardTableViewCell.swift
//  Plutope
//
//  Created by Trupti Mistry on 23/05/24.
//

import UIKit

class MyCardTableViewCell: UITableViewCell ,Reusable {

    @IBOutlet weak var btnAdd: GradientButton!
    @IBOutlet weak var ivCardCompany: UIImageView!
    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var btnCheck: GradientButton!
    @IBOutlet weak var lblFreeze: UILabel!
    @IBOutlet weak var btnCancel: GradientButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var circularProgress: CircularProgressView!
    var additionalStatuses:[String] = []
    @IBOutlet weak var ivCard: UIImageView!
    @IBOutlet weak var lblTokkenAddress: UILabel!
    @IBOutlet weak var lblToken: UILabel!
    @IBOutlet weak var imgSelection: UIImageView!
    var cardRequestId :Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

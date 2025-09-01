//
//  MyTokenTableViewCell.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/05/24.
//

import UIKit

class MyTokenTableViewCell: UITableViewCell,Reusable {

    @IBOutlet weak var ivToken: UIImageView!
    @IBOutlet weak var btnTopup: UIButton!
    @IBOutlet weak var lblTokkenAddress: UILabel!
    @IBOutlet weak var lblToken: UILabel!
    var cardRequestId :Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblToken.font = AppFont.violetRegular(13).value
        lblTokkenAddress.font = AppFont.regular(10).value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

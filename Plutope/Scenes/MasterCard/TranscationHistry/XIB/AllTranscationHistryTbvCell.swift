//
//  AllTranscationHistryTbvCell.swift
//  Plutope
//
//  Created by Trupti Mistry on 19/06/24.
//

import UIKit

class AllTranscationHistryTbvCell: UITableViewCell ,Reusable {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    var isToContract  = false
    var priceSsymbol = ""
    var headerTitle = ""
    @IBOutlet weak var ivTansaction: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        lblTitle.font = AppFont.violetRegular(15).value
//        lblDescription.font = AppFont.regular(11).value
//        lblPrice.font = AppFont.violetRegular(15).value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

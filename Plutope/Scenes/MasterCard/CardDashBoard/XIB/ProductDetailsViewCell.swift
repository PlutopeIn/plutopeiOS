//
//  ProductDetailsViewCell.swift
//  Fitrizer
//
//  Created by Trupti Mistry on 15/04/24.
//

import UIKit

class ProductDetailsViewCell: UICollectionViewCell ,Reusable{

    @IBOutlet weak var viewCheck: UIView!
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    
    @IBOutlet weak var ivCardCompany: UIImageView!
    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var lblFreeze: UILabel!
  
    var additionalStatuses:[String] = []
  
    @IBOutlet weak var lblTokkenAddress: UILabel!
    @IBOutlet weak var lblToken: UILabel!
    var cardRequestId :Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        btnCheck.titleLabel?.font = AppFont.regular(13).value
        // Initialization code
    }

}

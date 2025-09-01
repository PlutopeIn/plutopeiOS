//
//  KeyboardViewCell.swift
//  Plutope
//
//  Created by Priyanka Poojara on 06/06/23.
//
import UIKit
class KeyboardViewCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var rightLable: UILabel!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var txtNumber: UILabel!
    
    @IBOutlet weak var leftLable: UILabel!
    @IBOutlet weak var bottomLable: UILabel!
    @IBOutlet weak var topLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        txtNumber.font = AppFont.violetRegular(34).value
        // Initialization code
    }
}

//
//  KeyboardViewCell.swift
//  Plutope
//
//  Created by Priyanka Poojara on 06/06/23.
//
import UIKit
class KeyboardViewCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var txtNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

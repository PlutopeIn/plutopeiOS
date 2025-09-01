//
//  PhraseViewCell.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import UIKit

class PhraseViewCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var bgView: GradientView!
    @IBOutlet weak var lblPhrase: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var viewNumber: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblPhrase.font = AppFont.violetRegular(16).value
    }
}

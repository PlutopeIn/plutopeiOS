//
//  WelcomeViewCell.swift
//  Plutope
//
//  Created by Priyanka Poojara on 08/06/23.
//
import UIKit
import Lottie

class WelcomeViewCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var animationView: LottieAnimationView!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = AppFont.violetRegular(32).value
        lblDescription.font = AppFont.violetRegular(16).value
    }
    
}

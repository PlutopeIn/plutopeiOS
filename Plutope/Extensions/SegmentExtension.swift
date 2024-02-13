//
//  SegmentExtension.swift
//  Plutope
//
//  Created by Priyanka Poojara on 27/06/23.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {
    private let segmentInset: CGFloat = 0       // your inset amount
    private let segmentImage: UIImage? = UIImage(color: UIColor.c202148)    // your color
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // background
        layer.cornerRadius = bounds.height/2
        // foreground
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = segmentImage    // substitute with our own colored image
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")    // this removes the weird scaling animation!
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.bounds.height/2
        } else {
            subviews[foregroundIndex].backgroundColor = .clear
        }
    }

}

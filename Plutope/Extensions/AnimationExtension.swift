//
//  AnimationExtension.swift
//  Plutope
//
//  Created by Priyanka Poojara on 15/06/23.
//

import UIKit

public func animateCellSelection(_ cell: UICollectionViewCell) {
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
        cell.layer.cornerRadius = cell.frame.height / 2
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    })
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            cell.backgroundColor = UIColor.clear
        })
    }
}

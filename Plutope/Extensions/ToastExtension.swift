//
//  ToastExtension.swift
//  Plutope
//
//  Created by Priyanka Poojara on 15/06/23.
//
import Foundation
import UIKit
extension UIViewController {
func showToast(message: String, font: UIFont) {
    let Size = message.sizeOfString(usingFont: font)
    
    var y: CGFloat = 100
    
    if isNotched() {
     y = 138
    }
    //let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - ((Size.width + 20) / 2), y: self.view.frame.size.height-y, width: Size.width + 20, height: Size.height + 10))
    let toastLabel = UILabel(frame: .zero)
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 0
    toastLabel.layer.cornerRadius = (Size.height + 4) / 2 ;
    toastLabel.clipsToBounds  =  false
    toastLabel.numberOfLines = 0
    toastLabel.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(toastLabel)
    self.view.bringSubviewToFront(toastLabel)
        
    NSLayoutConstraint.activate([
        toastLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        toastLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -y),
        toastLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 40)
    ])
    
    let frameView = UIView(frame: .zero)
    frameView.translatesAutoresizingMaskIntoConstraints = false
    frameView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    frameView.alpha = 0
    self.view.addSubview(frameView)
    self.view.bringSubviewToFront(frameView)
    self.view.bringSubviewToFront(toastLabel)
    
    NSLayoutConstraint.activate([
        frameView.bottomAnchor.constraint(equalTo: toastLabel.bottomAnchor, constant: 8),
        frameView.topAnchor.constraint(equalTo: toastLabel.topAnchor, constant: -8),
        frameView.leadingAnchor.constraint(equalTo: toastLabel.leadingAnchor, constant: -15),
        frameView.trailingAnchor.constraint(equalTo: toastLabel.trailingAnchor, constant: 15),
    ])
    
    frameView.clipsToBounds = true
    frameView.layer.cornerRadius = 12
    
    let scaleUp = CGAffineTransform(scaleX: 1, y: 1)
    let scaleDown = CGAffineTransform(scaleX: 0.8, y: 0.8)
    
    frameView.transform = scaleDown
    toastLabel.transform = scaleDown
    
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
         toastLabel.alpha = 1
        frameView.alpha = 1
        frameView.transform = scaleUp
        toastLabel.transform = scaleUp
    }, completion: {(isCompleted) in
    })
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
             toastLabel.alpha = 0.0
            frameView.alpha = 0.0
            frameView.transform = scaleDown
            toastLabel.transform = scaleDown
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
            frameView.removeFromSuperview()
        })
    }
} }

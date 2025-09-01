//
//  CustomButton.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import UIKit
@IBDesignable
class GradientButton: UIButton {
    let gradientLayer = CAGradientLayer()
    var activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    var loaderTintColor : UIColor? = nil
    private var preSetTitle = String()
    
    @IBInspectable
    var cornderRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornderRadius
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor, cornerRadius: cornderRadius)
        }
    }
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?, borderWidth: CGFloat? = 0, borderColor: UIColor? = UIColor.black, cornerRadius: CGFloat = 0) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.startPoint = CGPoint(x: -0.3, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientLayer.borderColor = borderColor?.cgColor
            gradientLayer.borderWidth = borderWidth ?? 0
            gradientLayer.cornerRadius = cornderRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
    
    /// loader show/hide
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        self.superview?.addSubview(activityView)
        activityView.frame = self.frame
        activityView.isHidden = true
        preSetTitle = titleLabel?.text ?? ""
        activityView.color = UIColor.systemGray

    }

    func ShowLoader(){
        DispatchQueue.main.async {
            self.setTitle("", for: .normal)
            self.activityView.isHidden = false
            self.activityView.startAnimating()
            self.isUserInteractionEnabled = false
            self.superview?.bringSubviewToFront(self.activityView)
        }
    }

    func HideLoader(){
        DispatchQueue.main.async {
            self.setTitle(self.preSetTitle, for: .normal)
            self.activityView.isHidden = true
            self.activityView.stopAnimating()
            self.isUserInteractionEnabled = true
           
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
}

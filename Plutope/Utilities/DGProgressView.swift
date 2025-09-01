//
//  DGProggressView.swift
//  Playground
//
//  Created by Dhruv Govani on 23/07/20.
//  Copyright © 2020 Dhruv Govani. All rights reserved.
//

import Foundation
import UIKit

/// A simple Progress view inside a 100X100 Visual Blur Effect View
/// Use DGProgressView.shared to access all functions
class DGProgressView : UIView {
    
    deinit {
        proggressView.removeFromSuperview()
        blurView.removeFromSuperview()
        activityView.removeFromSuperview()
    }
    
    private let proggressView = UIView()
    private let progressImageView = UIImageView(frame: .zero)
    private let progressTitle = UILabel(frame: .zero)
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let activityView = UIActivityIndicatorView(style: .gray)
    var superView = UIView()
    
    let loaderHolder : UIView = UIView(frame: .zero)
    let loaderImage : UIImageView = UIImageView(frame: .zero)
    let loaderLabel : UILabel = UILabel(frame: .zero)
    let blackBG : UILabel = UILabel(frame: .zero)
    let spinner : SpinnerView = SpinnerView(frame: .zero)
    
    static let shared = DGProgressView()
    
    func hideLoader() {
      //  self.superView.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                
                self.superView.isUserInteractionEnabled = true
                self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self.blurView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self.alpha = 0
                self.blurView.alpha = 0
                
            }) { (_) in
                self.superView.isUserInteractionEnabled = true
                self.isHidden = true
                self.blurView.isHidden = true
                self.activityView.stopAnimating()
                self.proggressView.removeFromSuperview()
                self.blurView.removeFromSuperview()
                self.activityView.removeFromSuperview()
            }
        }
    }
    
    func showLoader(to : UIView) {
        
        superView = to
        
        superView.addSubview(proggressView)
        superView.bringSubviewToFront(proggressView)
        
        proggressView.layer.shadowColor = UIColor.white.cgColor
        proggressView.layer.shadowOffset = CGSize(width: 1, height: 1)
        proggressView.layer.shadowRadius = 6
        proggressView.layer.shadowOpacity = 0.6
        
        proggressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                proggressView.centerYAnchor.constraint(equalTo: to.safeAreaLayoutGuide.centerYAnchor, constant: 0),
                proggressView.centerXAnchor.constraint(equalTo: to.safeAreaLayoutGuide.centerXAnchor),
                proggressView.heightAnchor.constraint(equalToConstant: 75),
                proggressView.widthAnchor.constraint(equalToConstant: 75)
            ]
        )
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        proggressView.addSubview(blurView)
        
        NSLayoutConstraint.activate(
            [
                blurView.topAnchor.constraint(equalTo: proggressView.topAnchor, constant: 0),
                blurView.bottomAnchor.constraint(equalTo: proggressView.bottomAnchor, constant: 0),
                blurView.trailingAnchor.constraint(equalTo: proggressView.trailingAnchor, constant: 0),
                blurView.leadingAnchor.constraint(equalTo: proggressView.leadingAnchor, constant: 0)
            ]
        )
        
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 8
        activityView.layer.cornerRadius = 8
        activityView.tintColor = .label
        blurView.contentView.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                activityView.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor),
                activityView.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor)
            ]
        )
        
        blurView.isHidden = true
        self.isHidden = true
        
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        blurView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        activityView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        self.alpha = 0
        self.blurView.alpha = 0
        
        self.isHidden = false
        self.blurView.isHidden = false
        self.activityView.startAnimating()
        
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.blurView.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            self.alpha = 1
            self.blurView.alpha = 1
        }) { (_) in
            self.superView.isUserInteractionEnabled = false
        }
        
    }
    /// this function will add the proggress view inside your view and shows it to user
    /// - parameter to: must set to self.view
    func show(to : UIView) {
        
        self.superView = to
        
        blackBG.frame = self.superView.frame
        
        blackBG.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        superView.addSubview(blackBG)
        
        loaderHolder.backgroundColor = .white
        loaderHolder.alpha = 0

        self.superView.addSubview(loaderHolder)
        
        loaderHolder.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                loaderHolder.centerYAnchor.constraint(equalTo: self.superView.centerYAnchor, constant: 0),
                loaderHolder.centerXAnchor.constraint(equalTo: self.superView.centerXAnchor, constant: 0),
                loaderHolder.widthAnchor.constraint(equalToConstant: 95),
                loaderHolder.heightAnchor.constraint(equalToConstant: 95)
                
            ]
        )
        
        /* loaderHolder.layer.masksToBounds = false
         loaderHolder.layer.cornerRadius = 8
         loaderHolder.layer.shadowColor = UIColor.lightGray.cgColor
         loaderHolder.layer.shadowPath = UIBezierPath(roundedRect: loaderHolder.bounds, cornerRadius: loaderHolder.layer.cornerRadius).cgPath
         loaderHolder.layer.shadowOffset = CGSize(width: 0, height: 0)
         loaderHolder.layer.shadowOpacity = 0.6
         loaderHolder.layer.shadowRadius = 6 */
        
        loaderHolder.RoundMe(Radius: 8)
        
        loaderHolder.addSubview(loaderImage)
        
        loaderImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                loaderImage.centerYAnchor.constraint(equalTo: loaderHolder.centerYAnchor, constant: 0),
                loaderImage.centerXAnchor.constraint(equalTo: loaderHolder.centerXAnchor, constant: 0),
                loaderImage.widthAnchor.constraint(equalToConstant: 35),
                loaderImage.heightAnchor.constraint(equalToConstant: 35)
                
            ]
        )
        
        loaderHolder.addSubview(loaderLabel)
        
        loaderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                loaderLabel.centerYAnchor.constraint(equalTo: loaderHolder.centerYAnchor, constant: 0),
                loaderLabel.centerXAnchor.constraint(equalTo: loaderHolder.centerXAnchor, constant: 0)
                // loaderLabel.heightAnchor.constraint(equalToConstant: 30)
                
            ]
        )
        
        loaderLabel.font = UIFont.systemFont(ofSize: 11)
        loaderLabel.text = ""
        
//        loaderImage.image = #imageLiteral(resourceName: "Jobs").withRenderingMode(.alwaysTemplate)
        
        loaderImage.tintColor = UIColor.white
        
        let spinner = SpinnerView(frame: CGRect(x: 10, y: 10, width: 75, height: 75))
        
        loaderLabel.textColor = UIColor.white
        
        loaderHolder.addSubview(spinner)
        
      //  spinner.animate()
        
        loaderHolder.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        blackBG.alpha = 0
        
        UIView.transition(with: superView, duration: 0.2, options: .curveEaseIn, animations: {
            self.blackBG.alpha = 1
            self.loaderHolder.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.loaderHolder.alpha = 1
        }) { (_) in
            self.blackBG.alpha = 1
            self.loaderHolder.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.loaderHolder.alpha = 1
        }
        
    }
    
    /// this function will remove the proggress view from your view, total deinit.
    func hide() {
        
        UIView.transition(with: superView, duration: 0.2, options: .curveEaseIn, animations: {
            self.loaderHolder.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.loaderHolder.alpha = 0
            self.blackBG.alpha = 0
            
        }) { (_) in
            self.loaderHolder.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.loaderHolder.alpha = 0
            self.blackBG.alpha = 0
            for subView in self.loaderHolder.subviews {
                subView.removeFromSuperview()
            }
            self.loaderHolder.removeFromSuperview()
        }
        
    }
}

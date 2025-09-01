//
//  LoadingTextField.swift
//  Plutope
//
//  Created by Trupti Mistry on 08/11/23.
//

import Foundation
import UIKit
class LoadingTextField: UITextField {
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.gray
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        ])
    }

    func showLoading() {
        activityIndicator.startAnimating()
        text = nil
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
       
    }
}

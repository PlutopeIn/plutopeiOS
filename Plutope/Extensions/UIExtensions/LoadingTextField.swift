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
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
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

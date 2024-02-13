//
//  CustomLable.swift
//  Plutope
//
//  Created by Mitali Desai on 17/07/23.
//

import Foundation
import UIKit

class LoadingLabel: UILabel {
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
        activityIndicator.stopAnimating()
    }
}

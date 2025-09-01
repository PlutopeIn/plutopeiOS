//
//  CustomLable.swift
//  Plutope
//
//  Created by Mitali Desai on 17/07/23.
//

import Foundation
import UIKit
import ObjectiveC
class LoadingLabel: UILabel {
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
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

private var loaderKey: UInt8 = 0

extension UITableView {
    
    private var tableLoader: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &loaderKey) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &loaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func showLoader() {
        DispatchQueue.main.async {
            guard self.tableLoader == nil else { return }
            guard let superview = self.superview else { return }

            let loader = UIActivityIndicatorView(style: .large)
            loader.color = .gray
            loader.translatesAutoresizingMaskIntoConstraints = false
            loader.startAnimating()
            
            superview.addSubview(loader)

            // Pin to center of the tableView within its superview
            NSLayoutConstraint.activate([
                loader.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
                loader.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
            
            self.tableLoader = loader
        }
    }

    func hideLoader() {
        DispatchQueue.main.async {
            self.tableLoader?.stopAnimating()
            self.tableLoader?.removeFromSuperview()
            self.tableLoader = nil
        }
    }
    
    
}
private var collectionLoaderKey: UInt8 = 0

extension UICollectionView {
    
    private var collectionLoader: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &collectionLoaderKey) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &collectionLoaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func showLoader() {
        DispatchQueue.main.async {
            guard self.collectionLoader == nil else { return }
            guard let superview = self.superview else { return }

            let loader = UIActivityIndicatorView(style: .large)
            loader.color = .gray
            loader.translatesAutoresizingMaskIntoConstraints = false
            loader.startAnimating()

            superview.addSubview(loader)

            NSLayoutConstraint.activate([
                loader.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
                loader.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])

            self.collectionLoader = loader
        }
    }

    func hideLoader() {
        DispatchQueue.main.async {
            self.collectionLoader?.stopAnimating()
            self.collectionLoader?.removeFromSuperview()
            self.collectionLoader = nil
        }
    }
}


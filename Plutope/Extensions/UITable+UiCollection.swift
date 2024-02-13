//
//  UITable+UiCollection.swift
//  Plutope
//
//  Created by Priyanka Poojara on 05/06/23.
//
import Foundation
import UIKit
protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}
extension Reusable {
    static var reuseIdentifier: String { return String(describing: self) }
    static var nib: UINib? {
        UINib(nibName: String(describing: self), bundle: nil)
    }
}
extension UITableView {
    func dequeueReusableCell<T: Reusable>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable {
        if let nib = T.nib {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeHeaderAsACell<T: Reusable>() -> T {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier) as! T
    }
    
}
extension UICollectionView {
    
    func registerReusableCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        if let nib = T.nib {
            self.register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: Reusable {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

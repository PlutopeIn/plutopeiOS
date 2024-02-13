//
//  LockMethod+Delegate.swift
//  Plutope
//
//  Created by Mitali Desai on 07/07/23.
//

import UIKit
// MARK: UITableViewDelegate methods
extension LockMethodViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        UserDefaults.standard.set(self.arrMethodData[indexPath.row].title, forKey: DefaultsKey.appLockMethod)
        tbvLockMethod.reloadData()
    }
}

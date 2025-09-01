//
//  Security+Delegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 20/06/23.
//
import UIKit
// MARK: UITableViewDelegate methods
extension SecurityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        switch indexPath.row {
        case 1:
            let destinationVC = LockMethodViewController()
               if let navigationController = self.navigationController,
                   navigationController.viewControllers.contains(destinationVC) {
                   return
               }
            self.navigationController?.pushViewController(destinationVC, animated: true)
        default:
            break
        }
    }
}

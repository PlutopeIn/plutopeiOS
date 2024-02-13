//
//  Provider+Delegate.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
extension ProvidersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = arrProviderList[indexPath.row]
        guard let proto = self.delegate else { return }
        proto.valuesTobePassed(data)
        self.navigationController?.popViewController(animated: true)
    }
}

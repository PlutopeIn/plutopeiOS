//
//  SwapProvidersViewController+Delegate.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
extension SwapProvidersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = arrProviderList[indexPath.row]
        guard let proto = self.delegate else { return }
        proto.valuesTobePassed(data)
        self.dismiss(animated: true,completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
        self.tbvHeight.constant = tbvProviders.contentSize.height
    }
}

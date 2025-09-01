//
//  Provider+Delegate.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
extension ProvidersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        let data = buyArrProviderList[indexPath.row]
       
        self.buydelegate?.valuesTobePassed(data.name ?? "", amount: data.amount ?? "", url: data.url ?? "",imageUrl: data.image ?? "",providerName: data.providerName ?? "")
        print("proto",data)
        self.navigationController?.popViewController(animated: true)
    }
}

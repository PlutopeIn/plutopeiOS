//
//  SwapProvidersViewController+Delegate.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//
import UIKit
extension SwapProvidersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        let data = swapArrProviderList[indexPath.row]
        let cell = tbvProviders.cellForRow(at: indexPath) as? SwapProvidersViewCell
        guard let proto = self.delegate else { return }
//        proto.valuesTobePassed(data)
        var isbestprice : Bool?
        if indexPath.row == 0 {
            isbestprice = false
        } else {
            isbestprice = true
        }
        
        
        proto.valuesTobePassed(name: data.name, bestPrice: cell?.quotAmount, swapperFee: "", providerImage: data.image,providerName: data.providerName ?? "", isBestPrice: isbestprice ?? true)
        self.dismiss(animated: true,completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
   
}

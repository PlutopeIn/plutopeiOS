//
//  ENSViewController+DataSource.swift
//  Plutope
//
//  Created by Trupti Mistry on 02/01/24.
//

import Foundation
import UIKit
import BigInt
import Web3

// MARK: UITableViewDataSource Methods
extension ENSViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredList.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tbvEnsList.dequeueReusableCell(indexPath: indexPath) as ENSViewCell
        let data = filteredList[indexPath.row]
        cell.selectionStyle = .none
        cell.lblName.text = data.name
        cell.lblStatus.text = data.availability?.status
        let price = data.availability?.price?.listPrice?.usdCents ?? 0
        let totalPrice = price / 100
        cell.lblPrice.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.price, comment: "")) :$\(totalPrice)"
        cell.lblName.textAlignment = (LocalizationSystem.sharedInstance.getLanguage() == "ar") ? .right : .left
        cell.lblPrice.textAlignment = (LocalizationSystem.sharedInstance.getLanguage() == "ar") ? .right : .left
        cell.lblStatus.textAlignment = (LocalizationSystem.sharedInstance.getLanguage() == "ar") ? .right : .left
        cell.btnBuy.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.buy, comment: ""), for: .normal)
        cell.btnBuy.tag = indexPath.row
        cell.btnBuy.addTarget(self, action: #selector(buyDomain(_:)), for: .touchUpInside)
        cell.btnBuy.isUserInteractionEnabled = true
        return cell
    }
    @objc func buyDomain(_ sender : UIButton) {
        HapticFeedback.generate(.light)
        let cell = self.tbvEnsList.cellForRow(at: IndexPath.init(item: sender.tag, section: 0)) as? ENSViewCell
        
        self.txValue = filteredList[sender.tag].tx?.params?.value ?? ""
        self.receiverAddress = filteredList[sender.tag].tx?.params?.to ?? ""
        self.txData = filteredList[sender.tag].tx?.params?.data ?? ""
        let ensConfirmationVC = ENSConfirmationPopupViewController()
        ensConfirmationVC.assets = "\(coinDetail?.name ?? "")(\(coinDetail?.symbol ?? ""))"
        ensConfirmationVC.coinDetail = self.coinDetail
        ensConfirmationVC.tokenAmount = filteredList[sender.tag].tx?.params?.value ?? ""
        ensConfirmationVC.tokentype = coinDetail?.symbol ?? ""
        ensConfirmationVC.tokenPrice = cell?.lblPrice.text ?? ""
        ensConfirmationVC.fromAddress = self.coinDetail?.chain?.walletAddress ?? ""
        ensConfirmationVC.toAddress = filteredList[sender.tag].tx?.params?.to ?? ""
        ensConfirmationVC.delegate = self
        ensConfirmationVC.modalTransitionStyle = .crossDissolve
        ensConfirmationVC.modalPresentationStyle = .overFullScreen
        self.present(ensConfirmationVC, animated: true, completion: nil)
       // self.navigationController?.pushViewController(ensConfirmationVC, animated: true)
    }
    
    func hexStringToBigInt(_ hexString: String) -> BigInt? {
        // Ensure the hex string is not empty
        guard !hexString.isEmpty else {
            return nil
        }

        // Remove any "0x" prefix if present
        var cleanedHexString = hexString
        if cleanedHexString.hasPrefix("0x") {
            cleanedHexString = String(cleanedHexString.dropFirst(2))
        }

        // Convert the cleaned hex string to a BigInt
        return BigInt(cleanedHexString, radix: 16)
    }
    
}
extension ENSViewController : ConfirmEnsBuyDelegate {
    func confirmEnsBuy() {
        DispatchQueue.main.async {
           
           // self.ensApproveTranscation(amount: "0.000001", gasLimit: "0", gasPrice: "0", approveTo: receiverAddress, txTo: receiverAddress, txData: txData, txValue: txValue)
            self.ensSendTranscation(receiverAddress: self.receiverAddress, txData: self.txData, gas: "0", gasPrice: "0", txValue: self.txValue)
       }
    }
}

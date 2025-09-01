//
//  MyTokenViewController+TableviewDataSource.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/05/24.
//

import UIKit
import SDWebImage
// MARK: - UITableViewDelegate methods
extension MyTokenViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        let cell = tbvCards.cellForRow(at: indexPath) as? MyTokenTableViewCell
        if isFrom == "topupVC" || isFrom == "payment" || isFrom == "sendCardWallet" || isFrom == "buyCrypto" || self.isFrom == "withdrawCrypto" {
            let data = arrWalletList[indexPath.row]
            var amount = ""
            if let price = data.fiat?.amount {
                let priceValue: Double = {
                    switch price {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                amount = "\(priceValue) \(data.fiat?.customerCurrency ?? "")"
            } else {
                amount = "0"
            }
            self.dismiss(animated: true) {
                self.delegate?.selectedToken(tokenName: data.currency ?? "", tokenimage: data.iconUrl ?? "", tokenbalance: data.balanceString ?? "", tokenAmount: WalletData.shared.formatDecimalString(amount, decimalPlaces: 3), tokenCurruncy: data.fiat?.customerCurrency ?? "", tokenArr: self.arrWalletList[indexPath.row],currency: data.currency ?? "",isFromToken1: "")
            }
        } else if self.isFrom == "exchnageCrypto" {
            let data = arrWalletList[indexPath.row]
            var amount = ""
            if let price = data.fiat?.amount {
                let priceValue: Double = {
                    switch price {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                amount = "\(priceValue) \(data.fiat?.customerCurrency ?? "")"
            } else {
                amount = "0"
            }
            
            if self.isFromToken1 == true {
                self.dismiss(animated: true) {
                    self.delegate?.selectedToken(tokenName: data.currency ?? "", tokenimage: data.iconUrl ?? "", tokenbalance: data.balanceString ?? "", tokenAmount: WalletData.shared.formatDecimalString(amount, decimalPlaces: 3), tokenCurruncy: data.fiat?.customerCurrency ?? "", tokenArr: data,currency: data.currency ?? "",isFromToken1: "true")
                }
            } else {
                self.dismiss(animated: true) {
                    self.delegate?.selectedToken(tokenName: data.currency ?? "", tokenimage: data.iconUrl ?? "", tokenbalance: data.balanceString ?? "", tokenAmount: WalletData.shared.formatDecimalString(amount, decimalPlaces: 3), tokenCurruncy: data.fiat?.customerCurrency ?? "", tokenArr: data,currency: data.currency ?? "",isFromToken1: "false")
                }
            }
        } else if self.isFrom == "receive" {
            let data = arrWalletList[indexPath.row]
            var amount = ""
            if let price = data.fiat?.amount {
                let priceValue: Double = {
                    switch price {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                amount = "\(priceValue) \(data.fiat?.customerCurrency ?? "")"
            } else {
                amount = "0"
            }
            self.dismiss(animated: true) {
                self.delegate?.selectedToken(tokenName: data.currency ?? "", tokenimage: data.iconUrl ?? "", tokenbalance: data.balanceString ?? "", tokenAmount: WalletData.shared.formatDecimalString(amount, decimalPlaces: 3), tokenCurruncy: data.baseCurrency ?? "", tokenArr: self.arrWalletList[indexPath.row],currency: data.currency ?? "",isFromToken1: "")
            }
        }
        else {
            let tokenDashboardVC = TokenDashboardViewController()
            tokenDashboardVC.arrWallet =  self.arrWalletList[indexPath.row]
            self.navigationController?.pushViewController(tokenDashboardVC, animated: true)
        }
    }
}
// MARK: - UITableViewDataSource methods
extension MyTokenViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return self.arrWalletList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvCards.dequeueReusableCell(indexPath: indexPath) as MyTokenTableViewCell
        let data = arrWalletList[indexPath.row]
        cell.btnTopup.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.addFunds, comment: ""), for: .normal)
        cell.selectionStyle = .none
        tableView.separatorStyle = .singleLine
        if self.isFrom == "topupVC" || self.isFrom == "payment" || self.isFrom == "sendCardWallet" || self.isFrom == "receive" || self.isFrom == "buyCrypto" || self.isFrom == "exchnageCrypto" || self.isFrom == "withdrawCrypto" {
            cell.btnTopup.isHidden = true
        } else {
            cell.btnTopup.isHidden = false
        }
        if let price = data.fiat?.amount {
            let priceValue: Double = {
                switch price {
                case .int(let value):
                    return Double(value)
                case .double(let value):
                    return value
                }
            }()
            cell.lblTokkenAddress.text = "\(priceValue) \(data.fiat?.customerCurrency ?? "")"
        } else {
            cell.lblTokkenAddress.text = "0"
        }
        cell.lblToken.text = "\(data.balanceString ?? "") \(data.currency ?? "")"
       // let server = serverTypes
//        if server == .live {
            cell.ivToken.sd_setImage(with: URL(string: "\(data.iconUrl ?? "")"), placeholderImage: UIImage.icBank)
//        } else {
//            cell.ivToken.sd_setImage(with: URL(string: "\(data.image ?? "")"), placeholderImage: UIImage.icBank)
//        }
        cell.btnTopup.tag = indexPath.row
        cell.btnTopup.isUserInteractionEnabled = true
        cell.btnTopup.addTarget(self, action: #selector(addFund(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func addFund(_ sender:UIButton) {
        let addFundsVC =  AddCardFundViewController()
        addFundsVC.arrWallet = self.arrWalletList[sender.tag]
        addFundsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addFundsVC, animated: true)
        
    }
    
}

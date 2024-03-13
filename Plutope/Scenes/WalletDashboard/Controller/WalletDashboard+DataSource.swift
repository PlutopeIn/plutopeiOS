//
//  WalletDashboard+DataSource.swift
//  Plutope
//
//  Created by Priyanka on 11/06/23.
//

import UIKit
import SDWebImage
import Foundation
import CoreData
// MARK: Table view delegate method
extension WalletDashboardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chainTokenList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvAssets.dequeueReusableCell(indexPath: indexPath) as PurchasedCoinViewCell
        cell.selectionStyle = .none

        if let data = chainTokenList?[indexPath.row] {

            /// Set coin image
            if data.isUserAdded == false {
                let logoURI = data.logoURI ?? ""
                cell.ivCoin.sd_setImage(with: URL(string: logoURI))
            } else {
                cell.ivCoin.image = data.chain?.chainDefaultImage
            }
            cell.lblYourTokens.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.yourtokens, comment: "")
            cell.lblCoinName.text = data.symbol
            cell.lblSymbol.text = data.type
            let formattedString = WalletData.shared.formatDecimalString("\(data.price ?? "0")", decimalPlaces: 10)
            let curruncy = primaryCurrency?.sign ?? ""
            cell.coinPrice.text = data.isUserAdded ? "" : "\(curruncy) \(formattedString)"

            let balance = Double(data.balance ?? "") ?? 0.0
            let formattedStringv = WalletData.shared.formatDecimalString("\(balance)", decimalPlaces: 7)

                // coin quntity
                cell.coinQuantity.text = "\(formattedStringv) \(data.symbol ?? "")"

            let amout = balance * (Double(data.price ?? "") ?? 0.0)

            let formattedValue = WalletData.shared.formatDecimalString("\(amout)", decimalPlaces: 2)

            // coin amount
            cell.coinAmount.text = "\(primaryCurrency?.sign ?? "") \(formattedValue)"

            let priceChangeImpact = Double(data.lastPriceChangeImpact ?? "") ?? 0.0
            let priceChangeImpactTruncatedValue = WalletData.shared.formatDecimalString("\(priceChangeImpact)", decimalPlaces: 10)
          //  let priceChangeImpactTruncatedValue = String(format: "%.2f", floor(priceChangeImpact * 100) / 100)
            if data.isUserAdded {
                cell.lblPer.text  = ""
            } else {
                if priceChangeImpact > 0 {
                    cell.lblPer.text = "+\(priceChangeImpactTruncatedValue)%"
                } else {
                    cell.lblPer.text = "\(priceChangeImpactTruncatedValue)%"
                }
            }
           // cell.lblPer.text = data.isUserAdded ? "" : "\(priceChangeImpactTruncatedValue)"
            cell.lblPer.textColor = priceChangeImpact >= 0 ? UIColor.c099817 : .red

        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let outerView = UIView(frame: CGRect(x: 0, y: 100, width: screenWidth - 32, height: 160))
        
        let view = UIView(frame: CGRect(x: 0, y: 11, width: screenWidth - 32, height: 45))
        let image = UIImageView(frame: CGRect(x: 17, y: 14, width: 17, height: 17))
        let text = UILabel(frame: CGRect(x: 43, y: 16, width: 50, height: 13))
        let buttonWidth: CGFloat = 230
        let buttonX = (outerView.frame.width - buttonWidth) / 2
        let button = GradientButton(frame: CGRect(x: buttonX, y: view.frame.maxY + 10, width: buttonWidth, height: 50))
        
        text.font = AppFont.regular(10).value
        text.textColor = UIColor.c75769D
        
        // Set the text based on the localized string
        text.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.search, comment: "")
        
        view.backgroundColor = UIColor.c25264D
        view.RoundMe(Radius: 22.5)
        image.image = UIImage.icSearch
        view.addSubview(image)
        view.addSubview(text)
        view.addTapGesture(target: self, action: #selector(tappedView))
        button.topGradientColor = UIColor.c121C3D
        button.bottomGradientColor = UIColor.c00C6FB
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.exploreNewToken, comment: ""), for: .normal)
        button.addTarget(self, action: #selector(exploreNewTapped(_:)), for: .touchUpInside)
        button.titleLabel?.font =  AppFont.bold(14).value
        button.RoundMe(Radius: 25)
        outerView.backgroundColor = .clear
        
        // Check if the language is RTL and apply a horizontal flip if needed
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            outerView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        outerView.addSubview(view)
       // outerView.addSubview(button)
        
        return outerView
    }
    @objc func exploreNewTapped(_ sender : UIButton) {
        DGProgressView.shared.showLoader(to: self.view)
        viewModel.apiGetActiveTokens(walletAddress: WalletData.shared.myWallet?.address ?? "") { data, status in
            self.activeToken = data
            self.activeTokenList()
        }
    }
    fileprivate func activeTokenList() {
        
        self.tokenList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
        if let tokensList = self.tokenList, let activeTokens = self.activeToken {
            for enableToken in activeTokens {
                
                let token1 =  tokensList.first(where: { $0.address == enableToken.tokenAddress })
                if(token1 == nil) {
                    print("nil")
                } else {
                let getPrimaryWalletToken = DatabaseHelper.shared.fetchTokens(withWalletID: self.primaryWallet?.wallet_id?.uuidString ?? "")
                let enableTokens = getPrimaryWalletToken?.compactMap { $0.tokens  }
                let alreadyEnabled = enableTokens?.first(where: { $0.address == enableToken.tokenAddress })
                if(alreadyEnabled == nil ) {
                    
                    let entity = NSEntityDescription.entity(forEntityName: "WalletTokens", in: DatabaseHelper.shared.context)!
                    let walletTokenEntity = WalletTokens(entity: entity, insertInto: DatabaseHelper.shared.context)
                    walletTokenEntity.id = UUID()
                    walletTokenEntity.wallet_id = self.primaryWallet?.wallet_id
                    walletTokenEntity.tokens = token1
                    DatabaseHelper.shared.saveData(walletTokenEntity) { status in
                        if status {
                            print("true")
                            self.selectEnabledToken(token1!)
                        }
                    }
                }
            }// else
            }
            getChainList()
        }
        DGProgressView.shared.hideLoader()
       
    }
    @objc func tappedView() {
        let vcToPresent = CoinListViewController()
        vcToPresent.modalTransitionStyle = .coverVertical
        vcToPresent.modalPresentationStyle = .pageSheet
        vcToPresent.enabledTokenDelegate = self
        vcToPresent.primaryWallet = self.primaryWallet
        vcToPresent.isFromDash = true
        self.present(vcToPresent, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 110
    }
}

// MARK: Collection view delegate method
extension WalletDashboardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrNftData?.count ?? 0
     } 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clvNFTs.dequeueReusableCell(indexPath: indexPath) as NFTsViewCell
        let data = arrNftData?[indexPath.row]
        
        let jsonString = data?.metadata
        if jsonString != "" || jsonString != nil {
            if let jsonData = jsonString?.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                       let imageUrlString = json["image"] as? String,
                       let nftName = json["name"] as? String,
                       let description = json["description"] as? String,
                       let imageUrl = URL(string: imageUrlString) {
                        cell.ivNFT.sd_setImage(with: imageUrl)
                        cell.lblNftName.text = nftName
                        cell.nftDescription = description
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
        
        return cell
     } 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: clvNFTs.frame.width / 2, height: 180)
    }
    
 } 

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
//        tableView.separatorStyle = .singleLine
        cell.selectionStyle = .none
        if let data = chainTokenList?[indexPath.row] {
            cell.ivCoin.RoundMe(Radius: cell.ivCoin.frame.height / 2 )
            /// Set coin image
            if data.isUserAdded == false {
//                let logoURI = data.logoURI ?? ""
//                let chainImage = data.chain?.icon ?? ""
//                if data.tokenId == "PLT".lowercased() {
//                    if logoURI == "" {
//                    cell.ivCoin.sd_setImage(with: URL(string: "https://plutope.app/api/images/applogo.png"))
//                    } else {
//                        cell.ivCoin.sd_setImage(with: URL(string: logoURI))
//                    }
//                } else {
//                    cell.ivCoin.sd_setImage(with: URL(string: logoURI))
//                }
                let logoURI = data.logoURI ?? ""
                let chainImage = data.chain?.icon ?? ""
             //   print(chainImage)
                let defaultPLTImage = "https://plutope.app/api/images/applogo.png"

                if data.tokenId?.lowercased() == "plt" {
                    let imageURL = defaultPLTImage
                    cell.ivCoin.sd_setImage(with: URL(string: imageURL))
                } else {
                    let imageURL = logoURI.isEmpty ? chainImage : logoURI
                    cell.ivCoin.sd_setImage(with: URL(string: imageURL))
                }
            } else {
                cell.ivCoin.image = data.chain?.chainDefaultImage
            }

            cell.lblCoinName.text = data.symbol
            cell.lblSymbol.text = data.type
            let formattedString = WalletData.shared.formatDecimalString("\(data.price ?? "0")", decimalPlaces: 10)
            let curruncy = primaryCurrency?.sign ?? ""
            cell.coinPrice.text = data.isUserAdded ? "" : "\(curruncy) \(formattedString)"

            let balance = Double(data.balance ?? "") ?? 0.0
           // print("datatype = ",data.type,balance)
           
            if balance == 0.0 {
                cell.coinAmount.isHidden = true
            } else {
                cell.coinAmount.isHidden = false
            }
            let formattedStringv = WalletData.shared.formatDecimalString("\(balance)", decimalPlaces: 7)

                // coin quntity
                var coinQnt = "\(formattedStringv) \(data.symbol ?? "")"
            
            let amout = balance * (Double(data.price ?? "") ?? 0.0)

            let formattedValue = WalletData.shared.formatDecimalString("\(amout)", decimalPlaces: 2)

            // coin amount
            var coinAmt = "\(primaryCurrency?.sign ?? "") \(formattedValue)"
            
            if !self.isHideShow {
                cell.coinQuantity.text = "\(formattedStringv) \(data.symbol ?? "")"
                cell.coinAmount.text = "\(primaryCurrency?.sign ?? "") \(formattedValue)"
            } else {
                cell.coinQuantity.text = String(repeating: "*", count: coinQnt.count)
                cell.coinAmount.text = String(repeating: "*", count: coinAmt.count)
            }
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
            cell.coinAmount.textColor = priceChangeImpact >= 0 ? UIColor.c099817 : .red
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
        return 56
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
        text.textColor = UIColor.label
        
        // Set the text based on the localized string
        text.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.search, comment: "")
        
//        view.backgroundColor = UIColor.c25264D
        view.backgroundColor = UIColor.secondarySystemFill
        view.RoundMe(Radius: 22.5)
        image.image = UIImage.icSearch
        image.imageTintColor = UIColor.label
        view.addSubview(image)
        view.addSubview(text)
        view.addTapGesture(target: self, action: #selector(tappedView))
//        button.topGradientColor = UIColor.c121C3D
//        button.bottomGradientColor = UIColor.c00C6FB
        button.setTitleColor(UIColor.systemBackground, for: .normal)
        button.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.exploreNewToken, comment: ""), for: .normal)
        button.addTarget(self, action: #selector(exploreNewTapped(_:)), for: .touchUpInside)
        button.titleLabel?.font = AppFont.regular(14).value
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
//        DGProgressView.shared.showLoader(to: self.view)
        loader.startAnimating()
        viewModel.apiGetActiveTokens(walletAddress: WalletData.shared.myWallet?.address ?? "") { data, status in
            self.activeToken = data
            self.activeTokenList()
        }
    }
    func exploreNewTokens() {
        
//        DGProgressView.shared.showLoader(to: self.view)
        loader.startAnimating()
        viewModel.apiGetActiveTokens(walletAddress: WalletData.shared.myWallet?.address ?? "") { data, status in
            self.activeToken = data
//            self.loader.stopAnimating()
            self.activeTokenList()
        }
    }
    func activeTokenList() {
//        tbvAssets.reloadData()
//        tbvAssets.restore()
        
        self.tokenList = (DatabaseHelper.shared.retrieveData("Token") as? [Token])?
            .sorted { ($0.name?.lowercased() ?? "") < ($1.name?.lowercased() ?? "") }

        if let tokensList = self.tokenList, let activeTokens = self.activeToken {
            for enableToken in activeTokens {
                guard let token1 = tokensList.first(where: { $0.address == enableToken.tokenAddress }) else {
                    print("nil")
                    continue
                }

                let getPrimaryWalletToken = DatabaseHelper.shared.fetchTokens(withWalletID: self.primaryWallet?.wallet_id?.uuidString ?? "")
                let enableTokens = getPrimaryWalletToken?
                    .compactMap { $0.tokens }
                    .flatMap { $0 }
                    .sorted { ($0.name?.lowercased() ?? "") < ($1.name?.lowercased() ?? "") }

                let alreadyEnabled = enableTokens?.first(where: { $0.address == enableToken.tokenAddress })
                if alreadyEnabled == nil {
                    let entity = NSEntityDescription.entity(forEntityName: "WalletTokens", in: DatabaseHelper.shared.context)!
                    let walletTokenEntity = WalletTokens(entity: entity, insertInto: DatabaseHelper.shared.context)
                    walletTokenEntity.id = UUID()
                    walletTokenEntity.wallet_id = self.primaryWallet?.wallet_id
                    walletTokenEntity.tokens = token1
                    DatabaseHelper.shared.saveData(walletTokenEntity) { status in
                        if status {
                            print("true")
                            self.selectEnabledToken(token1)
                        }
                    }
                }
            }
        }

        getChainList()
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                // Simulated network delay
                DispatchQueue.main.async {
                    self.loader.stopAnimating()
//                    self.self.tbvAssets.hideLoader()
                    self.tbvAssets.reloadData()
                    self.tbvAssets.restore()
                }
            }
    }


    @objc func tappedView() {
        HapticFeedback.generate(.light)
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
            tbvHeight.constant = tbvAssets.contentSize.height
        }
}

// MARK: Collection view delegate method
extension WalletDashboardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clvNFTs {
            return arrNftDataNew?.count ?? 0
        } else {
            return transctionsValueArr.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == clvNFTs {
            let cell = clvNFTs.dequeueReusableCell(indexPath: indexPath) as NFTsViewCell
            let data = arrNftDataNew?[indexPath.row]
            cell.lblNftName.font = AppFont.regular(9.76).value
          //  let jsonString = data?.metadata
//            if jsonString != "" || jsonString != nil {
//                if let jsonData = jsonString?.data(using: .utf8) {
//                    do {
//                        if let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
//                           let imageUrlString = json["image"] as? String,
//                           let nftName = json["name"] as? String,
//                           let description = json["description"] as? String,
//                           let imageUrl = URL(string: imageUrlString) {
//                            cell.ivNFT.sd_setImage(with: imageUrl)
//                            cell.lblNftName.text = nftName
//                            cell.nftDescription = description
//                        }
//                    } catch {
//                        print("Error parsing JSON: \(error)")
//                    }
//                }
//            }
            let imageUrlString = data?.metadata?.image ?? ""
            let imageUrl = URL(string: imageUrlString)
            cell.ivNFT.sd_setImage(with: imageUrl)
            cell.lblNftName.text = data?.metadata?.name
            cell.nftDescription = data?.metadata?.description ?? ""
            return cell
        } else {
            let cell = clvActions.dequeueReusableCell(indexPath: indexPath) as WalletDashboardCell
            let data = transctionsValueArr[indexPath.row]
            cell.ivIcon.image = data.image
            cell.lblName.text = data.name
            cell.lblName.font = AppFont.regular(13.8).value
            
            return cell
        }
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == clvNFTs {
            return CGSize(width: clvNFTs.frame.width / 2, height: 180)
        } else {
            return CGSize(width: (screenWidth - 40) / 5, height: 63)
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == clvNFTs {
            self.view.layoutIfNeeded()
            clvNftHeight.constant = clvNFTs.contentSize.height
        }
    }
    
 } 

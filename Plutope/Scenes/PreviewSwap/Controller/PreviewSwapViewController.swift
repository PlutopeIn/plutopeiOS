//
//  PreviewSwapViewController.swift
//  Plutope
//
//  Created by Mitali Desai on 24/08/23.
//

import UIKit

protocol ConfirmSwapDelegate : AnyObject {
    func confirmSwap()
}

class PreviewSwapViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblProviderFee: UILabel!
    @IBOutlet weak var lblNetworkFee: UILabel!
    @IBOutlet weak var lblNetworkFeeText: UILabel!
    @IBOutlet weak var lblSlippage: UILabel!
    @IBOutlet weak var lblSlippageText: UILabel!
    @IBOutlet weak var lblQoute: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblFromText: UILabel!
    @IBOutlet weak var lblGetCoinType: UILabel!
    @IBOutlet weak var lblGetCoinAmount: UILabel!
    @IBOutlet weak var lblPayCoinType: UILabel!
    @IBOutlet weak var lblPayCoinAmount: UILabel!
    @IBOutlet weak var ivGetCoin: UIImageView!
    @IBOutlet weak var ivPayCoin: UIImageView!
    @IBOutlet weak var btnConfirmSwap: UIButton!
    
    var swapQouteDetail: [Routers] = []
    var previewSwapDetail: PreviewSwap?
    weak var delegate: ConfirmSwapDelegate?
    var isFrom = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        /// Navigation Header
       
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.swap, comment: ""))
        
        self.lblFromText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")
        self.lblNetworkFeeText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.networkfee, comment: "")
        self.lblSlippageText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.maxslipage, comment: "")
        self.btnConfirmSwap.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirmswap, comment: ""), for: .normal)
        
        /// setSwapDetail
        setSwapDetail()
    }
    
    private func setSwapDetail() {
        guard let swapData = swapQouteDetail.first else {
            return
        }
        
        lblPayCoinAmount.text = "\(previewSwapDetail?.payAmount ?? "") \(previewSwapDetail?.payCoinDetail?.symbol ?? "")"
        ivPayCoin.sd_setImage(with: URL(string: previewSwapDetail?.payCoinDetail?.logoURI ?? ""))
        
        lblGetCoinAmount.text = "\(previewSwapDetail?.getAmount ?? "") \(previewSwapDetail?.getCoinDetail?.symbol ?? "")"
        ivGetCoin.sd_setImage(with: URL(string: previewSwapDetail?.getCoinDetail?.logoURI ?? ""))
        lblPayCoinType.text = self.previewSwapDetail?.payCoinDetail?.type ?? ""
        lblGetCoinType.text = self.previewSwapDetail?.getCoinDetail?.type ?? ""
        
        if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
            let allCoin = allToken.filter{ $0.address == "" && $0.type == self.previewSwapDetail?.payCoinDetail?.type && $0.symbol == self.previewSwapDetail?.payCoinDetail?.chain?.symbol ?? "" }
            let fee = (Int(swapData.tx?.gas ?? "") ?? 0) * (Int(swapData.tx?.gasPrice ?? "") ?? 0)
            let convertedValue = UnitConverter.convertWeiToEther(String(fee),previewSwapDetail?.payCoinDetail?.chain?.decimals ?? 0) ?? ""
            let gasPrice = ((Double(convertedValue) ?? 0.0) * (Double(allCoin.first?.price ?? "") ?? 0.0))
            let estimateValue = WalletData.shared.formatDecimalString("\(gasPrice)", decimalPlaces: 2)
            lblNetworkFee.text = "\(convertedValue) \(previewSwapDetail?.payCoinDetail?.chain?.symbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(estimateValue))"
        }
        lblFrom.text = previewSwapDetail?.payCoinDetail?.chain?.walletAddress ?? ""
        lblQoute.text = previewSwapDetail?.quote
        lblSlippage.text = "0.1%"
    }
    @IBAction func btnConfirmSwapAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.confirmSwap()
//            guard let sceneDelegate = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? SceneDelegate else { return }
//            guard let viewController = sceneDelegate.window?.rootViewController else { return }
//            AppPasscodeHelper().handleAppPasscodeIfNeeded(in: viewController, completion: { status in
//                if status {
//                    self.delegate?.confirmSwap()
//                }
//            })
        }
    }
}

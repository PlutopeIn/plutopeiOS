//
//  SettingPreviewViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 31/10/23.
//

import UIKit
import Web3
protocol SettingsViewControllerDelegate: AnyObject {
    //   func settingsViewControllerDidClose(_ viewController: UIViewController,gaslimit:String,nonce:String,gasPrice:String,isFromSettings:Bool,networkFee:String)
    func getNetworkFee(gaslimit:String,nonce:String,gasPrice:String,isFromSettings:Bool,networkFee:String,gasAmount:String)
    
    func selectedValue(isSelectedLow:Bool,isSelectedMarket:Bool,isSelectedAggressive:Bool)
}
class SettingPreviewViewController: UIViewController {
    @IBOutlet weak var btnSave: GradientButton!
    @IBOutlet weak var btnPlusPrice: UIButton!
    @IBOutlet weak var btnMinusPrice: UIButton!
    @IBOutlet weak var lblAdvancedoptions: UILabel!
    @IBOutlet weak var btnMinusLimit: UIButton!
    @IBOutlet weak var btnPlusLimit: UIButton!
    
    @IBOutlet weak var lblMaxFee: UILabel!
    @IBOutlet weak var lblNetworkFee: UILabel!
    @IBOutlet weak var ivArrow: UIImageView!
    @IBOutlet weak var stackAdvance: UIStackView!
    @IBOutlet weak var txtGasFee: customTextField!
    
    @IBOutlet weak var stackOptions: UIStackView!
    @IBOutlet weak var lblGasFee: UILabel!
    @IBOutlet weak var lblGasPrice: UILabel!
    @IBOutlet weak var viewLowToMarket: UIView!
    @IBOutlet weak var viewMarketToAggressive: UIView!
    @IBOutlet weak var ivAggressive: UIImageView!
    @IBOutlet weak var ivMarket: UIImageView!
    @IBOutlet weak var ivLow: UIImageView!
    @IBOutlet weak var lblMarket: UILabel!
    @IBOutlet weak var lblAggressive: UILabel!
    @IBOutlet weak var txtNounce: customTextField!
    @IBOutlet weak var lblLow: UILabel!
    @IBOutlet weak var txtTransactionData: customTextField!
    @IBOutlet weak var txtGasLimit: customTextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblNonce: UILabel!
    
    weak var delegate: SettingsViewControllerDelegate?
    var gasPrice = ""
    var gasLimit = ""
    var nonce = ""
    var coinDetail : Token?
    var tokenAmount = ""
    var tokentype = ""
    var tokenPrice = ""
    var assets = ""
    var fromAddress = ""
    var toAddress = ""
    var networkFee = ""
    var maxTotal = ""
    var gasfee = ""
    var stringWithoutPrefix = ""
    var primaryCurrency = ""
    var calculatedGasPrice = 0.0
    var gasAmount = ""
    var isDown = false
    var gasLimitForAddition = 0
    var gasPriceForAddition = 0
    var fromAddressType: UInt32 = 0
    var toBtcWalletAddres = false
    var isSelectedIvLow = false
    var isSelectedIvMarket = false
    var isSelectedIvAggressive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.editPriority, comment: ""), btnBackAction: {
            // self.delegate?.settingsViewControllerDidClose(self,gaslimit: "",nonce: "",gasPrice: "", isFromSettings: false)
            self.dismiss(animated: true) {
                self.delegate?.selectedValue(isSelectedLow: self.isSelectedIvLow, isSelectedMarket: self.isSelectedIvMarket, isSelectedAggressive: self.isSelectedIvAggressive)
            }
        })
        getGasFee()
        gasLimitForAddition = Int(self.gasLimit) ?? 0
      
        ivLow.addTapGesture {
            self.isSelectedIvLow = true
            self.isSelectedIvMarket = false
            self.isSelectedIvAggressive = false
            self.ivLow.image = UIImage.icCheckedRadio
            self.viewLowToMarket.backgroundColor = UIColor.c75769D
            self.ivMarket.image = UIImage.icUnCheckedRadio
            self.viewMarketToAggressive.backgroundColor = UIColor.c75769D
            self.ivAggressive.image = UIImage.icUnCheckedRadio
            
            let calculationResult = self.performPercentageCalculation(fee: Double(self.gasLimit) ?? 0.0, percentage: 0.1)
            self.txtGasLimit.text = "\(calculationResult)"
            self.getValueFromAdvance(self.txtGasFee.text ?? "", self.txtGasLimit.text ?? "", self.txtNounce.text ?? "")
            
        }
        ivMarket.addTapGesture {
            self.isSelectedIvLow = false
            self.isSelectedIvMarket = true
            self.isSelectedIvAggressive = false
            self.ivMarket.image = UIImage.icCheckedRadio
            self.viewLowToMarket.backgroundColor = UIColor.white
            self.ivLow.image = UIImage.icUnCheckedRadio
            self.viewMarketToAggressive.backgroundColor = UIColor.c75769D
            self.ivAggressive.image = UIImage.icUnCheckedRadio
           
            let calculationResult = self.performPercentageCalculation(fee: Double(self.gasLimit) ?? 0.0, percentage: 0.5)
            self.txtGasLimit.text = "\(calculationResult)"
            self.getValueFromAdvance(self.txtGasFee.text ?? "", self.txtGasLimit.text ?? "", self.txtNounce.text ?? "")
        }
        ivAggressive.addTapGesture {
            self.isSelectedIvLow = false
            self.isSelectedIvMarket = false
            self.isSelectedIvAggressive = true
            self.ivAggressive.image = UIImage.icCheckedRadio
            self.viewLowToMarket.backgroundColor = UIColor.white
            self.ivLow.image = UIImage.icUnCheckedRadio
            self.viewMarketToAggressive.backgroundColor = UIColor.white
            self.ivMarket.image = UIImage.icUnCheckedRadio
            
            let calculationResult = self.performPercentageCalculation(fee: Double(self.gasLimit) ?? 0.0, percentage: 1.0)
            self.txtGasLimit.text = "\(calculationResult)"
            self.getValueFromAdvance(self.txtGasFee.text ?? "", self.txtGasLimit.text ?? "", self.txtNounce.text ?? "")
        }
        stackAdvance.addTapGesture {
            self.toggleOptionsVisibility()
        }
        
    }
    func toggleOptionsVisibility() {
        if self.isDown {
            self.ivArrow.image = UIImage(systemName: "chevron.up")
            self.stackOptions.isHidden = false
        } else {
            
            self.ivArrow.image = UIImage(systemName: "chevron.down")
            self.stackOptions.isHidden = true
        }
        self.isDown.toggle()
    }
    func performPercentageCalculation(fee: Double, percentage: Double) -> Int {
        let result = fee + (fee * percentage / 100.0)
        return Int(result)
    }
    
    fileprivate func buttonSelectionAction() {
        if isSelectedIvLow {
            
            self.ivLow.image = UIImage.icCheckedRadio
            self.viewLowToMarket.backgroundColor = UIColor.c75769D
            self.ivMarket.image = UIImage.icUnCheckedRadio
            self.viewMarketToAggressive.backgroundColor = UIColor.c75769D
            self.ivAggressive.image = UIImage.icUnCheckedRadio
            
            let calculationResult = self.performPercentageCalculation(fee: Double(self.gasLimit) ?? 0.0, percentage: 0.1)
            self.txtGasLimit.text = "\(calculationResult)"
            self.getValueFromAdvance(self.txtGasFee.text ?? "", self.txtGasLimit.text ?? "", self.txtNounce.text ?? "")
        } else if isSelectedIvAggressive {
            
            self.ivAggressive.image = UIImage.icCheckedRadio
            self.viewLowToMarket.backgroundColor = UIColor.white
            self.ivLow.image = UIImage.icUnCheckedRadio
            self.viewMarketToAggressive.backgroundColor = UIColor.white
            self.ivMarket.image = UIImage.icUnCheckedRadio
            
            let calculationResult = self.performPercentageCalculation(fee: Double(self.gasLimit) ?? 0.0, percentage: 1.0)
            self.txtGasLimit.text = "\(calculationResult)"
            self.getValueFromAdvance(self.txtGasFee.text ?? "", self.txtGasLimit.text ?? "", self.txtNounce.text ?? "")
        } else {
            
            self.ivMarket.image = UIImage.icCheckedRadio
            self.viewLowToMarket.backgroundColor = UIColor.white
            self.ivLow.image = UIImage.icUnCheckedRadio
            self.viewMarketToAggressive.backgroundColor = UIColor.c75769D
            self.ivAggressive.image = UIImage.icUnCheckedRadio
            
            let calculationResult = self.performPercentageCalculation(fee: Double(self.gasLimit) ?? 0.0, percentage: 0.5)
            self.txtGasLimit.text = "\(calculationResult)"
            self.getValueFromAdvance(self.txtGasFee.text ?? "", self.txtGasLimit.text ?? "", self.txtNounce.text ?? "")
        }
    }
    
    fileprivate func uiSetUp() {
        self.lblNonce.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.nonce, comment: "")
        self.lblGasFee.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.gasLimit, comment: "")
        self.lblGasPrice.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.gasPrice, comment: "")
        self.lblAdvancedoptions.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.advance, comment: "")
        btnSave.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.save, comment: ""), for: .normal)
        let price = BigInt(self.gasPrice) ?? 0
        let gasPriceValue = UnitConverter.weiToGwei(price)
        gasPriceForAddition = Int(gasPriceValue)

        txtGasFee.text = "\(gasPriceValue)"
        txtGasLimit.text = self.gasLimit
        txtNounce.text = self.nonce
        //ivMarket.image = UIImage.icCheckedRadio
        let textFields = [txtNounce, txtGasFee, txtGasLimit]

        for textField in textFields {
            textField?.delegate = self
        }
        
        buttonSelectionAction()
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
          
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                self.txtNounce.textAlignment = .right
                self.txtGasFee.textAlignment = .right
                self.txtGasLimit.textAlignment = .right
              //  txtTransactionData.textAlignment = .right
            } else {
                self.txtNounce.textAlignment = .left
                self.txtGasFee.textAlignment = .left
                self.txtGasLimit.textAlignment = .left
               // txtTransactionData.textAlignment = .left
            }
            self.uiSetUp()
        }
    }
    // Button save Action
    @IBAction func btnSaveAction(_ sender: Any) {
       
         self.dismiss(animated: true) {
             
            self.delegate?.getNetworkFee( gaslimit: self.txtGasLimit.text ?? "", nonce: self.txtNounce.text ?? "", gasPrice: self.txtGasFee.text ?? "", isFromSettings: true, networkFee: self.lblNetworkFee.text ?? "",gasAmount: "\(self.calculatedGasPrice)")
             
             self.delegate?.selectedValue(isSelectedLow: self.isSelectedIvLow, isSelectedMarket: self.isSelectedIvMarket, isSelectedAggressive: self.isSelectedIvAggressive)
        }

    }
    // Increase the gasPriceForAddition by 1
    @IBAction func btnGasPricePluseAction(_ sender: UIButton) {
        disableImages()
        
            if let currentGasPrice = Int(txtGasFee.text ?? "") {
                gasPriceForAddition = currentGasPrice + 1
                txtGasFee.text = "\(gasPriceForAddition)"
                self.getValueFromAdvance(txtGasFee.text ?? "", txtGasLimit.text ?? "", txtNounce.text ?? "")
            } else {
                print("Invalid gas limit value in the text field")
            }
    }
    // Decrease the gasPriceForAddition by 1
    @IBAction func btnGasPriceMinusAction(_ sender: UIButton) {
        disableImages()
           if let currentGasLimit = Int(txtGasFee.text ?? "") {
               gasPriceForAddition = max(0, currentGasLimit - 1)
               txtGasFee.text = "\(gasPriceForAddition)"
               self.getValueFromAdvance(txtGasFee.text ?? "", txtGasLimit.text ?? "", txtNounce.text ?? "")
           } else {
               print("Invalid gas limit value in the text field")
           }
        
    }
    func disableImages() {
        self.ivLow.image = UIImage.icUnCheckedRadio
        self.ivMarket.image = UIImage.icUnCheckedRadio
        self.ivAggressive.image = UIImage.icUnCheckedRadio
        self.viewLowToMarket.backgroundColor = UIColor.c75769D
        self.viewMarketToAggressive.backgroundColor = UIColor.c75769D
        self.isSelectedIvLow = false
        self.isSelectedIvMarket = false
        self.isSelectedIvAggressive = false
    }
    // Increase the gasLimitForAddition by 1000
    @IBAction func btnGasLimitPluseAction(_ sender: UIButton) {
        disableImages()
            if let currentGasLimit = Int(txtGasLimit.text ?? "") {
                gasLimitForAddition = currentGasLimit + 1000
                txtGasLimit.text = "\(gasLimitForAddition)"
                self.getValueFromAdvance(txtGasFee.text ?? "", txtGasLimit.text ?? "", txtNounce.text ?? "")
            } else {
               print("Invalid gas limit value in the text field")
            }
        
    }
    // Decrease the gasLimitForAddition by 1000
    @IBAction func btnGasLimitMinusAction(_ sender: UIButton) {
   
        disableImages()
           if let currentGasLimit = Int(txtGasLimit.text ?? "") {
               gasLimitForAddition = max(21000, currentGasLimit - 1000)
               txtGasLimit.text = "\(gasLimitForAddition)"
               self.getValueFromAdvance(txtGasFee.text ?? "", txtGasLimit.text ?? "", txtNounce.text ?? "")
           } else {
               print("Invalid gas limit value in the text field")
           }
    }
    func disableButtons() {
        btnPlusLimit.isUserInteractionEnabled = false
        btnPlusPrice.isUserInteractionEnabled = false
        btnMinusLimit.isUserInteractionEnabled = false
        btnMinusPrice.isUserInteractionEnabled = false
    }
    func enableButtons() {
        btnPlusLimit.isUserInteractionEnabled = true
        btnPlusPrice.isUserInteractionEnabled = true
        btnMinusLimit.isUserInteractionEnabled = true
        btnMinusPrice.isUserInteractionEnabled = true
    }
    func getValueFromAdvance(_ gasPrice: String, _ gaslimit: String, _ nonce:String) {
        //  DGProgressView.shared.showLoader(to: self.view)
        self.disableButtons()
        let price = BigInt(txtGasFee.text ?? "") ?? 0
        let gasPriceValue = UnitConverter.gweiToWei(price)
        let gasLimitValue = BigInt(txtGasLimit.text ?? "") ?? 0
        let gasFee = gasPriceValue * gasLimitValue
        let gasAmount = UnitConverter.convertWeiToEther("\(gasFee)",self.coinDetail?.chain?.decimals ?? 0) ?? ""
        self.calculatedGasPrice = Double(gasAmount) ?? 0.0
        if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
            let allCoin = allToken.filter { $0.address == "" && $0.type == coinDetail?.type && $0.symbol == coinDetail?.chain?.symbol ?? "" }
            _ = Double(tokenAmount) ?? 0.0
            let originalString = gasAmount
            if let originalNumber = Double(originalString) {
                let formattedString = originalNumber
                let finalNetworkFee = WalletData.shared.formatDecimalString("\(formattedString)", decimalPlaces: 6)
                print(finalNetworkFee)
                DispatchQueue.main.async {
                    //  DGProgressView.shared.hideLoader()
                    self.enableButtons()
                    let price = (((Double(gasAmount) ?? 0.0) * (Double(allCoin.first?.price ?? "") ?? 0.0)).rounded(toPlaces: 2))
                    let priceValue = WalletData.shared.formatDecimalString("\(price)", decimalPlaces: 2)
                    self.lblNetworkFee.text = "\(finalNetworkFee) \(self.coinDetail?.chain?.symbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(priceValue))"
                }
            }
            
        }
    }
}

extension SettingPreviewViewController {
    func getGasFee() {
        DGProgressView.shared.showLoader(to: view)
        if let allToken = DatabaseHelper.shared.retrieveData("Token") as? [Token] {
            let allCoin = allToken.filter { $0.address == "" && $0.type == coinDetail?.type && $0.symbol == coinDetail?.chain?.symbol ?? "" }
            _ = Double(tokenAmount) ?? 0.0
            
            var address = ""
            if fromAddressType == CoinType.bitcoin.rawValue {
                 address = toAddress
            } else if toBtcWalletAddres {
                address  = fromAddress
            } else {
                address = toAddress
            }
            self
                .coinDetail?.callFunction.getGasFee(address, tokenAmount: Double(tokenAmount) ?? Double(2) , completion: { status, data, gasPrice,gasLimit,nonce,res  in
                    if status {
                        self.gasfee = data ?? ""
                        let fee = self.gasfee
                        print(fee)
                        let convertedValue = UnitConverter.convertWeiToEther(fee,self.coinDetail?.chain?.decimals ?? 0) ?? ""
                        let gasAmount = ((Double(convertedValue) ?? 0.0) * (Double(allCoin.first?.price ?? "") ?? 0.0))
                        self.gasAmount = "\(gasAmount)"
                        let originalString = convertedValue
                        if let originalNumber = Double(originalString) {
                            let formattedString = originalNumber
                            let networkFee = WalletData.shared.formatDecimalString("\(formattedString)", decimalPlaces: 6)
                            
                            self.networkFee = networkFee
                            DispatchQueue.main.async {
                                DGProgressView.shared.hideLoader()
                                let priceValue = WalletData.shared.formatDecimalString("\(gasAmount)", decimalPlaces: 2)
                                let networkFee = "\(networkFee) \(self.coinDetail?.chain?.symbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(priceValue))"
                                
                                self.buttonSelectionAction()
                             //   self.lblNetworkFee.text  =  networkFee
                            }
                        }
                        
                    }
                })
        }
    }
}
// MARK: - UITextFieldDelegate
extension SettingPreviewViewController : UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // This method is called whenever the user types or deletes characters
            if textField == txtNounce {
                self.getValueFromAdvance(txtGasFee.text ?? "", txtGasLimit.text ?? "", txtNounce.text ?? "")
            } else if textField == txtGasFee {
                self.getValueFromAdvance(txtGasFee.text ?? "", txtGasLimit.text ?? "", txtNounce.text ?? "")
            } else if textField == txtGasLimit {
                self.getValueFromAdvance(txtGasFee.text ?? "", txtGasLimit.text ?? "", txtNounce.text ?? "")
            }

            // Return true if the change should be allowed, false otherwise
            return true
        }
//        func textFieldDidEndEditing(_ textField: UITextField) {
//            // This method is called when editing of the text field ends
//            self.getValueFromAdvance(txtGasFee.text ?? "", txtGasLimit.text ?? "", txtNounce.text ?? "")
//        }
}

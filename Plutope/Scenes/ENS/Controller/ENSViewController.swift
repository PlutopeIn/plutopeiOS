//
//  ENSViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 02/01/24.
//

import UIKit
import BigInt
import Web3
class ENSViewController: UIViewController ,Reusable {
    
    @IBOutlet weak var btnSearch: GradientButton!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var tbvEnsList: UITableView!
    @IBOutlet weak var txtSearch: customTextField!
    @IBOutlet weak var headerView: UIView!
    var isSearching: Bool = false
    var coinDetail: Token?
    var tokensList: [Token]? = []
    var ensList: [ENSDataList] = []
    var filteredList: [ENSDataList] = []
    var address:String = ""
    var txValue = ""
    var receiverAddress = ""
    var txData = ""
    lazy var viewModel: ENSViewModel = {
        ENSViewModel { _,message in
            // self.showToast(message: message, font: .systemFont(ofSize: 15))
            // DGProgressView.shared.hideLoader()
        }
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        /// define header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.ens, comment: ""))
        self.txtSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.search, comment: "")
        btnSearch.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.searchbtn, comment: ""), for: .normal)
        self.lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.ensMsg, comment: "")
        /// Table Register
        tableRegister()
        txtSearch.delegate = self
        
        if(coinDetail?.chain?.coinType == CoinType.bitcoin) {
            address = WalletData.shared.getPublicWalletAddress(coinType: .bitcoin) ?? ""
            
        } else  if(coinDetail?.chain?.coinType == CoinType.tron) {
            address = WalletData.shared.getPublicWalletAddress(coinType: .tron) ?? ""
        } else {
            address = WalletData.shared.getPublicWalletAddress(coinType: .ethereum) ?? ""
        }
        print("Address = ",address)
        lblMsg.isHidden = false
        tbvEnsList.isHidden = true
        selectCoin()
    }
    func selectCoin(_ coinDetail: Token? = nil) {
        // Retrieve token list from the database
        self.tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
        self.tokensList = tokensList?.filter { $0.symbol == "POL" && $0.type == "POLYGON" && $0.tokenId == "polygon-ecosystem-token" && $0.address == "" && $0.chain?.coinType == CoinType.polygon && $0.name == "Polygon" }
        self.coinDetail = self.tokensList?.first
        print(self.coinDetail)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        txtSearch.text = ""
        txtSearch.resignFirstResponder()
        lblMsg.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.ensMsg, comment: "")
        isSearching = false
    }
    /// Table Register
    func tableRegister() {
        tbvEnsList.delegate = self
        tbvEnsList.dataSource = self
        tbvEnsList.register(ENSViewCell.nib, forCellReuseIdentifier: ENSViewCell.reuseIdentifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        txtSearch.textAlignment = (LocalizationSystem.sharedInstance.getLanguage() == "ar") ? .right : .left
       
    }
    
    @IBAction func btnSearchAction(_ sender: GradientButton) {
        HapticFeedback.generate(.light)
        getENSData()
    }
    func filterData() {
        guard let searchText = txtSearch.text else { return }
        filteredList = ensList.filter { ($0.name?.lowercased().contains(searchText.lowercased()) ?? false) }
        tbvEnsList.reloadData()
        tbvEnsList.restore()
    }
}
// MARK: UITextFieldDelegate
extension ENSViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // You may leave this empty or handle other cases if needed
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            getENSData()
        }
    }
}
extension ENSViewController {
    func getENSData() {
        
        let searchText = txtSearch.text ?? ""
        if searchText.isEmpty {
            self.lblMsg.isHidden = true
            self.tbvEnsList.isHidden = true
            self.lblMsg.text = ""
            return
        } else {
            DGProgressView.shared.showLoader(to: view)
            self.lblMsg.isHidden = true
            self.viewModel.eNSDataAPI(currency: "POL", domainName: txtSearch.text ?? "", ownerAddress: address, recordsAddress: address) { apiResponce in
                switch apiResponce {
                case .success(let ensDataList):
                    DGProgressView.shared.hideLoader()
                    self.lblMsg.isHidden = true
                    self.tbvEnsList.isHidden = false
                    let optionalEnsData: ENSDataList? = ensDataList.data
                    let defaultValue = ENSDataList(name: "", availability: nil, tx: nil)
                    // Check if the value is not already in the list
                    if !self.ensList.contains(where: { $0.name == optionalEnsData?.name }) {
                        // Append the instance or use a default value if optionalEnsData is nil
                        self.ensList.append(optionalEnsData ?? defaultValue)
                    }
                    self.filterData()
                case .notAvailable(let errorResponse):
                    DGProgressView.shared.hideLoader()
                    self.lblMsg.isHidden = false
                    self.tbvEnsList.isHidden = true
                    self.lblMsg.text = errorResponse.data
                    print("Error: \(errorResponse.message)")
                }
                DispatchQueue.main.async {
                    self.tbvEnsList.reloadData()
                    self.tbvEnsList.restore()
                }
            }
        }
    }
    func ensApproveTranscation(amount:String, gasLimit: String?, gasPrice: String?, approveTo: String?,txTo: String?,txData: String  , txValue: String ) {
        DispatchQueue.main.async {
            DGProgressView.shared.showLoader(to: self.view)
            self.coinDetail?.callFunction.approveTransactionForSwap(gasLimit,gasPrice,approveTo, tokenAmount: Double(amount) ?? 0.0090) { status,transfererror,_ in
                if status {
                    DispatchQueue.main.async {
                        self.ensSendTranscation(receiverAddress: txTo, txData: txData,gas: gasLimit ?? "",gasPrice: gasPrice ?? "", txValue: txValue)
                    }
                }
            }
        }
    }
    func ensSendTranscation(receiverAddress: String?,txData: String,gas: String,gasPrice: String, txValue: String ) {
        DispatchQueue.main.async {
            
            var txGasLimit: BigInt =  UnitConverter.hexStringToBigInteger(hex: gas) ??  BigInt(2500000)  // ?? BigUInt(2500000)
            if txGasLimit == 0 {
                txGasLimit = BigInt(2500000)
            }
            var  gasPrice: BigUInt = BigUInt(gasPrice) ?? BigUInt(30000)
            
            if gasPrice == 0 {
                gasPrice = BigUInt(30000)
               
            }
            let tValue: BigInt =  UnitConverter.hexStringToBigInteger(hex: txValue)  ?? BigInt(2500000)
            
            DispatchQueue.main.async {
                
                    DGProgressView.shared.hideLoader()
                    let presentInfoVc = PushNotificationViewController()
                     presentInfoVc.alertData = .swapping
                    presentInfoVc.modalTransitionStyle = .crossDissolve
                    presentInfoVc.modalPresentationStyle = .overFullScreen
                    presentInfoVc.okAction = {
                        self.navigationController?.popToRootViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    }
                    self.present(presentInfoVc, animated: true, completion: nil)
                }
            self.coinDetail?.callFunction.signAndSendTranscation(receiverAddress,gasLimit: BigUInt(txGasLimit) , gasPrice: gasPrice , txValue: BigUInt(tValue) , rawData: txData ) { status,transfererror,_ in
                if status {
                    DispatchQueue.main.async {
                        self.showToast(message: "Successfull", font: .systemFont(ofSize: 15))
                     
                        DGProgressView.shared.hideLoader()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.dismiss(animated: true, completion: nil)
                           
                        }
                    }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        self.showToast(message:transfererror ?? "", font: .systemFont(ofSize: 15))
                        DGProgressView.shared.hideLoader()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            }
        }
        
    }
}



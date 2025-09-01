//
//  SessionRequestViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 13/02/24.
//

import UIKit
//import Web3Wallet
import ReownWalletKit
import BigInt
import Web3
class SessionRequestViewController: UIViewController {

    @IBOutlet weak var lblMaxTotal: UILabel!
    @IBOutlet weak var lblMaxTotalTitle: UILabel!
    @IBOutlet weak var lblNetworkFeeTitle: UILabel!
    @IBOutlet weak var lblNetworkFee: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAssets: UILabel!
    @IBOutlet weak var lblFromAddress: UILabel!
    @IBOutlet weak var lblDapp: UILabel!
    @IBOutlet weak var lblToAddress: UILabel!
    @IBOutlet weak var lblAssetsText: UILabel!
    @IBOutlet weak var lblDappText: UILabel!
    @IBOutlet weak var lblToText: UILabel!
    @IBOutlet weak var lblFromText: UILabel!
    @IBOutlet weak var btnConfirm: GradientButton!
    @IBOutlet weak var btnCancel: UIButton!
    var errorMessage = "Error"
    var coinDetail: Token?
    var tokensList: [Token]? = []
    private let interactor: SessionRequestInteractor
    let sessionRequest: Request
    let session: Session?
    let importAccount: ImportAccount
    var chainsArray = [String]()
    var amount = Int()
    var gasAmount = ""
    var networkFee = ""
    var stringWithoutPrefix = ""
    var maxTotal = ""
    var trasHash : EthereumData? = nil
    init(
        interactor: SessionRequestInteractor,
        sessionRequest: Request,importAccount: ImportAccount
    ) {
        defer { setupInitialState() }
        self.interactor = interactor
        self.sessionRequest = sessionRequest
        self.importAccount = importAccount // ?? ImportAccount.new()
        self.session = interactor.getSession(topic: sessionRequest.topic)
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var message: String {
        let message = try? sessionRequest.params.get([String].self)
        let decryptedMessage = message.map { String(data: Data(hex: $0.first ?? ""), encoding: .utf8) }
        return (decryptedMessage ?? String(describing: sessionRequest.params.value)) ?? String(describing: sessionRequest.params.value)
    }
    var onDismiss: (() -> Void)?
    
     func getTokenChainId(_ chainId: String) {
        switch chainId {
        case "56":
            //   tokenName = Chain.binanceSmartChain.name
            self.tokensList = tokensList?.filter {  $0.chain?.symbol == "BNB"  && $0.address == "" && $0.symbol == "BNB" }
        case "1":
            // tokenName = Chain.ethereum.name
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.ethereum && $0.address == "" && $0.symbol == "ETH" }
        case "137":
            // tokenName = Chain.polygon.name
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.polygon && $0.address == "" && $0.symbol == "POL" }
        case "66":
            // tokenName =  Chain.oKC.name
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.okxchain && $0.address == "" && $0.symbol == "OKT" }
        case "10":
            self.tokensList = tokensList?.filter { $0.chain?.coinType == CoinType.optimism  }
        
        case "42161":
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.arbitrum && $0.address == "" && $0.symbol == "ARB" }
        case "43114":
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.avalancheCChain && $0.address == "" && $0.symbol == "AVAX" }
        case "8453":
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.base && $0.address == "" && $0.symbol == "BASE" }
        default:
            break
        }
    }
     func getChainID(_ chainId: String) {
        switch chainId {
        case "56":
            //   tokenName = Chain.binanceSmartChain.name
            self.tokensList = tokensList?.filter { $0.chain?.symbol == "BNB"  }
        case "1":
            //  tokenName = Chain.ethereum.name
            self.tokensList = tokensList?.filter { $0.chain?.coinType == CoinType.ethereum  }
        case "137":
            // tokenName = Chain.polygon.name
            self.tokensList = tokensList?.filter { $0.chain?.coinType == CoinType.polygon  }
        case "66":
            //  tokenName =  Chain.oKC.name
            self.tokensList = tokensList?.filter { $0.chain?.coinType == CoinType.okxchain  }
        case "10":
            self.tokensList = tokensList?.filter { $0.chain?.coinType == CoinType.optimism  }
       
        case "42161":
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.arbitrum}
        case "43114":
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.avalancheCChain }
        case "8453":
            self.tokensList = tokensList?.filter {   $0.chain?.coinType == CoinType.base }
        default:
            break
        }
    }
    // swiftlint:disable function_body_length
     func checkChain(chainId : String) {
       // for chain in chainsArray {
            switch chainId {
            case "eip155:56":
                lblAssets.text = "\(Chain.binanceSmartChain.name)(\(Chain.binanceSmartChain.symbol))"
                return // Exit the function immediately after setting the text.
            case "eip155:1":
                lblAssets.text = "\(Chain.ethereum.name)(\(Chain.ethereum.symbol))"
                return
            case "eip155:137":
                lblAssets.text = "\(Chain.polygon.name)(\(Chain.polygon.symbol))"
                return
            case "eip155:66":
                lblAssets.text = "\(Chain.oKC.name)(\(Chain.oKC.symbol))"
                return
            case "eip155:10":
                lblAssets.text = "\(Chain.opMainnet.name)(\(Chain.opMainnet.symbol))"
                return
            case "eip155:42161":
                lblAssets.text = "\(Chain.arbitrum.name)(\(Chain.arbitrum.symbol))"
                return
            case "eip155:43114":
                lblAssets.text = "\(Chain.avalanche.name)(\(Chain.avalanche.symbol))"
                return
            case "eip155:8453":
                lblAssets.text = "\(Chain.base.name)(\(Chain.base.symbol))"
                return
            default:
                break
            }
        //}
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // uiSetUp
        uiSetUp()
        DGProgressView.shared.showLoader(to: view)
        if let chains = session?.namespaces["eip155"]?.chains {
            // chains is an optional value, so make sure it's not nil before using it
            var chainsArray = Array(chains)
            for element in chainsArray {
                if let val = element as? Blockchain {
                    self.chainsArray.append(val.absoluteString)
                }
            }
        } else {
            // Handle the case where the chains property is nil
            print("Chains property is nil")
        }
        let chainId = sessionRequest.chainId.absoluteString
        let chainIdV = sessionRequest.chainId.reference
        checkChain(chainId: "\(chainIdV)")
        var to = ""
        var value : Int = 0
        var data = ""
        var gas  : Int = 0
         var networkFee = BigInt()
        if let jsonArray = sessionRequest.params.value as? [[String: Any]] {
            for var item in jsonArray {
                for (key, value) in item {
                    if let hexString = value as? String, key != "to" {
                        if let intValue = Int(hexString.replacingOccurrences(of: "0x", with: ""), radix: 16) {
                            item[key] = intValue
                        }
                    }
                }
                print(item)
                to = item["to"] as? String ?? ""
                gas = item["gas"] as? Int ?? 0
                value = item["value"] as? Int ?? 0
                data = item["data"] as? String ?? ""
            }
        }
        lblDapp.text = session?.peer.name
        lblToAddress.setCenteredEllipsisText(to)
        lblFromAddress.setCenteredEllipsisText(WalletData.shared.myWallet?.address ?? "")
        lblEmail.text = message
        self.tokensList = DatabaseHelper.shared.retrieveData("Token") as? [Token]
        getTokenChainId("\(chainIdV)")
        guard let coinDetailObj = self.tokensList?.first else {
            print("coinDetailObj is nil")
            return
        }
        var finalgas = BigInt(gas)
        coinDetailObj.callFunction.sendTokenOrCoinFromWalletConect(to, tokenAmount: Double(value) ,gasLimit:finalgas, rawData: data,isGettingTransactionHash: false, completion: { status,transfererror,gaslimit,gasprice,nonce,dataResult  in
            if status {
                    print("success")
                DGProgressView.shared.hideLoader()
                self.trasHash = dataResult
                
                let gasValueGwai =  UnitConverter.gweiToWei(gaslimit ?? 0)
                let convertedValue =  UnitConverter.convertWeiToEther("\(gasValueGwai)",18) ?? "0"
                let coinPrice = Double(coinDetailObj.price ?? "") ?? 0.0
                let gasAmount = (Double(convertedValue) ?? 0.0) * coinPrice
                let networkFeeValue = WalletData.shared.formatDecimalString("\(convertedValue)", decimalPlaces: 6)
                DispatchQueue.main.async {
                    let priceValue = WalletData.shared.formatDecimalString("\(gasAmount)", decimalPlaces: 2)
                    let networkFeeText = "\(networkFeeValue) \(self.coinDetail?.chain?.symbol ?? "") (\(WalletData.shared.primaryCurrency?.sign ?? "")\(priceValue))"
                    self.lblNetworkFee.attributedText = networkFeeText.underLined
                    self.lblMaxTotal.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(priceValue)"
                }
             } else {
                    print("Fail")
                DGProgressView.shared.hideLoader()
                self.trasHash = dataResult
            }
        })

//            self.mainView.addTapGesture {
//            self.dismiss()
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("call viewWillAppear ")
        let chainId = sessionRequest.chainId.absoluteString
        let chainIdV = sessionRequest.chainId.reference
        checkChain(chainId: "\(chainId)")
    }
    // swiftlint:enable function_body_length

    fileprivate func uiSetUp() {
        self.btnConfirm.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirm, comment: ""), for: .normal)
        self.btnCancel.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: ""), for: .normal)
        self.lblAssetsText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.asset, comment: "")
        self.lblFromText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.from, comment: "")
        self.lblToText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.to, comment: "")
      
        self.lblDapp.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.dApp, comment: "")
        self.lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.transactions, comment: "")
        self.lblMaxTotalTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.maxtotal, comment: "")
        self.lblNetworkFeeTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.networkfee, comment: "")
    }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // Call the completion block when view is disappearing (dismissed)
           // onDismiss?()
        }
    @IBAction func btnCancelAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        Task {
         try await self.onReject()
        }
    }
    @IBAction func btnConfirmAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        DGProgressView.shared.showLoader(to: view)
        Task {
           // self.navigationController?.popViewController(animated: true)
          //  self.dismiss(animated: true)
         
         try await self.onApprove()
        }
    }
    func setupInitialState() {}
    
    @MainActor
    func onApprove() async throws {
        do {
            let showConnected = try await interactor.approve(sessionRequest: sessionRequest, importAccount: importAccount)
            if showConnected {
                DGProgressView.shared.hideLoader()
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true)
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: "Not Approved", font:AppFont.regular(15).value)
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true)
            }
        } catch {
            DGProgressView.shared.hideLoader()
            errorMessage = error.localizedDescription
            self.showToast(message: errorMessage, font:AppFont.regular(15).value)
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
            
        }
    }

    @MainActor
    func onReject() async throws {
        try await interactor.reject(sessionRequest: sessionRequest)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
       // onDismiss?()
    }
    
    func dismiss() {
        HapticFeedback.generate(.light)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
}

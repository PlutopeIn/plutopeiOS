//
//  ReferralCodeViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 11/07/24.
//

import UIKit
import DropDown
import FirebaseDynamicLinks
import CGWallet
import Lottie

class ReferralCodeViewController: UIViewController, CustomDropDownDelegate {
    
    @IBOutlet weak var imgClaim: UIImageView!
    @IBOutlet weak var viewRefral: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblWalletName: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    
    @IBOutlet weak var viewDropDown: UIView!
    @IBOutlet weak var lblCountTotalTokens: UILabel!
    @IBOutlet weak var lblTotalTokens: UILabel!
    
    @IBOutlet weak var lblCountClimedTokens: UILabel!
    @IBOutlet weak var lblClimedTokens: UILabel!
    
    @IBOutlet weak var lblCountNonClimedTokens: UILabel!
    @IBOutlet weak var lblNonClimedTokens: UILabel!
    @IBOutlet weak var tbvUpdateClaim: UITableView!
    
    @IBOutlet weak var btnContinue: GradientButton!
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var viewUpdateClaim: UIView!
    
    @IBOutlet weak var lblReferalTitle: UILabel!
    
    @IBOutlet weak var lblLink: UILabel!
    @IBOutlet weak var imgShare: UIImageView!
    @IBOutlet weak var imgCopy: UIImageView!
    
    @IBOutlet weak var lblWalletHead: UILabel!
    
    @IBOutlet weak var lblNoWalletsDownloads: UILabel!
    @IBOutlet weak var imgNodata: UIImageView!
    
    @IBOutlet weak var tbvHeight: NSLayoutConstraint!
    var sortlink = ""
    var indexpt = 0
    
    var selectFromDropDown = false
    
    var walletsList: [Wallets]?
    var getWalletList : [String]?
    var arrReferallCode : ReferallCodeDataList?
    
    var arrReferallCodeUser : [ReferalUserDataList]?
    
    weak var primaryWalletDelegate: PrimaryWalletDelegate?
    var  objectsToShare = [Any]()
    
    lazy var walletDropDown = { return DropDown() }()
    
    private let dropDownView = CustomDropDownView()
    
    lazy var referallCodeViewModel: ReferallCodeViewModel = {
        ReferallCodeViewModel { _ ,_ in
        }
    }()
    
    lazy var referalUserCodeViewModel: ReferalUserCodeViewModel = {
        ReferalUserCodeViewModel { _ ,_ in
        }
    }()
    
    fileprivate func uiSetUp() {
        lblNoData.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.noReferal, comment: "")
        lblReferalTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.reffreal, comment: "")
        btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.continu, comment: ""), for: .normal)
        
        self.lblTotalTokens.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.total, comment: "")) \n \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.tokens, comment: ""))"
        self.lblClimedTokens.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.claimd, comment: "")) \n \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.tokens, comment: ""))"
        self.lblNonClimedTokens.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.nonClaimd, comment: "")) \n \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.tokens, comment: ""))"
        lblWalletHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.name, comment: "")
        
        viewRefral.roundCorners(corners: [.topLeft,.topRight], radius: 15)
        
        self.lblLink.font = AppFont.violetRegular(12.36).value
        self.lblWalletHead.font = AppFont.violetRegular(16).value
        self.lblWalletName.font = AppFont.violetRegular(20).value
        self.lblCountTotalTokens.font = AppFont.violetRegular(23.18).value
        self.lblCountClimedTokens.font = AppFont.violetRegular(23.18).value
        self.lblCountNonClimedTokens.font = AppFont.violetRegular(23.18).value
        
        self.lblTotalTokens.font = AppFont.violetRegular(15).value
        self.lblClimedTokens.font = AppFont.violetRegular(15).value
        self.lblNonClimedTokens.font = AppFont.violetRegular(15).value
        self.lblNoData.font = AppFont.regular(16).value
        self.lblReferalTitle.font = AppFont.regular(16).value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defineHeader(headerView: headerView, titleText: (LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.myReffreal, comment: "")), btnBackHidden: false)
        /// Table Register
        tableRegister()
        self.walletsList = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
        lblWalletName.text = walletsList?.first?.wallet_name ?? "Main Wallet"
        
        uiSetUp()
        lblNoData.isHidden = false
        imgNodata.isHidden = false
        self.imgShare.isUserInteractionEnabled = false
        self.imgCopy.isUserInteractionEnabled = false
        self.selectFromDropDown = false
        let selectedAddress = WalletData.shared.myWallet?.address ?? ""
         imgClaim.addTapGesture {
             
             HapticFeedback.generate(.light)
         self.getUpdateClaimData(walletAddress: selectedAddress)
            }
        
        // Observe in your view or manager
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: .dataUpdated, object: nil)
        
        dropDownView.delegate = self
               viewDropDown.isUserInteractionEnabled = true
               let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDropdown))
               viewDropDown.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.walletsList = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
        
        lblWalletName.text = walletsList?.first?.wallet_name ?? "Main Wallet"
        
        guard let wallets = self.walletsList else { return }
        
        let walletAddress = WalletData.shared.parseWalletJson(walletJson: CGWalletGenerateWallet(wallets[0].mnemonic ?? "", WalletData.shared.chainETH, nil))
        let selectedAddress = walletAddress?.address
        getReferalUserCodeData(walletAddress: selectedAddress ?? "")
        getReferallCodeData(walletAddress: selectedAddress ?? "")
    }
    func getUpdateClaimData(walletAddress: String) {
            self.referalUserCodeViewModel.updateClaimRepo(walletAddress: walletAddress){ resStatus, resMessage,dataValue  in
                if resStatus == 1 {
                    DGProgressView.shared.hideLoader()
                    
                    self.getReferalUserCodeData(walletAddress: walletAddress)
                    
                } else {
                    DGProgressView.shared.hideLoader()
                    self.showToast(message: resMessage, font: AppFont.regular(15).value)
                }
            }
        }
    private var isDropdownVisible = false // Track dropdown visibility

    @objc private func showDropdown() {
        HapticFeedback.generate(.light)
        if isDropdownVisible {
            dropDownView.hideDropdown()
        } else {
            dropDownView.setItems(walletsList ?? [])
            dropDownView.showDropdown(in: self.view, below: viewDropDown)
        }
        isDropdownVisible.toggle() // Toggle the state
    }
        
        // Handle selection
    func didSelectItem(_ item: String?, index: Int, mnumonic: String) {
        HapticFeedback.generate(.light)
            lblWalletName.text = item
            lblWalletName.textColor = .label
            self.indexpt = index
            
            workItem?.cancel()
            workItem = DispatchWorkItem {
            
            if self.selectFromDropDown == true {
                self.fetchAPI(index: index, mnumonic: mnumonic)
            } else {
                self.fetchAPI(index: 0, mnumonic: mnumonic)
            }
        }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem!)
        }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .dataUpdated, object: nil)
    }
    
    /// Table Register
    private func tableRegister() {
        tbvUpdateClaim.register(ReferralUserCell.nib, forCellReuseIdentifier: ReferralUserCell.reuseIdentifier)
        tbvUpdateClaim.delegate = self
        tbvUpdateClaim.dataSource = self
    }
    
    func getReferalUserCodeData(walletAddress: String) {
        referalUserCodeViewModel.referalUserRepo(walletAddress: walletAddress) { resStatus, resMessage,dataValue  in
            if resStatus == 1 {
                DGProgressView.shared.hideLoader()
                if dataValue?.count != 0 {
                    self.arrReferallCodeUser = dataValue
                    self.lblNoData.isHidden = true
                    self.imgNodata.isHidden = true
                    
                    guard let totalTokens = self.arrReferallCodeUser else { return }
                    self.lblCountTotalTokens.text = "\(self.arrReferallCodeUser?.count ?? 0)"
                    let isClaimFalseCount = totalTokens.filter { !($0.isClaim ?? false) }.count
                    let isClaimTrueCount = totalTokens.filter { $0.isClaim ?? true }.count
                    self.lblCountClimedTokens.text = "\(isClaimTrueCount)"
                    self.lblCountNonClimedTokens.text = "\(isClaimFalseCount)"
                   
                    if isClaimFalseCount == 0 {
                        self.imgClaim.isHidden = true
                        self.viewUpdateClaim.isUserInteractionEnabled = false
                    } else {
                        self.imgClaim.isHidden = false
                        self.viewUpdateClaim.isUserInteractionEnabled = true
                    }
                } else {
                    self.lblCountTotalTokens.text = "0"
                    self.lblCountClimedTokens.text = "0"
                    self.lblCountNonClimedTokens.text = "0"
                    self.arrReferallCodeUser = []
                    self.lblNoData.isHidden = false
                    self.imgNodata.isHidden = false
                    self.imgClaim.isHidden = true
                    self.viewUpdateClaim.isUserInteractionEnabled = false
                }
                self.tbvUpdateClaim.reloadData()
                self.tbvUpdateClaim.restore()
            } else {
                DGProgressView.shared.hideLoader()
                self.lblCountTotalTokens.text = "0"
                self.lblCountClimedTokens.text = "0"
                self.lblCountNonClimedTokens.text = "0"
                self.arrReferallCodeUser = []
                self.showToast(message: resMessage, font: AppFont.regular(15).value)
                self.lblNoData.isHidden = false
                self.imgNodata.isHidden = false
                self.imgClaim.isHidden = true
                self.viewUpdateClaim.isUserInteractionEnabled = false
                self.tbvUpdateClaim.reloadData()
                self.tbvUpdateClaim.restore()
            }
        }
    }
    func getReferallCodeData(walletAddress: String) {
        referallCodeViewModel.getReferallCodeAPI(walletAddress: walletAddress) { resStatus, dataValue, resMessage in
            if resStatus == 1 {
                DGProgressView.shared.hideLoader()
                self.arrReferallCode = dataValue
                let userCode = self.arrReferallCode?.userCode ?? ""
                // Generate Dynamic Link with the referral code
                
                self.createShortDynamicLink(userCode: userCode) { referralLink in
                    if let link = referralLink {
                        print("Generated Link: \(link)")
                        self.sortlink = link
                        self.imgShare.isUserInteractionEnabled = true
                        self.imgCopy.isUserInteractionEnabled = true
                        self.imgShare.addTapGesture {
                                let activityVC = UIActivityViewController(activityItems: [link], applicationActivities: nil)
                                self.present(activityVC, animated: true, completion: nil)
                            
                        }
                        self.imgCopy.addTapGesture {
                            UIPasteboard.general.string = self.sortlink
                            self.showToast(message: "\(StringConstants.copied): \(self.sortlink)", font: AppFont.regular(15).value)
                        }
                        
//                        var urlString = self.sortlink
//                        urlString = urlString.replacingOccurrences(of: "&dfl=true", with: "")
//                        print(urlString)

                        self.lblLink.setCenteredEllipsisText("\(self.sortlink)")
                        // Use the link in UI, share, or log
                    } else {
                        print("Failed to generate link")
                    }
                }
            } else {
                DGProgressView.shared.hideLoader()
                self.showToast(message: resMessage, font: AppFont.regular(15).value)
            }
        }
    }
    
    func appendReferralParameter(to url: URL, referralCode: String) -> URL? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }

        // Copy existing query items into a new variable
        var queryItems = components.queryItems ?? []

        // Add the new referral parameter
        queryItems.append(URLQueryItem(name: "referral", value: referralCode))

        // Assign the updated query items back to components
        components.queryItems = queryItems

        return components.url
    }

    func createShortDynamicLink(userCode: String, completion: @escaping (String?) -> Void) {
        guard let baseURL = URL(string: "https://plutope.page.link/u9DC"),
              let linkWithReferral = appendReferralParameter(to: baseURL, referralCode: userCode) else {
            completion(nil)
            return
        }
        
        guard let dynamicLinkBuilder = DynamicLinkComponents(link: linkWithReferral, domainURIPrefix: "https://plutope.page.link") else {
            completion(nil)
            return
        }
        if Bundle.main.bundleIdentifier == "com.example.app" {
            print("Production App")
        } else {
            print("Development App")
        }
        // Configure platform parameters
        dynamicLinkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: Bundle.main.bundleIdentifier ?? "com.plutope.app")
        dynamicLinkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.app.plutope")

        // Generate a short link
        dynamicLinkBuilder.shorten { shortURL, warnings, error in
            if let error = error {
                print("Error creating short link: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let shortURL = shortURL {
                let finalLink = "\(shortURL.absoluteString)?referral=\(userCode)"
                print("Final Short Dynamic Link: \(finalLink)")
                completion(finalLink)
            } else {
                completion(nil)
            }
        }
    }


//    func createShortDynamicLink(userCode: String, completion: @escaping (String?) -> Void) {
//        guard let link = URL(string: "https://plutope.page.link/u9DC?referral=\(userCode)") else {
//            completion(nil)
//            return
//        }
//        let dynamicLink = DynamicLinkComponents(link: link, domainURIPrefix: "https://plutope.page.link")
//
//        dynamicLink?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.plutope.app")
//        dynamicLink?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.app.plutope")
//
//        dynamicLink?.shorten(completion: { url, warnings, error in
//            if let error = error {
//               // print("Error creating short dynamic link: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//            if let shortURL = url {
//                let referralLink = shortURL.absoluteString + "?referral=\(userCode)"
//                completion(referralLink)
//            } else {
//                completion(nil)
//            }
//        })
//    }

    private var workItem: DispatchWorkItem?

    @objc func fetchData() {
        workItem?.cancel()
        workItem = DispatchWorkItem {
            if self.selectFromDropDown == true {
                self.fetchAPI(index: self.indexpt, mnumonic: self.walletsList?[0].mnemonic ?? "")
                   } else {
                       self.fetchAPI(index: 0, mnumonic: self.walletsList?[0].mnemonic ?? "")
                   }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem!)
    }
    
    func fetchAPI(index: Int,mnumonic:String) {
        // Ensure walletsList is not nil and index is within bounds
        let index = self.indexpt
        guard let wallets = self.walletsList, wallets.indices.contains(index) else {
            print("Invalid index or walletsList is nil")
            return
        }

        let walletAddress = WalletData.shared.parseWalletJson(
            walletJson: CGWalletGenerateWallet(mnumonic, WalletData.shared.chainETH, nil)
        )
        let selectedAddress = walletAddress?.address

        getReferalUserCodeData(walletAddress: selectedAddress ?? "")
        getReferallCodeData(walletAddress: selectedAddress ?? "")
    }
}

protocol CustomDropDownDelegate: AnyObject {
    func didSelectItem(_ item: String?, index: Int,mnumonic:String)
}

class CustomDropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    
    var items = DatabaseHelper.shared.retrieveData("Wallets") as? [Wallets]
    
    weak var delegate: CustomDropDownDelegate?
    
    var rowHeight: CGFloat = 50
    var maxVisibleItems = 4
    private var tableViewHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
    }
    
    private func setupTableView() {
            self.backgroundColor = .systemBackground
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.systemGray3.cgColor
            self.layer.cornerRadius = 25
            self.clipsToBounds = true
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .singleLine
            tableView.backgroundColor = .systemBackground
            tableView.isScrollEnabled = true
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
            addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: self.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            
            tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
            tableViewHeightConstraint?.isActive = true
        }
    
    func setItems(_ items: [Wallets]) {
        self.items = items
        tableView.reloadData()

        // Set the tableView height dynamically
        let totalHeight = min(CGFloat(items.count) * rowHeight, CGFloat(maxVisibleItems) * rowHeight)
        tableViewHeightConstraint?.constant = totalHeight
    }
    
    func showDropdown(in parentView: UIView, below anchorView: UIView) {
        // Get the safe area inset
        let safeAreaInsets = parentView.safeAreaInsets
        
        // Calculate the y position based on the anchor view's position and screen size
        let yPosition = anchorView.frame.maxY + 52.5 + safeAreaInsets.top  // You can adjust the +10 to fine-tune
        
        self.frame = CGRect(x: anchorView.frame.origin.x,
                            y: yPosition,
                            width: anchorView.frame.width,
                            height: 0)
        
        parentView.addSubview(self)
        
        // Animate dropdown expansion
        UIView.animate(withDuration: 0.3) {
            let maxHeight = CGFloat(self.maxVisibleItems) * self.rowHeight
            let contentHeight = CGFloat(self.items?.count ?? 0) * self.rowHeight
            self.frame.size.height = min(contentHeight, maxHeight)
        }
    }
    
    func hideDropdown() {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.size.height = 0
        }) { _ in
            self.removeFromSuperview()
            self.superview?.layoutIfNeeded() // Ensure the layout updates
        }
    }

    // UITableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items?[indexPath.row].wallet_name
        cell.textLabel?.textColor = .label
        cell.backgroundColor = .systemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticFeedback.generate(.light)
        delegate?.didSelectItem(items?[indexPath.row].wallet_name, index: indexPath.row, mnumonic: items?[indexPath.row].mnemonic ?? "")
         
        hideDropdown()
    }
    
}

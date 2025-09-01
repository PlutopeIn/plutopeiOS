//
//  AddNewCardViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/05/24.
//

import UIKit
import DropDown
class AddNewCardViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblDilivery: UILabel!
    @IBOutlet weak var lblDiliveryTitle: UILabel!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var lblCardTitle: UILabel!
    @IBOutlet weak var cardSegment: CustomSegmentedControl!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtCardType: customTextField!
    @IBOutlet weak var lblCardType: UILabel!
    @IBOutlet weak var lblLearnMore: UILabel!
 
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnSubmit: GradientButton!
    @IBOutlet weak var ivCardType: UIImageView!
    
    @IBOutlet weak var lblCardDesign: UILabel!
    
    @IBOutlet weak var ivCard: UIImageView!
    @IBOutlet weak var txtCardDesign: customTextField!
    
    @IBOutlet weak var viewDelivery: UIView!
    @IBOutlet weak var ivCardDesign: UIImageView!
    var selectedSegment = String()
    var arrCardPriceList : [CardPriceList] = []
    var arrCardList : [Card] = []
    let colorMapping: [String: UIColor] = [
        "BLUE": UIColor.c2B5AF3,
        "ORANGE": UIColor.cffa500,
        "BLACK": .black,
        "GOLD": UIColor.cCBB28B,
        "PURPLE": UIColor.c800080
        ]
        var virtualCards: [CardPriceList] = []
        var plasticCards: [CardPriceList] = []
    
        var selectedButton: UIButton?
        let imageView = UIImageView()
    var cardType = ""
    var selectedColor = ""
    var currency = ""
    var cardRequestId : Int?
   
    lazy var cardTypeDropDown = { return DropDown() }()
    lazy var cardDesignDropDown = { return DropDown() }()
    lazy var myCardViewModel: MyCardViewModel = {
        MyCardViewModel { _ ,message in
        }
    }()
    var additionalStatuses:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation header
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.pickyourcard, comment: ""), btnBackHidden: false)
        // segment
        segmentSetup()
        
        getCardPrice()
        
        getCard()
//        setupButtons()
        selectedSegment = "virtual"
        lblLearnMore.font = AppFont.regular(15.56).value
        lblLearnMore.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.learnmore, comment: "")
        btnSubmit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.selectCard, comment: ""), for: .normal)
        lblCardTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: "")
        cardSegment.selectedSegmentIndex = 0
        if cardSegment.selectedSegmentIndex == 0 {
            viewDelivery.isHidden = true
        } else {
            viewDelivery.isHidden = false
        }
    }
    /// Segment Setup
    private func segmentSetup() {
        // Set titles for the segments
        cardSegment.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.virtual, comment: ""), forSegmentAt: 0)
        cardSegment.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.plastic, comment: ""), forSegmentAt: 1)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.c767691, NSAttributedString.Key.font: AppFont.regular(16).value, NSAttributedString.Key.backgroundColor: UIColor.clear]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: AppFont.regular(16).value]
        cardSegment.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        cardSegment.setTitleTextAttributes(titleTextAttributes, for: .normal)
        cardSegment.layer.cornerRadius = 50
        cardSegment.layer.masksToBounds = true
        cardSegment.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            txtCardType.textAlignment = .right
            txtCardDesign.textAlignment = .right
        } else {
            txtCardType.textAlignment = .left
            txtCardDesign.textAlignment = .left
        }
    }
    func setupButtons() {
        HapticFeedback.generate(.light)
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        var firstButton: UIButton?
        if selectedSegment == "virtual" {
            if !self.virtualCards.isEmpty {
                DispatchQueue.main.async {
                    self.cardView.backgroundColor =  self.colorMapping[self.virtualCards.first?.cardDesignID ?? ""]
                }
                
                for (index, price) in virtualCards.enumerated() {
                    guard let color = colorMapping[price.cardDesignID ?? ""] else { continue }
                    let button = UIButton(type: .system)
                    button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                    button.tintColor = color
                    button.tag = index
                    button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
                    stackView.addArrangedSubview(button)
                    if index == 0 {
                        firstButton = button
                    }
                }
            }
        } else {
            if !self.plasticCards.isEmpty {
                DispatchQueue.main.async {
                    self.cardView.backgroundColor =  self.colorMapping[self.plasticCards.first?.cardDesignID ?? ""]
                }
                for (index, price) in plasticCards.enumerated() {
                    guard let color = colorMapping[price.cardDesignID ?? ""] else { continue }
                    let button = UIButton(type: .system)
                    button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                    button.tintColor = color
                    button.tag = index
                    button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
                    stackView.addArrangedSubview(button)
                    if index == 0 {
                        firstButton = button
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.cardView.backgroundColor = .white
                }
            }
        }
        // Simulate a tap on the first button if it exists
        if let firstButton = firstButton {
            DispatchQueue.main.async {
                self.colorButtonTapped(firstButton)
            }
        }
    }

    @objc private func colorButtonTapped(_ sender: UIButton) {
        HapticFeedback.generate(.light)
        if let selectedButton = selectedButton {
            selectedButton.imageView?.layer.borderWidth = 0
            sender.imageView?.layer.cornerRadius = (sender.imageView?.frame.height ?? 0.0) / 2
        }
        sender.imageView?.layer.borderWidth = 2
        sender.imageView?.layer.cornerRadius = (sender.imageView?.frame.height ?? 0.0) / 2
        sender.imageView?.layer.borderColor = UIColor.label.cgColor
        
        selectedButton = sender
        if selectedSegment == "virtual" {
            self.selectedColor = virtualCards[sender.tag].cardDesignID ?? ""
            self.cardType = virtualCards[sender.tag].cardType ?? ""
            lblCardType.text = "\(self.cardType) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: ""))"
            if let price = virtualCards[sender.tag].price {
                let priceValue: Double = {
                    switch price {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                lblCard.text = "\(priceValue) \(virtualCards[sender.tag].currency ?? "")"
            } else {
                lblCard.text = "0"
            }
            if let delivery = virtualCards[sender.tag].delivery {
                let deliveryValue: Double = {
                    switch delivery {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                lblDilivery.text = "\(deliveryValue) \(virtualCards[sender.tag].currency ?? "")"
            } else {
                lblDilivery.text = "0"
            }
            
            let selectedColor = colorMapping[virtualCards[sender.tag].cardDesignID ?? ""] ?? .gray
            self.cardView.backgroundColor = selectedColor
            self.currency = virtualCards[sender.tag].currency ?? ""
        } else {
            if plasticCards.isEmpty {
                lblCard.text = ""
                lblDilivery.text = ""
            } else {
                self.selectedColor = plasticCards[sender.tag].cardDesignID ?? ""
                self.cardType = plasticCards[sender.tag].cardType ?? ""
                lblCardType.text = "\(self.cardType) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.card, comment: ""))"
                if let price = plasticCards[sender.tag].price {
                    let priceValue: Double = {
                        switch price {
                        case .int(let value):
                            return Double(value)
                        case .double(let value):
                            return value
                        }
                    }()
                    lblCard.text = "\(priceValue) \(plasticCards[sender.tag].currency ?? "")"
                } else {
                    lblCard.text = "0"
                }
            if let delivery = plasticCards[sender.tag].delivery {
                let deliveryValue: Double = {
                    switch delivery {
                    case .int(let value):
                        return Double(value)
                    case .double(let value):
                        return value
                    }
                }()
                lblDilivery.text = "\(deliveryValue) \(plasticCards[sender.tag].currency ?? "")"
            } else {
                lblDilivery.text = "0"
            }
            
            let selectedColor = colorMapping[plasticCards[sender.tag].cardDesignID ?? ""] ?? .gray
            self.currency = plasticCards[sender.tag].currency ?? ""
           
        }
        }
        }
    @IBAction func actionSegment(_ sender: Any) {
        HapticFeedback.generate(.light)
        if cardSegment.selectedSegmentIndex == 0 {
            selectedSegment = "virtual"
            viewDelivery.isHidden = true
            getCardPrice()
        } else {
            selectedSegment = "plastic"
            viewDelivery.isHidden = false
            getCardPrice()
        }
        
    }
    func presentActionNeedPopUpViewController(withStatus status: String) {
        HapticFeedback.generate(.light)
        let vcToPresent = ActionNeedPopUpViewController()
        vcToPresent.cardRequestId = self.arrCardList.first?.cardRequestID ?? 0
        vcToPresent.arrCardList = self.arrCardList.first
//        vcToPresent.delegate = self
        vcToPresent.isStatus = status
        self.navigationController?.present(vcToPresent, animated: true)
    }
    @IBAction func btnSubmitAction(_ sender: Any) {
        HapticFeedback.generate(.light)
        let termsForAddCardPopUp = TermsForAddCardPopUp()
        termsForAddCardPopUp.delegate = self
        termsForAddCardPopUp.hidesBottomBarWhenPushed = true
        self.navigationController?.present(termsForAddCardPopUp, animated: true)
    }
    
    func getCardPrice() {
        DGProgressView.shared.showLoader(to: view)
        myCardViewModel.getCardPriceAPINew { status, msg,data in
            if status == 1 {
                DGProgressView.shared.hideLoader()
                self.virtualCards = data?.filter { $0.cardType == "VIRTUAL" } ?? []
                self.plasticCards = data?.filter { $0.cardType == "PLASTIC" } ?? []
                DispatchQueue.main.async {
                    self.setupButtons()
                }
               
            } else {
                DGProgressView.shared.hideLoader()
                 print("No data")
            }
        }
    }
    
    func getCard() {
        DGProgressView.shared.showLoader(to: view)
        myCardViewModel.getCardAPINew { status, msg,data in
            if status == 1 {
                DGProgressView.shared.hideLoader()
                self.arrCardList = data ?? []
                DispatchQueue.main.async {
                    if !self.arrCardList.isEmpty {
                        self.additionalStatuses = self.arrCardList.first?.additionalStatuses ?? []
                        self.cardRequestId = self.arrCardList.first?.cardRequestID
                    } else {
                    }
                }
            } else {
                DGProgressView.shared.hideLoader()
            }
        }
    }
}

extension AddNewCardViewController : TermsAndConditionDelegate {
    func agreeTerms(isAgree: Bool) {
        DGProgressView.shared.showLoader(to: view)
        myCardViewModel.cardRequestsAPINew(cardType: self.cardType, cardDesignId: self.selectedColor) { status, msg, data in
                if status == 1 {
                    DGProgressView.shared.hideLoader()
                    let myDictionary = data
                    var cardReqId = 0
                    if let id = myDictionary?["id"] {
                        print("The id is \(id)")
                        cardReqId = id as? Int ?? 0
                        self.cardRequestId = cardReqId
                    }
                    if !self.additionalStatuses.contains("KYC") {
                        NotificationCenter.default.post(name: NSNotification.Name("RefreshCardDashBoard"), object: nil)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        let updateAddressVC = UpdateCardRequestAddressViewController()
                        updateAddressVC.cardRequestId = self.cardRequestId
                        updateAddressVC.additionalStatuses = self.additionalStatuses
                        updateAddressVC.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(updateAddressVC, animated: true)
                    }
                } else {
                    DGProgressView.shared.hideLoader()
                }
            }
    }
}

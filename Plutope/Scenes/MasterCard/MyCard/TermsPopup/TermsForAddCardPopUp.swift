//
//  TermsForAddCardPopUp.swift
//  Plutope
//
//  Created by Trupti Mistry on 05/06/24.
//

import UIKit
protocol TermsAndConditionDelegate : AnyObject {
    func agreeTerms(isAgree:Bool)
}
class TermsForAddCardPopUp: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewAgreement: UIView!
    @IBOutlet weak var ivCheckUncheck: UIImageView!
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var lblMsg: UILabel!
    weak var delegate : TermsAndConditionDelegate?
    @IBOutlet weak var btnDone: GradientButton!
    var isChecked: Bool = false
    fileprivate func uiSetup() {
        
        let termsText = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.termsAndConditions, comment: "")
        let fullTextFormat = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.termsMessage, comment: "")
        let fullText = String(format: fullTextFormat, termsText)

        setAttributedClickableText(labelName: lblMsg,
                                   labelText: fullText,
                                   value: termsText,
                                   color: UIColor.label)
        ivClose.addTapGesture(target: self, action: #selector(closeScreen))
        lblTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.terms, comment: "")
        btnDone.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.teremsBtnTitle, comment: ""), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiSetup()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isChecked {
            self.btnDone.alpha = 0.5
            self.btnDone.isEnabled = false
        }
        ivCheckUncheck.addTapGesture {
            HapticFeedback.generate(.light)
            self.isChecked.toggle()
            if self.isChecked {
                self.ivCheckUncheck.image = UIImage.icNewcheck.sd_tintedImage(with: UIColor.label)
                self.btnDone.alpha = 1
                self.btnDone.isEnabled = true
            } else {
                self.ivCheckUncheck.image = UIImage.newuncheck.sd_tintedImage(with: UIColor.label)
                self.btnDone.alpha = 0.5
                self.btnDone.isEnabled = false
            }
        }
       
    }
    @objc func agreementViewTapped(_ sender: UITapGestureRecognizer) {
        HapticFeedback.generate(.light)
        isChecked.toggle()
        if isChecked {
            self.ivCheckUncheck.image = UIImage.icNewcheck.sd_tintedImage(with: UIColor.label)
            self.btnDone.alpha = 1
            self.btnDone.isEnabled = true
        } else {
            self.ivCheckUncheck.image = UIImage.newuncheck.sd_tintedImage(with: UIColor.label)
            self.btnDone.alpha = 0.5
            self.btnDone.isEnabled = false
        }
    }
    @objc func closeScreen() {
        HapticFeedback.generate(.light)
        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btnDoneAction(_ sender: Any) {
//        self.delegate?.agreeTerms(isAgree: true)
        HapticFeedback.generate(.light)
        self.dismiss(animated: true) {
            self.delegate?.agreeTerms(isAgree: true)
        }
    }
    @MainActor
    func showWebView(for url: String, onVC: UIViewController, title: String) {
        let webController = WebViewController()
        webController.webViewURL = url
        webController.webViewTitle = title
        let navVC = UINavigationController(rootViewController: webController)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.modalTransitionStyle = .crossDissolve
        onVC.present(navVC, animated: true)
    }
    
}

extension TermsForAddCardPopUp {
    func setAttributedClickableText(labelName: UILabel, labelText: String, value: String, color: UIColor) {
        // Enable interaction
        labelName.isUserInteractionEnabled = true
        
        let commonAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: AppFont.regular(14).value
        ]
        
        let clickableAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.c2B5AF3,
            .font: AppFont.regular(14).value
        ]

        let attributedString = NSMutableAttributedString(string: labelText, attributes: commonAttributes)

        let clickableRange = (labelText as NSString).range(of: value)
        if clickableRange.location != NSNotFound {
            attributedString.addAttributes(clickableAttributes, range: clickableRange)
        }

        labelName.attributedText = attributedString

        // Gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_:)))
        labelName.addGestureRecognizer(tapGesture)
    }

        
        @objc func handleLabelTap(_ gesture: UITapGestureRecognizer) {
            guard let label = gesture.view as? UILabel else { return }
            guard let attributedText = label.attributedText else { return }
            let text = attributedText.string
            let range = (text as NSString).range(of: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.termsAndConditions, comment: ""))
            
            let layoutManager = NSLayoutManager()
            let textContainer = NSTextContainer(size: label.bounds.size)
            let textStorage = NSTextStorage(attributedString: attributedText)
            
            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)
            
            textContainer.lineFragmentPadding = 0.0
            textContainer.lineBreakMode = label.lineBreakMode
            textContainer.maximumNumberOfLines = label.numberOfLines
            textContainer.size = label.bounds.size
            
            let locationOfTouchInLabel = gesture.location(in: label)
            let textBoundingBox = layoutManager.usedRect(for: textContainer)
            let textContainerOffset = CGPoint(
                x: (label.bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                y: (label.bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
            )
            let locationOfTouchInTextContainer = CGPoint(
                x: locationOfTouchInLabel.x - textContainerOffset.x,
                y: locationOfTouchInLabel.y - textContainerOffset.y
            )
            
            let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            
            if NSLocationInRange(indexOfCharacter, range) {
                // Handle the tap on the clickable text (partTwo)
                print("Clickable text tapped!")
                showWebView(for: URLs.cardTermsUrl, onVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.terms, comment: ""))
            }
        }
}

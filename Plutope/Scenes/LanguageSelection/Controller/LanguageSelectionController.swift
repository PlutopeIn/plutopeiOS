//
//  LanguageSelectionController.swift
//  Plutope
//
//  Created by Admin on 07/11/23.
//

import UIKit
import IQKeyboardManagerSwift
class LanguageSelectionController: UIViewController, Reusable {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tblLanguages: UITableView!
    var arrayLanguageData: [LanguageData] = [
        LanguageData(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.english, comment: ""), languageCode: "en", isCheckedLanguage: true),
        LanguageData(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.hindi, comment: ""), languageCode: "hi", isCheckedLanguage: false),
        LanguageData(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.thai, comment: ""), languageCode: "th", isCheckedLanguage: false)
//        ,LanguageData(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.arebic, comment: ""), languageCode: "ar", isCheckedLanguage: false)
    ]
    
  // Custom Methods
    func applyStyle() {
    }
    func setupView() {
        self.applyStyle()
        
        self.setSelectedLanguage(language: LocalizationSystem.sharedInstance.getLanguage())
        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.language, comment: ""))
        
        self.tblLanguages.delegate = self
        self.tblLanguages.dataSource = self
        self.tblLanguages.register(LanguageSelectionTableCell.nib, forCellReuseIdentifier: LanguageSelectionTableCell.reuseIdentifier)
    }
    // setSelectedLanguage
    func setSelectedLanguage(language: String) {
        
        self.arrayLanguageData = self.arrayLanguageData.compactMap({ data in
            var data = data
            if language == data.languageCode {
                data.isCheckedLanguage = true
            } else {
                data.isCheckedLanguage = false
            }
            return data
        })
        
        // Convert array to dictionary
        let languageDataDictionary = Dictionary(uniqueKeysWithValues: arrayLanguageData.map { ($0.languageCode, $0) })
        NotificationCenter.default.post(name: NSNotification.Name("LanguageDidChange"), object: self, userInfo: languageDataDictionary)
        self.tblLanguages.reloadData()
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.done, comment: "")
        IQKeyboardManager.shared.reloadInputViews()
        
        updateSemanticContentAttribute()
        
    }
   
    func updateSemanticContentAttribute() {
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
       // updateTextFieldDirection()
       
        // You may need to force a layout update after changing the semanticContentAttribute
        UIView().window?.rootViewController?.view.layoutIfNeeded()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // ui setup
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tblLanguages.reloadData()
        self.tblLanguages.restore()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Memory Management Methods -
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

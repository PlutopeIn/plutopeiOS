//
//  LanguageSelectionController.swift
//  Plutope
//
//  Created by Admin on 07/11/23.
//

import UIKit
import IQKeyboardManagerSwift

protocol DismissLanguageDelegate : NSObject {
    func dismissPopup()
}
class LanguageSelectionController: UIViewController, Reusable {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tblLanguages: UITableView!
    weak var delegate: DismissLanguageDelegate?
    var arrayLanguageData: [LanguageData] = [
        LanguageData(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.hindi, comment: ""), languageCode: "hi", isCheckedLanguage: false),
        LanguageData(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.english, comment: ""), languageCode: "en", isCheckedLanguage: true),
        LanguageData(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.thai, comment: ""), languageCode: "th", isCheckedLanguage: false)
//        ,LanguageData(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.arebic, comment: ""), languageCode: "ar", isCheckedLanguage: false)
    ]
    
  // Custom Methods
    func applyStyle() {
    }
    func setupView() {
        self.applyStyle()
        self.setSelectedLanguage(language: LocalizationSystem.sharedInstance.getLanguage())
        defineHeader(headerView: headerView, titleText: "")
        
        self.tblLanguages.delegate = self
        self.tblLanguages.dataSource = self

        self.tblLanguages.register(LanguageSelectionCell.nib, forCellReuseIdentifier: LanguageSelectionCell.reuseIdentifier)
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
        IQKeyboardManager.shared.reloadInputViews()
        
        updateSemanticContentAttribute()
        
    }
   
    func updateSemanticContentAttribute() {
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        UIView().window?.rootViewController?.view.layoutIfNeeded()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tblLanguages.isUserInteractionEnabled = true
        // ui setup
        self.setupView()
       
        // Create a UIView with height of 20
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tblLanguages.frame.width, height: 20))
        headerView.backgroundColor = UIColor.clear // Transparent background
        
        // Assign it to the tableView's header
        tblLanguages.tableHeaderView = headerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tblLanguages.reloadData()
        self.tblLanguages.restore()
    }
    
}

//
//  AddNewCardViewController.swift
//  Plutope
//
//  Created by Trupti Mistry on 17/05/24.
//

import UIKit

class AddNewCardViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtCardType: customTextField!
    @IBOutlet weak var lblCardType: UILabel!
    @IBOutlet weak var btnSubmit: GradientButton!
    @IBOutlet weak var ivCardType: UIImageView!
    
    @IBOutlet weak var lblCardDesign: UILabel!
    
    @IBOutlet weak var txtCardDesign: customTextField!
    
    @IBOutlet weak var ivCardDesign: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation header
//        defineHeader(headerView: headerView, titleText: LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.profile, comment: ""), btnBackHidden: false)
        defineHeader(headerView: headerView, titleText: "", btnBackHidden: false)
        ivCardType.addTapGesture {
//            self.daysDropDown.dataSource = ["VIRTUAL","PLASTIC"]
//                        self.dropDownUiSetUp()
//                        self.daysDropDown.show()
//                        self.daysDropDown.selectionAction = { [weak self] (index, item) in
//                            
//                            guard let self = self else { return }
//                            self.daysDropDown.selectRow(index)
//                            self.txtDropDown.text = item
//
//                        }
        }
        ivCardDesign.addTapGesture {
         //   self.daysDropDown.dataSource = ["BLUE","ORANGE","BLACK","GOLD","PURPLE"]
          //                        self.dropDownUiSetUp()
          //                        self.daysDropDown.show()
          //                        self.daysDropDown.selectionAction = { [weak self] (index, item) in
          //
          //                            guard let self = self else { return }
          //                            self.daysDropDown.selectRow(index)
          //                            self.txtDropDown.text = item
          //                        }
        }
    }

    @IBAction func btnSubmitAction(_ sender: Any) {
        
    }
    fileprivate func dropDownUiSetUp() {
//            daysDropDown.selectedTextColor = .darkGray
//            daysDropDown.direction = .bottom
//            daysDropDown.anchorView = usdtDropdownView
//            daysDropDown.backgroundColor = .lightGray
//            daysDropDown.shadowColor = .darkGray
//            daysDropDown.cellHeight = 32
//            daysDropDown.selectionBackgroundColor = UIColor.white
//            daysDropDown.bottomOffset = CGPoint(x: 0, y: usdtDropdownView.bounds.height + 3)
        }
}

//
//  MoreDetailViewController + Delegate.swift
//  Plutope
//
//  Created by Trupti Mistry on 11/08/23.
//

import Foundation
import UIKit

// MARK: UIPickerViewDelegate and UIPickerViewDataSource
extension MoreDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return arrLanguage.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrLanguage[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtLanguage.text = arrLanguage[row]
    }

}

extension MoreDetailViewController: UITextFieldDelegate {
    
}

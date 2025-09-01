//
//  PersonalInfo+Delegate.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/08/23.
//

import UIKit

// MARK: UIPickerViewDelegate and UIPickerViewDataSource
extension PersonalInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerData[row].flag ?? "")  \(pickerData[row].name ?? "")"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCountryCode.text = "\(pickerData[row].flag ?? "")  \(pickerData[row].name ?? "")"
    }
}

extension PersonalInfoViewController: UITextFieldDelegate {
    
}

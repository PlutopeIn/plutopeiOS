//
//  CardPaymentViewController + Delegate.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/08/23.
//

import Foundation
import UIKit

// MARK: UIPickerViewDelegate and UIPickerViewDataSource
extension CardPaymentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPaymentMothod.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return arrPaymentMothod[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {   
            txtPaymentMethod.text = arrPaymentMothod[row]
        }
}

extension CardPaymentViewController: UITextFieldDelegate {
    
}

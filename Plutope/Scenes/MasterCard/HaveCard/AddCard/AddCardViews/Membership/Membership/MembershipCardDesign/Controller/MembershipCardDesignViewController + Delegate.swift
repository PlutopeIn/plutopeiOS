//
//  MembershipCardDesignViewController + Delegate.swift
//  Plutope
//
//  Created by Trupti Mistry on 10/08/23.
//

import UIKit

// MARK: UIPickerViewDelegate and UIPickerViewDataSource
extension MembershipCardDesignViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerView == curruncyPickerView ? currencyData?.count ?? 0 : shippingListArr.count
            
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == curruncyPickerView {
            return currencyData?[row].symbol
        } else {
            return shippingListArr[row].title
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
        if pickerView == curruncyPickerView {
            txtCurruncy.text = currencyData?[row].symbol
            ivCurruncySign.image = UIImage(named: currencyData?[row].sign ?? "")
        } else {
            txtShipping.text = shippingListArr[row].title
        }
        
    }
}

extension MembershipCardDesignViewController: UITextFieldDelegate {
    
}

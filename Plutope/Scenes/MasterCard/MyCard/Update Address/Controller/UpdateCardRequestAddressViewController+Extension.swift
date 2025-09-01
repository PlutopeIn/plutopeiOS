//
//  UpdateCardRequestAddressViewController+Extension.swift
//  Plutope
//
//  Created by Trupti Mistry on 20/05/24.
//

import Foundation
import UIKit
// MARK: UIPickerViewDelegate and UIPickerViewDataSource
extension UpdateCardRequestAddressViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPickerView {
            return countryPickerData.count
        } else {
            return documentCountryPickerData.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == countryPickerView {
            return countryPickerData[row].country
        } else {
            return documentCountryPickerData[row].country
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == countryPickerView {
            let selectedCountry = countryPickerData[row]
            txtCountry.text = selectedCountry.country
            countryCode = selectedCountry.iso3 ?? ""
           
        } else {
            let selectedCountry = documentCountryPickerData[row]
            txtDocumentCountry.text = selectedCountry.country
            doccumentCountryCode = selectedCountry.iso3 ?? ""
         
        } 
    }
}
extension UpdateCardRequestAddressViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtCountry {
           // countryPickerView.isHidden = false
        } else{
            //documentCountryPickerView.isHidden = false
        } 

        return true // This will allow the text field to become the first responder and show the picker view
    }
}
// MARK: TextView Delegate for PlaceHolderText
extension UpdateCardRequestAddressViewController : UITextViewDelegate {
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView == txtAddress {
//            txtAddress.text = ""
//            txtAddress.textColor = UIColor.white
//            txtAddress.isScrollEnabled = true
//        } else {
//            txtAddress2.text = ""
//            txtAddress2.textColor = UIColor.white
//            txtAddress2.isScrollEnabled = true
//        }
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView == txtAddress {
//            if txtAddress.text == ""{
//                // txtAddress.textColor = UIColor.c75769D
//                txtAddress.text = ""
//                txtAddress.isScrollEnabled = false
//            }
//        } else {
//            if txtAddress2.text == "" {
//                // txtAddress2.textColor = UIColor.c75769D
//                txtAddress2.text = ""
//                txtAddress2.isScrollEnabled = false
//            }
//        }
//        
//    }
}

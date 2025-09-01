//
//  CardUserProfileViewController+Extension.swift
//  Plutope
//
//  Created by Trupti Mistry on 16/05/24.
//

import Foundation
import UIKit
extension CardUserProfileViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.letters.union(.whitespaces)
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
extension CardUserProfileViewController {
    
    func getProfileData() {
        DGProgressView.shared.showLoader(to: view)
        cardUserProfileViewModel.getProfileAPINew { status, msg,data in
            if status == 1 {
                self.arrProfileList = data
                DispatchQueue.main.async {
                    DGProgressView.shared.hideLoader()
                  //  self.txtEmail.text = self.arrProfileList?.email
                    self.txtMobile.text = self.arrProfileList?.phone
                    self.txtFirstName.text = self.arrProfileList?.firstName
                    self.txtLastName.text = self.arrProfileList?.lastName
//                    self.txtDOB.text = self.arrProfileList?.dateOfBirth?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "yyyy-MM-dd", timeZone: nil).0
                    self.txtDOB.text = self.arrProfileList?.dateOfBirth?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "dd-MM-yyyy", timeZone: nil).0
                    self.dob = self.arrProfileList?.dateOfBirth?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "yyyy-MM-dd", timeZone: nil).0 ?? ""
                    if let country = self.documentCountryPickerData.first(where: { $0.iso2 == self.arrProfileList?.residenceCountry }) {
                        if let countryName = country.country {
                            print("Country name: \(countryName)")
                            self.txtCountry.text = countryName
                            self.countryCode = country.iso2 ?? ""
                        } else {
                            print("Country name not found")
                        }
                    } else {
                        print("Country with code \(self.arrProfileList?.residenceCountry ?? "") not found")
                    }
                    self.txtStreet.text = self.arrProfileList?.residenceStreet
                    self.txtCity.text = self.arrProfileList?.residenceCity
                    self.txtZip.text = self.arrProfileList?.residenceZipCode
                }
            } else {
                DGProgressView.shared.hideLoader()
//                self.showToast(message: "No Data", font: AppFont.medium(15).value)
            }
        }
    }
    /// live
    func getProfileDataNew() {
        DGProgressView.shared.showLoader(to: view)
        cardUserProfileViewModel.getProfileAPINew { status,msg, data in
            if status == 1 {
                self.arrProfileList = data
                DispatchQueue.main.async {
                    DGProgressView.shared.hideLoader()
                  //  self.txtEmail.text = self.arrProfileList?.email
                    self.txtMobile.text = self.arrProfileList?.phone
                    self.txtFirstName.text = self.arrProfileList?.firstName
                    self.txtLastName.text = self.arrProfileList?.lastName
//                    self.txtDOB.text = self.arrProfileList?.dateOfBirth?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "yyyy-MM-dd", timeZone: nil).0
                    self.txtDOB.text = self.arrProfileList?.dateOfBirth?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "dd-MM-yyyy", timeZone: nil).0
                    self.dob = self.arrProfileList?.dateOfBirth?.ConvertDate(currentFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "yyyy-MM-dd", timeZone: nil).0 ?? ""
                    if let country = self.documentCountryPickerData.first(where: { $0.iso2 == self.arrProfileList?.residenceCountry }) {
                        if let countryName = country.country {
                            print("Country name: \(countryName)")
                            self.txtCountry.text = countryName
                            self.countryCode = country.iso2 ?? ""
                        } else {
                            print("Country name not found")
                        }
                    } else {
                        print("Country with code \(self.arrProfileList?.residenceCountry ?? "") not found")
                    }
                    self.txtStreet.text = self.arrProfileList?.residenceStreet
                    self.txtCity.text = self.arrProfileList?.residenceCity
                    self.txtZip.text = self.arrProfileList?.residenceZipCode
                }
            } else {
                DGProgressView.shared.hideLoader()
//                self.showToast(message: "No Data", font: AppFont.medium(15).value)
            }
        }
    }
    func fetchCountry() {
       // DGProgressView.shared.showLoader(to: self.view)
        myCardViewModel.getCountrisAPI { status, msg, data in
            DispatchQueue.main.async {
                if status == 1 {
                    self.documentCountryPickerData = data ?? []
                    if self.server == .live {
                        self.getProfileDataNew()
                    } else {
                        self.getProfileData()
                    }
                    DispatchQueue.main.async {
                        AppConstants.storedCountryList =  data ?? []
                    }
                } else {
                  //  DGProgressView.shared.hideLoader()
                    print(msg)
                }
            }
        }
    }
     func allReadySaved() {
         self.documentCountryPickerData = AppConstants.storedCountryList ?? []
             self.getProfileDataNew()
    }
}

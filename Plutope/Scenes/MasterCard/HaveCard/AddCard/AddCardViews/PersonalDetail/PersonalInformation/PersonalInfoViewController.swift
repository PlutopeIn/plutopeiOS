//
//  PersonalInfoViewController.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/08/23.
//

import UIKit
import Combine

class PersonalInfoViewController: UIViewController {
    
    @IBOutlet weak var txtLastName: customTextField!
    @IBOutlet weak var txtFirstName: customTextField!
    @IBOutlet weak var txtDOB: customTextField!
    @IBOutlet weak var txtCountryCode: customTextField!
    
    private var viewModel = CountryCodeViewModel()
    private var cancellables = Set<AnyCancellable>()
    internal var pickerData: [Country] = [] {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    let pickerView = UIPickerView()
    var datePicker = UIDatePicker()
    // Define a closure property that acts as a callback
    var onNextButtonTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerViewConfigure()
        datePickerSetups()
        
        /// fetch the country codes
        viewModel.getCountryCode()
        
        // Subscribe to changes in the countries property to update your UI as needed
        viewModel.$countries
            .sink { [weak self] countries in
                // Handle the updated countries data here
                self?.pickerData = countries
                self?.txtCountryCode.text = "\(countries.first?.flag ?? "")  \(countries.first?.name ?? "")"
                print(countries)
            }
            .store(in: &cancellables)
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                txtLastName.textAlignment = .right
                txtFirstName.textAlignment = .right
                txtDOB.textAlignment = .right
                txtCountryCode.textAlignment = .right
                
            } else {
                txtLastName.textAlignment = .left
                txtFirstName.textAlignment = .left
                txtDOB.textAlignment = .left
                txtCountryCode.textAlignment = .left
            }
            
        }
    
    private func pickerViewConfigure() {
        // Configure picker view for challange type
        pickerView.delegate = self
        pickerView.dataSource = self
        txtCountryCode.inputView = pickerView
        // Set delegates
        txtCountryCode.delegate = self
    }
    
    private func datePickerSetups() {
       // DatePickerSetups
        txtDOB.inputView = datePicker
        txtDOB.delegate = self
       if #available(iOS 13.4, *) {
           datePicker.preferredDatePickerStyle = .wheels
       } else {
           // Fallback on earlier versions
       }
        datePicker.datePickerMode = .date
        let date = Calendar.current.date(byAdding: .year, value: -10, to: Date())
        datePicker.maximumDate = date
   }
   
    @IBAction func actionNext(_ sender: Any) {
        onNextButtonTapped?()
    }
}

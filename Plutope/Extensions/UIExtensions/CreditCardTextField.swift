//
//  CreditCardTextField.swift
//  Plutope
//
//  Created by Trupti Mistry on 18/06/24.
//

import Foundation
import UIKit

class CreditCardTextField: UITextField, UITextFieldDelegate {

    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.delegate = self
        self.keyboardType = .numberPad
        self.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
    }

    @objc func reformatAsCardNumber() {
        guard let text = self.text else { return }
        
        let textWithoutSpaces = text.replacingOccurrences(of: " ", with: "")
        let maxLength = 16
        if textWithoutSpaces.count > maxLength {
            let index = textWithoutSpaces.index(textWithoutSpaces.startIndex, offsetBy: maxLength)
            self.text = String(textWithoutSpaces[..<index])
        }

        let formattedText = insertSpacesEveryFourDigits(into: textWithoutSpaces)
        self.text = formattedText
    }

    private func insertSpacesEveryFourDigits(into string: String) -> String {
        var result = ""
        for (index, character) in string.enumerated() {
            if index != 0 && index % 4 == 0 {
                result.append(" ")
            }
            result.append(character)
        }
        return result
    }
}

//
//  RoundedBorderTextField.swift
//  Versi
//
//  Created by IceApinan on 13/11/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

class RoundedBorderTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)])
        attributedPlaceholder = placeholder
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.cornerRadius = frame.height / 2
        layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        layer.borderWidth = 3
    }
    
}

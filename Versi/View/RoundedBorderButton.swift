//
//  RoundedBorderButton.swift
//  Versi
//
//  Created by IceApinan on 13/11/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit

class RoundedBorderButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 3
        layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

}

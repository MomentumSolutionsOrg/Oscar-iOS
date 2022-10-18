//
//  RoundedButton.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//

import UIKit

class RoundedButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

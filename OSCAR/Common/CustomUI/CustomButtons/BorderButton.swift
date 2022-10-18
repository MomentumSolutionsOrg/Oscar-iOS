//
//  BorderButton.swift
//  Expert
//
//  Created by Momentum Solutions Co. on 31/05/2021.
//  Copyright © 2021 Mostafa Samir. All rights reserved.
//

import UIKit

class BorderButton: UIButton {
    
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderColor: UIColor? = UIColor.blackTextColor
    @IBInspectable var textColor: UIColor? = UIColor.blackTextColor
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = borderColor?.cgColor
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
}

//
//  BorderView.swift
//  Expert
//
//  Created by Momentum Solutions Co. on 08/06/2021.
//  Copyright © 2021 Mostafa Samir. All rights reserved.
//

import UIKit

class BorderView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var addShadow: Bool = false
    @IBInspectable var showBorder: Bool = true {
        didSet {
            updateBorder()
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0.5
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBorder()
        self.layer.cornerRadius = cornerRadius
        applyShadow()
    }
    
    func updateBorder() {
        if showBorder {
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = UIColor.blueColor?.cgColor
        }else {
            self.layer.borderWidth = 0
            self.layer.borderColor = backgroundColor?.cgColor
        }
    }
    
    private func applyShadow() {
        if addShadow {
            self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowRadius = 2
            self.layer.shadowOpacity = 0.09
        }
        
    }
}

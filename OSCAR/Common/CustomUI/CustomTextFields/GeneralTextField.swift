//
//  GeneralTextField.swift
//  Oscar
//
//  Created by Momentum Solutions Co. on 31/05/2021.
//  Copyright © 2021 Mostafa Samir. All rights reserved.
//
import UIKit

class GeneralTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: 20,
                                             height: self.frame.height))
        self.textAlignment = LanguageManager.shared.isArabicLanguage() ? .right : .left
        self.autocorrectionType = .no
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addShadow()
    }
    
    func addShadow() {
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
        self.borderStyle = .none
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.16
    }
}


//
//  UITextFieldExtension.swift
//  OSCAR
//
//  Created by User on 26/08/2021.
//

import UIKit

extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.autocorrectionType = .no
        self.textAlignment = LanguageManager.shared.isArabicLanguage() ? .right : .left
    }
}

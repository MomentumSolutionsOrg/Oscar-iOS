//
//  DropDownCell.swift
//  OSCAR
//
//  Created by User on 29/08/2021.
//

import UIKit
import DropDown

class CustomDropDownCell: DropDownCell {
    
    @IBOutlet private weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stackView.alignment = LanguageManager.shared.isArabicLanguage() ? .trailing : .leading
    }
    
    func configureCell(branchName: String) {
        optionLabel.text = branchName
    }
    
}

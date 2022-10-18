//
//  AddItemTableViewCell.swift
//  OSCAR
//
//  Created by Mostafa Samir on 08/08/2021.
//

import UIKit

class AddItemTableViewCell: UITableViewCell {
    @IBOutlet weak var checkListTextField: UITextField!
    @IBOutlet weak var listItem: UILabel!
    var checkList: CheckList?
    
    var isTextFieldHidden: Bool {
        return checkListTextField.isHidden
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkListTextField.delegate = self
    }
    
    func configure(with checkList: CheckList?) {
        self.checkList = checkList
    }
    
    func showTextField(isHidden: Bool) {
        listItem.isHidden = !isHidden
        checkListTextField.isHidden = isHidden
    }
   
}

extension AddItemTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(textField.text?.isEmpty ?? true) {
            if let checkList = checkList {
                let checklistItem = CheckListItem(title: textField.text ?? "",
                                                  checkList: checkList)
                RealmHelper.shared.edit(checkList: checkList, with: checklistItem)
                showTextField(isHidden: true)
                if let viewController = viewContainingController() as? CheckListViewController {
                    
                    viewController.checkListTableView.reloadData()
                }
                textField.text = ""
            }
        }
    }
}

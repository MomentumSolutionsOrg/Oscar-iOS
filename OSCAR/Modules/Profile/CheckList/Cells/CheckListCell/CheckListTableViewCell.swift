//
//  CheckListTableViewCell.swift
//  OSCAR
//
//  Created by Mostafa Samir on 08/08/2021.
//

import UIKit

protocol CheckListUpdateDelegate: AnyObject {
    func updateTableView()
}


class CheckListTableViewCell: UITableViewCell {
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField! {
        didSet {
            titleTextField.delegate = self
        }
    }
    @IBOutlet weak var checkListItemsTableView: SelfSizedTableView! {
        didSet {
            setupTableView()
        }
    }
    var checkList: CheckList?
    var isEmpty = false {
        didSet {
            if isEmpty {
                pinButton.isEnabled = false
                deleteButton.isEnabled = false
                self.titleTextField.text = ""
                pinButton.tintColor = UIColor(hexString: "#A0A0A0")
                pinButton.transform = .identity
            }else {
                pinButton.isEnabled = true
                deleteButton.isEnabled = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupTableView() {
        checkListItemsTableView.dataSource = self
        checkListItemsTableView.delegate = self
        checkListItemsTableView.registerCellNib(cellClass: CheckListItemTableViewCell.self)
        checkListItemsTableView.registerCellNib(cellClass: AddItemTableViewCell.self)
    }
    
    func configure(with checkList: CheckList ) {
        self.checkList = checkList
        self.titleTextField.text = checkList.title
        if checkList.isPinned {
            pinButton.tintColor = UIColor.blueColor
            pinButton.transform = .identity
        }else {
            pinButton.tintColor = UIColor(hexString: "#A0A0A0")
            pinButton.transform = CGAffineTransform(rotationAngle: .pi / 4)
        }
        self.checkListItemsTableView.reloadData()
    }
    
    func configureEmpty() {
        self.checkList = nil
        isEmpty = true
        self.checkListItemsTableView.reloadData()
    }
    
    @IBAction func pinButtonTapped(_ sender: Any) {
        if let checkList = checkList {
            RealmHelper.shared.edit(checkList: checkList, with: nil, pinned: !checkList.isPinned)
            if let vc = viewContainingController() as? CheckListViewController {
                vc.checkListTableView.reloadData()
            }
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let checkList = checkList {
            RealmHelper.shared.deleteItem(item: checkList)
            if let vc = viewContainingController() as? CheckListViewController {
                vc.checkListTableView.reloadData()
            }
        }
    }
}


extension CheckListTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AddItemTableViewCell,
           !isEmpty {
            if cell.isTextFieldHidden {
                cell.showTextField(isHidden: false)
                tableView.reloadData()
            } else {
                cell.checkListTextField.resignFirstResponder()
            }
        }else if let checkListItem = checkList?.items[indexPath.row],
                 let checkList = checkList {
            RealmHelper.shared.changeCheck(for: checkListItem, inside: checkList)
            if let vc = viewContainingController() as? CheckListViewController {
                vc.checkListTableView.reloadData()
            }
        }
    }
}

extension CheckListTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (checkList?.items.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == (checkList?.items.count ?? 0) {
            let cell = tableView.dequeue() as AddItemTableViewCell
            cell.configure(with: checkList)
            return cell
        }else {
            let cell = tableView.dequeue() as CheckListItemTableViewCell
            cell.configure(with: checkList?.items[indexPath.row])
            return cell
        }
    }
}


extension CheckListTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(textField.text?.isEmpty ?? true) {
            if let checkList = checkList {
                RealmHelper.shared.edit(checkList: checkList, with: nil)
            }else {
                let checkList = CheckList(title: textField.text ?? "N/A")
                RealmHelper.shared.add(checkList: checkList, checkListItems: [])
            }
            if let viewController = viewContainingController() as? CheckListViewController {
                viewController.checkListTableView.reloadData()
            }
            isEmpty = false
        }
    }
}

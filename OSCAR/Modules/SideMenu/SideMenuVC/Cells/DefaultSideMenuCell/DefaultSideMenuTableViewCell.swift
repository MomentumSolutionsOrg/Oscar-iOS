//
//  DefaultSideMenuTableViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 27/06/2021.
//

import UIKit

class DefaultSideMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var topView: UIView!
//    @IBOutlet weak var subcategoriesTableView: UITableView!
//    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    
    var indexPath:IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        guard let table = object as? UITableView else { return }
//        tableViewHeight.constant = table.contentSize.height
//        stackView.setNeedsLayout()
//    }
    
    func setup(with indexPath:IndexPath) {
        self.indexPath = indexPath
        switch indexPath.row {
//        case 0://Home
//            titleLabel.text = "Home"
//            plusLabel.isHidden = true
//            topView.isHidden = true
        case 0://Departments
            titleLabel.text = "Departments".localized.uppercased()
            plusLabel.isHidden = false
            topView.isHidden = true
//        case 2://Live chat
//            titleLabel.text = "Live chat"
//            plusLabel.isHidden = true
//            topView.isHidden = false
//        case 2:// Language
//            titleLabel.text = "Language"
//            plusLabel.isHidden = true
//            topView.isHidden = false
//        case 4:// Restaurants
//            titleLabel.text = "Restaurants"
//            plusLabel.isHidden = true
//            topView.isHidden = false
        case 1://about us
            titleLabel.text = "about_us".localized
            plusLabel.isHidden = true
            topView.isHidden = false
        case 2://contact us
            titleLabel.text = "contact_us".localized
            plusLabel.isHidden = true
            topView.isHidden = true
        case 3://How to use the app
            titleLabel.text = "How_to_use_the_app".localized
            plusLabel.isHidden = true
            topView.isHidden = true
        case 4://terms and conditions
            titleLabel.text = "terms_and_conditions".localized
            plusLabel.isHidden = true
            topView.isHidden = true
        default:
            break
        }
    }
    
//    func showSubcategories() {
//        if plusLabel.text == "+" {
//            subcategoriesTableView.isHidden = false
//            plusLabel.text = "-"
//        }else {
//            subcategoriesTableView.isHidden = true
//            plusLabel.text = "+"
//        }
//    }
}


//extension DefaultSideMenuTableViewCell: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categories.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeue() as ExpandingSideMenuTableViewCell
//        return cell
//    }
//
//
//}
//
//extension DefaultSideMenuTableViewCell: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) as? ExpandingSideMenuTableViewCell {
//            cell.showSubcategories()
//        }
//    }
//}

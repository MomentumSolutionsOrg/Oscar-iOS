//
//  FilterSelectionTableViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 07/07/2021.
//

import UIKit

class FilterSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                numberLabel.textColor = UIColor.blueColor
                nameLabel.textColor = UIColor.blueColor
                checkImageView.isHidden = false
                print("selection ----- > true")
            }else {
                numberLabel.textColor = UIColor.blackTextColor
                nameLabel.textColor = UIColor.blackTextColor
                checkImageView.isHidden = true
                print("selection ----- > false")
            }
        }
    }
    
    func configureCell(with category:MainCategory) {
        nameLabel.text = category.name
        numberLabel.text = "(\(category.count?.description ?? "0"))"
    }
    
    func configureCell(with name:String) {
        nameLabel.text = name
        numberLabel.isHidden = true
    }
}

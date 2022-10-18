//
//  CheckListTableViewCell.swift
//  OSCAR
//
//  Created by Mostafa Samir on 08/08/2021.
//

import UIKit

class CheckListItemTableViewCell: UITableViewCell {
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with checklistItem: CheckListItem?) {
        itemNameLabel.text = checklistItem?.title
        checkImage.image = (checklistItem?.isChecked ?? false) ? #imageLiteral(resourceName: "check-bok-red") : #imageLiteral(resourceName: "Rectangle 218")
    }
  
}

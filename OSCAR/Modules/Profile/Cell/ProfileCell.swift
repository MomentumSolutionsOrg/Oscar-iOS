//
//  ProfileCell.swift
//  OSCAR
//
//  Created by Asmaa Tarek on 27/06/2021.
//

import UIKit

class ProfileCell: UITableViewCell {

    
    @IBOutlet private  weak var itemImage: UIImageView!
    @IBOutlet private weak var itemLabel: UILabel!
    
    func configureCell(item: Constants.ProfileItems) {
        itemImage.image = UIImage(named: item.rawValue)
        itemLabel.text = item.rawValue.localized
    }
}

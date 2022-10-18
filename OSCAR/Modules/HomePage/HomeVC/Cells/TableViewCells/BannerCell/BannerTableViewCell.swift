//
//  BannerTableViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 07/07/2021.
//

import UIKit

class BannerTableViewCell: UITableViewCell {

    @IBOutlet weak var bannerImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerImageView: RoundedImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bannerImageHeightConstraint.constant = UIScreen.main.bounds.height * 0.15
    }

    func configureCell(with slider:Slider) {
        bannerImageView.setImage(with: slider.image ?? "")
    }
    
}

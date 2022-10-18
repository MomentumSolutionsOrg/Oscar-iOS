//
//  BannersCollectionViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 23/06/2021.
//

import UIKit

class BannersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(with slider: Slider) {
        bannerImageView.setImage(with: slider.image ?? "")
        
    }

}

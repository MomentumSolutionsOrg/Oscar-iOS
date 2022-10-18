//
//  SliderCollectionViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 07/07/2021.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sliderImageView: RoundedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sliderImageView.image = nil
    }
    
    func configureCell(with slider:Slider) {
        if let image = slider.image {
//            let newImage = image.replacingOccurrences(of: "http://", with: "https://")
            sliderImageView.setImage(with: image)
        }
    }

}

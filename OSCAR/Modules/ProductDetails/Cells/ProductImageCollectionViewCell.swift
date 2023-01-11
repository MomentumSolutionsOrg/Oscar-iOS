//
//  ProductImageCollectionViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 05/07/2021.
//

import UIKit

class ProductImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with image: String) {
        
        productImageView.setImage(with: image)
        
    }

}

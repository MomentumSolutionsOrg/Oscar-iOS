//
//  CategoryProductCollectionViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 28/06/2021.
//

import UIKit

class CategoryProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productImageView: CircleImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        subView.layer.cornerRadius = 20
        subView.clipsToBounds = true
        
    }
    func configure(with product:Product) {
        productNameLabel.text = product.name
        productPriceLabel.text = "EGP".localized + " " + (product.regularPrice ?? "0.0")
        productImageView.setImage(with: product.images.first?.src ?? "")
    }
}

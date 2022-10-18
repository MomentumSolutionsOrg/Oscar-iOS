//
//  WishListCollectionViewCell.swift
//  OSCAR
//
//  Created by Mostafa Samir on 09/08/2021.
//

import UIKit

class WishListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var borderView: BorderView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var outOfStockLabel: UILabel!
    
    weak var delegate: WishListDelegate?
    var productId = "1"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        outOfStockLabel.text = "out_of_stock".localized
    }
    func configureCell(with product:Product, selected: Bool) {
        self.productId = product.id ?? "1"
        productImageView.setImage(with: product.images.first?.src ?? "")
        productNameLabel.text = product.name
        productPriceLabel.text = "\("EGP".localized) " + (product.regularPrice ?? "")
        borderView.showBorder = selected
        if product.inStock == "1" {
            addToCartButton.isHidden = false
            outOfStockLabel.isHidden = true
        }else {
            addToCartButton.isHidden = true
            outOfStockLabel.isHidden = false
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        Utils.shareProduct(with: productId)
    }
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        delegate?.addToCart(for: productId)
    }
    @IBAction func removeButtonTapped(_ sender: Any) {
        delegate?.remove(for: productId)
    }
    
}

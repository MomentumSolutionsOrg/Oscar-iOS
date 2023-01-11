//
//  ListCollectionViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 27/06/2021.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var outOfStockLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    private var product: Product?
    weak var delegate: ProductCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outOfStockLabel.text = "out_of_stock".localized
    }
    func configureCell(with product:Product) {
        self.product = product
        if let image = product.standard.image {
            productImageView.setImage(with: image)
        }
        productNameLabel.text = product.name
        let price = product.standard.price ?? 0.0
        let discountPrice = product.standard.discountPrice ?? 0
        
        if product.standard.discountPrice == 0 {
            discountLabel.text = ""
            productPriceLabel.text = "EGP".localized + " " + price.currency
        } else {
            discountLabel.text = ("EGP".localized + " " + price.currency)
            productPriceLabel.text = "EGP".localized + " " + discountPrice.currency
        }
        if product.inStock == 1 {
            addToCartButton.isHidden = false
            outOfStockLabel.isHidden = true
        }else {
            addToCartButton.isHidden = true
            outOfStockLabel.isHidden = false
        }
    }
    @IBAction func cartButtonTapped(_ sender: Any) {
        delegate?.addToCart(product: product)
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        Utils.shareProduct(with: product?.productID ?? "")
    }
}

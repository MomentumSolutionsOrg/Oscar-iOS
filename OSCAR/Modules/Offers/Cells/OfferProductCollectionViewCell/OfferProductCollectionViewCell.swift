//
//  OfferProductCollectionViewCell.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//

import UIKit

class OfferProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var priceBeforeLabel: UILabel!
    
    private var isLiked = false
    private var id = "1"
    
    func configureCell(with product: Product) {
        if let image = product.standard.image {
            productImageView.setImage(with: image)
        }
        productNameLabel.text = product.name
        if let productID = product.productID {
            self.id = productID
        }
        let price = product.standard.price ?? 0.0
        let discountPrice = product.standard.discountPrice ?? 0
        if product.standard.discountPrice == 0 {
            priceBeforeLabel.text = ""
            productPriceLabel.text = "EGP".localized + " " + price.currency
        } else {
            priceBeforeLabel.text = "EGP".localized + " " + price.currency
            productPriceLabel.text = "EGP".localized + " " + discountPrice.currency
        }
        if let liked = product.liked {
            self.isLiked = liked
            let image = liked ? #imageLiteral(resourceName: "icon-favorite_24px") : #imageLiteral(resourceName: "icon-action-favorite_24px")
            favoriteButton.setImage(image, for: .normal)
        }
    }
    @IBAction func cartButtonTapped(_ sender: Any) {
        if let viewController = viewContainingController() as? OffersViewController {
            viewController.addToCart(id: id)
        }
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        Utils.shareProduct(with: id)
    }
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        if let viewController = viewContainingController() as? OffersViewController {
            if isLiked {
                viewController.removeFromWishList(id: id)
            }else {
                viewController.addToWishlist(id: id)
            }
        }
    }
}

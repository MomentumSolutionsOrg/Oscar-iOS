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
        productImageView.setImage(with: product.images.first?.src ?? "")
        productNameLabel.text = product.name
        self.id = product.id ?? "1"
        if product.discountPrice == "0" {
            priceBeforeLabel.text = ""
            productPriceLabel.text = "EGP".localized + " " + (product.regularPrice ?? "")
        } else {
            priceBeforeLabel.text = "EGP".localized + " " + (product.regularPrice ?? "")
            productPriceLabel.text = "EGP".localized + " " + (product.discountPrice ?? "")
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

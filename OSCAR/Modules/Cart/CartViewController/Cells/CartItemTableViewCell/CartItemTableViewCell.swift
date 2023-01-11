//
//  CartItemTableViewCell.swift
//  OSCAR
//
//  Created by Mostafa Samir on 09/08/2021.
//

import UIKit
protocol CartCellDelegate: AnyObject {
    func updateItem(at index: Int, with quantity: Int)
}

class CartItemTableViewCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productWeightLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
    weak var delegate: CartCellDelegate?
    var quantity = 1.0
    var index = 0
    var id = ""
    func configure(with product: Product, indexPath: IndexPath) {
        self.quantity = Double(product.standard.quantity ?? "") ?? 1.0
        if let productID = product.productID {
            self.id = productID
        }
        
        self.index = indexPath.row
        let quantity = Double(product.standard.quantity ?? "") ?? 1.0
        productQuantityLabel.text = quantity.description
        if let image = product.standard.image {
            productImageView.setImage(with: image)
        }
        productNameLabel.text = product.name
        if product.standard.quantity == "0" {
            productWeightLabel.isHidden = true
        }else {
            productWeightLabel.isHidden = false
            productWeightLabel.text = (product.standard.quantity ?? "") + " " + (product.unit ?? "")
            //"gram".localized
        }
        //😭
//        if let total = product.total {
//            let roundedTotal = round(total * 100) / 100
//            productPriceLabel.text = "EGP".localized + " " + (roundedTotal.description)
//        }
    }
    
    @IBAction func changeQuantityTapped(_ sender: UIButton) {
        delegate?.updateItem(at: index, with: sender.tag)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        Utils.shareProduct(with: id)
    }
}

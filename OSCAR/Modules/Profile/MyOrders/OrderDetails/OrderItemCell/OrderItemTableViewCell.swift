//
//  OrderItemTableViewCell.swift
//  OSCAR
//
//  Created by Mostafa Samir on 04/08/2021.
//

import UIKit

class OrderItemTableViewCell: UITableViewCell {
    @IBOutlet weak var orderItemNameLabel: UILabel!
    @IBOutlet weak var orderItemQuantityLabel: UILabel!
    @IBOutlet weak var orderItemPriceLabel: UILabel!
    
    func configureCell(with product: Product) {
        orderItemNameLabel.text = product.name
        orderItemQuantityLabel.text = (product.quantity?.description ?? "1") + "x"
        orderItemPriceLabel.text = "EGP".localized + " " + (product.total?.description ?? "0.0")
    }
    
}

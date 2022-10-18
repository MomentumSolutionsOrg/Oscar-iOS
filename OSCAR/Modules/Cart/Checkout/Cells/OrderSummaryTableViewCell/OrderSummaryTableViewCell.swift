//
//  OrderSummaryTableViewCell.swift
//  OSCAR
//
//  Created by Mostafa Samir on 11/08/2021.
//

import UIKit

class OrderSummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceQuantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with product: Product) {
        self.productNameLabel.text = product.name
        let quantity = (product.quantity ?? 1).description
        let price = round(((product.total ?? 1.0) / (Double(product.quantity ?? 1))) * 100) / 100
        priceQuantityLabel.text = quantity + " x " + price.description + " \("EGP".localized)"
    }
}

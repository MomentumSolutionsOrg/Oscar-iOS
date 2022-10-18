//
//  PaymentMethodCollectionViewCell.swift
//  OSCAR
//
//  Created by Mostafa Samir on 08/08/2021.
//

import UIKit

class PaymentMethodCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var borderView: BorderView!
    @IBOutlet weak var paymentTypeImageView: UIImageView!
    @IBOutlet weak var paymentTypeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with paymentType: Constants.PaymentMethodTypes ) {
        switch paymentType {
        case .cashOnDelivery:
            paymentTypeImageView.image = #imageLiteral(resourceName: "cash")
            paymentTypeName.text = "pay_cash_on-delivery".localized
        case .cardUponDelivery:
            paymentTypeImageView.image = #imageLiteral(resourceName: "pos")
            paymentTypeName.text = "pay_card_upon_delievery".localized
        case .visa:
            break
        }
        
        if paymentType.rawValue == CurrentUser.shared.defaultPaymentType {
            borderView.backgroundColor = .white
            borderView.showBorder = true
            paymentTypeName.textColor = UIColor.blueColor
        }else {
            borderView.backgroundColor = UIColor.lightBackground
            borderView.showBorder = false
            paymentTypeName.textColor = UIColor.blackTextColor
        }
    }

}

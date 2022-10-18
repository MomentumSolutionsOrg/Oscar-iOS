//
//  VoucherTableViewCell.swift
//  OSCAR
//
//  Created by Mostafa Samir on 05/08/2021.
//

import UIKit

class VoucherTableViewCell: UITableViewCell {
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var voucherNameLabel: UILabel!
    @IBOutlet weak var voucherDiscountTypeLabel: UILabel!
    @IBOutlet weak var voucherStartDateLabel: UILabel!
    @IBOutlet weak var voucherEndDateLabel: UILabel!
    @IBOutlet weak var voucherDiscountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadowToBackGroundImage()
        voucherDiscountLabel.transform = CGAffineTransform(rotationAngle: -(.pi / 9))
    }
    
    func configureCell(with voucher: Voucher) {
        voucherNameLabel.text = voucher.name
        voucherDiscountTypeLabel.text = voucher.voucherType
        voucherStartDateLabel.text = voucher.from
        voucherEndDateLabel.text = voucher.to
        var discountDescription = (voucher.discountNumber?.description ?? "0")
        discountDescription +=  " " + (voucher.voucherType ?? "EGP".localized)
        discountDescription += " " + "off".localized
        voucherDiscountLabel.text = discountDescription
    }
    
    func addShadowToBackGroundImage() {
        backGroundImageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        backGroundImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backGroundImageView.layer.shadowRadius = 2
        backGroundImageView.layer.shadowOpacity = 0.09
        backGroundImageView.layer.masksToBounds = false
    }
    
}

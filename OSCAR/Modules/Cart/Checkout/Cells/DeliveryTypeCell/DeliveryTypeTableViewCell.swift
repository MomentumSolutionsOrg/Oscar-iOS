//
//  DeliveryTypeTableViewCell.swift
//  OSCAR
//
//  Created by Mostafa Samir on 13/09/2021.
//

import UIKit

class DeliveryTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var TypeNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with deliveryFee: DeliveryFees, selection:Bool, scheduleDate: Date?) {
        if LanguageManager.shared.isArabicLanguage() {
            TypeNameLabel.text = deliveryFee.flagArabic
        }else {
            TypeNameLabel.text = deliveryFee.flag
        }
        priceLabel.text = (deliveryFee.cost ?? "20") + " " + "EGP".localized
        
        if selection {
            TypeNameLabel.textColor = UIColor.blueColor
            checkImageView.image = #imageLiteral(resourceName: "checkImage")
        }else {
            TypeNameLabel.textColor = UIColor.blackTextColor
            checkImageView.image = #imageLiteral(resourceName: "emptyCheck")
        }
        dateLabel.text = scheduleDate?.convertDateToString(format: Constants.Format.fullDate)
        timeLabel.text = scheduleDate?.convertDateToString(format: Constants.Format.timeFormat)
        
        if deliveryFee.flag?.contains(Constants.DeliveryTypes.schedule.rawValue)  ?? false {
            dateLabel.isHidden = false
            timeLabel.isHidden = false
        }else {
            dateLabel.isHidden = true
            timeLabel.isHidden = true
        }
    }
    
}

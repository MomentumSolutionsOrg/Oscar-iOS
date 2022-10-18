//
//  BottomShadowView.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 23/06/2021.
//

import UIKit

class BottomShadowView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.lightBackground
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.09
        //shadowView.layer.cornerRadius = 20.0
        self.layer.masksToBounds = false
    }
}

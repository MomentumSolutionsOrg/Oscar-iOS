//
//  ShadowView.swift
//  Expert
//
//  Created by Momentum Solutions Co. on 06/06/2021.
//  Copyright © 2021 Mostafa Samir. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.09
        //shadowView.layer.cornerRadius = 20.0
        self.layer.masksToBounds = false
    }
}

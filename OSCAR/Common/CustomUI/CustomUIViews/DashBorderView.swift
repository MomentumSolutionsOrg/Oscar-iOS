//
//  DashBorderView.swift
//  Expert
//
//  Created by Momentum Solutions Co. on 06/06/2021.
//  Copyright © 2021 Mostafa Samir. All rights reserved.
//

import UIKit

class DashBorderView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let border = CAShapeLayer()
        border.strokeColor = UIColor.black.cgColor
        border.lineDashPattern = [5, 5]
        border.frame = self.bounds
        border.fillColor = nil
        border.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(border)
    }
}

//
//  RoundedImageView.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 24/06/2021.
//

import UIKit

class RoundedImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 15
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}

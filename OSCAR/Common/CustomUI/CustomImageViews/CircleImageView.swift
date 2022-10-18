//
//  CircleImageView.swift
//  Expert
//
//  Created by Momentum Solutions Co. on 08/06/2021.
//  Copyright © 2021 Mostafa Samir. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
    }
}

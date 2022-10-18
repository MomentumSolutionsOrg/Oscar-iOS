//
//  UnderLinedLabel.swift
//  Expert
//
//  Created by Momentum Solutions Co. on 04/06/2021.
//  Copyright © 2021 Mostafa Samir. All rights reserved.
//

import UIKit

class UnderlinedLabel: UILabel {
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSRange(location: 0, length: text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.underlineStyle,
                                        value: NSUnderlineStyle.single.rawValue,
                                        range: textRange)
            self.attributedText = attributedText
        }
    }
}

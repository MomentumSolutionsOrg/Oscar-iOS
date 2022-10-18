//
//  BackGroundButton.swift
//  Expert
//
//  Created by Momentum Solutions Co. on 31/05/2021.
//  Copyright © 2021 Mostafa Samir. All rights reserved.
//

import UIKit

class BackGroundButton: RoundedButton {
    
    @IBInspectable var forceRTL:Bool = false
    @IBInspectable var fontSize:Int = 18
    @IBInspectable var capitalize:Bool = true
    @IBInspectable var isRedButton: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if forceRTL {
            self.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    override func didMoveToWindow() {
        if capitalize {
            self.setTitle(self.title(for: .normal)?.uppercased(), for: .normal)
        }
    }
    
    func setupView() {
        self.backgroundColor = isRedButton ? UIColor.redColor: UIColor.blueColor
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont(name: "Oswald-Bold", size: CGFloat(fontSize))
        //self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
}

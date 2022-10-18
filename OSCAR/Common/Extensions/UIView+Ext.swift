//
//  UIView+Ext.swift
//  Expert
//
//  Created by Mac Store Egypt on 30/05/2021.
//  Copyright © 2021 Mostafa Samir. All rights reserved.
//

import UIKit

extension UIView{
    func animateRotation(){
        UIView.animate(withDuration:0.5, animations: { () -> Void in
            if self.transform == .identity {
                self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 0.4999))
            }else{
                self.transform = .identity
            }
        })
    }
    
    func makeRoundCorner(borderColor: UIColor?, borderWidth: CGFloat, cornerRadius: CGFloat) {
        if let color = borderColor {
            self.layer.borderColor = color.cgColor
        }
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    func makeShadow() {
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
    }
    
    func loadNibView() {
        self.loadNibView(name: String(describing: type(of: self)))
    }
    
    func loadNibView(name: String) {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: name, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        nibView.frame = bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        nibView.translatesAutoresizingMaskIntoConstraints = true
        nibView.backgroundColor = .clear
        addSubview(nibView)
        
    }
}

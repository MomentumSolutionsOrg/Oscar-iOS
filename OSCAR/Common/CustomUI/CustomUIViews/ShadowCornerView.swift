//
//  ShadowCornerView.swift
//  ExhibitSmart
//
//  Created by Asmaa Tarek on 10/05/2021.
//

import UIKit

// MARK: - ShadowCornerView

class ShadowCornerView: UIView {
    
    // MARK: - View Lifecycle

    @IBInspectable public var cornerRadius: CGFloat = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        setupview()
    }
    
    // MARK: - Helper Methods

    private func setupview() {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        //rgba(51, 135, 95, 0.16)
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
    }
}

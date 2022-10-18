//
//  TopBackView.swift
//  Clozzit
//
//  Created by Momentum Solution Mac Mini on 2/11/21.
//  Copyright © 2021 Mostafa Samir. All rights reserved.
//

import UIKit

class TopBackView: UIView {
    let titleLabel = UILabel()
    let backButton = UIButton()
    
    @IBInspectable var labelText:String? {
        didSet {
            titleLabel.text = labelText
        }
    }
    
    @IBInspectable var hasShadow:Bool = false {
        didSet {
            if hasShadow {
                addShadow()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
    }
    
    func addShadow() {
        self.backgroundColor = UIColor.lightBackground
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.09
        self.layer.masksToBounds = false
    }
    
    func setupViews() {
        self.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = UIColor(hexString: "#6D6E71")
        titleLabel.numberOfLines = 0
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
        
        layoutUI()
    }
    
    func layoutUI() {
        addSubview(titleLabel)
        addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 15),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            
        ])
    }
    
    @objc private func backButtonTapped() {
        if let viewController = viewContainingController() {
            viewController.pop()
        }
    }
}




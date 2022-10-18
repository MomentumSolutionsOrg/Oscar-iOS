//
//  CustomTextView.swift
//  VODO
//
//  Created by Momentum Solutions Co. on 01/06/2021.
//  Copyright © 2021 Momentum Solution Mac Mini. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {
    @IBInspectable var placeHolder:String = "" {
        didSet {
            text = placeHolder.localized
            textColor = UIColor.lightGrayColor
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        delegate = self
    }
}

extension CustomTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolder.localized {
            textView.text = ""
            textView.textColor = UIColor.blackTextColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeHolder.localized
            textView.textColor = UIColor.lightGrayColor
        }else {
            textView.textColor = UIColor.blackTextColor
        }
    }
}

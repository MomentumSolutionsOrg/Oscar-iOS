//
//  CheckoutSuccessViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 16/08/2021.
//

import UIKit

protocol CheckoutSuccessDelegate: AnyObject {
    func myOrdersSelected()
    func continueShoppingSelected()
}

class CheckoutSuccessViewController: BaseViewController {
    @IBOutlet weak var mainView: UIView!
    weak var delegate: CheckoutSuccessDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(dismissView)))
    }
    
    @IBAction func continueShoppingButtonTapped(_ sender: Any) {
        delegate?.continueShoppingSelected()
    }
    @IBAction func myOrdersButtonTapped(_ sender: Any) {
        delegate?.myOrdersSelected()
    }
    
}

//
//  CancelPopUpViewController.swift
//  OSCAR
//
//  Created by User on 19/08/2021.
//

import UIKit

class CancelPopUpViewController: BaseViewController {
    
    @IBOutlet weak var messageOutlet: UILabel!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet weak var purposeOutlet: UILabel!
    @IBOutlet weak var okButtonOutlet: BackGroundButton!
    @IBOutlet weak var cornerView: ShadowCornerView!
    
    var flag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        messageOutlet.text = "Kindly contact us on".localized
        if flag == 1 {
            cornerView.frame = CGRect(x: 0, y: 0, width: self.cornerView.frame.width, height: self.cornerView.frame.height - 40.0)
            purposeOutlet.isHidden = true
            //okButtonOutlet.isHidden = true
        }
    }
    
  
    @IBAction private func callAction(_ sender: UIButton) {
        if let url = URL(string: "tel://\(Constants.hotline)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    @IBAction private func okAction(_ sender: BackGroundButton) {
        dismissView()
    }
}

fileprivate extension CancelPopUpViewController {
    
    func setupView() {
        mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
    }
}

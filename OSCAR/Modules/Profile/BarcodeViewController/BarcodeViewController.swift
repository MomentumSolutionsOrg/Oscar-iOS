//
//  BarcodeViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//

import UIKit

class BarcodeViewController: UIViewController {
    @IBOutlet weak var barcodeImageView: UIImageView!
    @IBOutlet weak var barcodeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    func setData() {
        guard let user = CurrentUser.shared.user else { return }
        barcodeLabel.text = user.accountNo
        barcodeImageView.image = user.accountNo?.generateBarcode()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss()
    }
}

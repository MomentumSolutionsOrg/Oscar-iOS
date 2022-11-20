//
//  DeleteAccountConfirmationVC.swift
//  OSCAR
//
//  Created by aalaa on 20/07/2022.
//

import UIKit

class DeleteAccountConfirmationVC: UIViewController {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var continueButton: BackGroundButton!
    @IBOutlet weak var deletionBlackAlert: UILabel!
    
    var isChecked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkButton.contentMode = .scaleAspectFit
        checkButton.layer.borderColor = UIColor.black.cgColor
        checkButton.layer.borderWidth = 1
        checkButton.layer.cornerRadius = checkButton.frame.width/2

        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction private func backAction(_ sender: UIButton) {
        pop()
    }

    @IBAction func checkTapped(_ sender: Any) {
        
        if !isChecked {
            checkButton.setImage(UIImage(named: "checkImage"), for: .normal)
            checkButton.layer.borderColor = UIColor.clear.cgColor
            isChecked = true
            print("is checked is false")

        } else {
            print("is checked is truer")
            checkButton.setImage(nil, for: .normal)
            checkButton.layer.borderColor = UIColor.black.cgColor
            isChecked = false
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        if !isChecked {
            UIView.animate(withDuration: 0.25) {
                self.deletionBlackAlert.alpha = 0.5
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    
                    UIView.animate(withDuration: 0.25) {
                        self.deletionBlackAlert.alpha = 0
                    }
                }
            }
            
        } else {
            guard let url = URL(string: NetworkConstants.removeAccountURL) else {
                 return
            }

            if UIApplication.shared.canOpenURL(url) {
                 UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

}

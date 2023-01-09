//
//  SignUpVC.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 20/06/2021.
//

import UIKit

class PhoneVC: BaseViewController {

    @IBOutlet weak var phoneTF: GeneralTextField!
    
    let viewModel = AuthViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func setup() {
        setupViewModel(viewModel: viewModel)
    }
    @IBAction func verifyButtonTapped(_ sender: Any) {
        
        viewModel.phoneNumber =  (phoneTF.text ?? "")
        self.showLoadingView()
        viewModel.sendCode { [weak self] error in
            guard let self = self else { return }
            self.dismissLoadingView()
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                }else {
                    self.push(self.viewModel.createPhoneVerificationVC())
                }
            }
        }
    }
}

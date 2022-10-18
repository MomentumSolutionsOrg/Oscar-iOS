//
//  SignUpVC.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 22/06/2021.
//

import UIKit

class SignUpVC: BaseViewController {
    @IBOutlet weak var nameTF: GeneralTextField!
    @IBOutlet weak var emailTF: GeneralTextField!
    @IBOutlet weak var passTF: GeneralTextField!
    @IBOutlet weak var passConfirmTF: GeneralTextField!
    @IBOutlet weak var referralTF: GeneralTextField!
    var viewmodel:AuthViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewmodel()
        
    }
    
    private func setupViewmodel() {
        setupViewModel(viewModel: viewmodel)
        viewmodel.defaultcompletion = { [weak self] in
            self?.setTabbar()
        }
    }
    
    @IBAction func signupBtnTapped(_ sender: Any) {
        if emailTF.text == "" ||
            nameTF.text == "" ||
            passTF.text == "" ||
            passConfirmTF.text == ""
            {
            showToast(message: "fill_all_fields".localized)
        }else {
            if passTF.text != passConfirmTF.text {
                showToast(message: "passwords_donot_match".localized)
            }else {
                viewmodel.signUp(params: SignUpParams(name: nameTF.text ?? "",
                                                      phone: viewmodel.phoneNumber,
                                                      email: emailTF.text ?? "",
                                                      password: passTF.text ?? "",
                                                      referralId: referralTF.text ?? ""))
            }
        }
    }
}

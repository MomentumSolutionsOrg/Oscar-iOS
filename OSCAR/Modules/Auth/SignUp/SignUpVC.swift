//
//  SignUpVC.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 22/06/2021.
//

import UIKit

class SignUpVC: BaseViewController {

    @IBOutlet weak var userNameTF: GeneralTextField!
    @IBOutlet weak var emailTF: GeneralTextField!
    @IBOutlet weak var phoneNumberTF: GeneralTextField!
    @IBOutlet weak var passTF: GeneralTextField!
    @IBOutlet weak var passConfirmTF: GeneralTextField!
    @IBOutlet weak var referralTF: GeneralTextField!
    
    
    var viewmodel:AuthViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneNumberTF.text = viewmodel.phoneNumber
        
        setupViewmodel()
        
    }
    
    private func setupViewmodel() {
        setupViewModel(viewModel: viewmodel)
        viewmodel.defaultcompletion = { [weak self] in
            self?.setTabbar()
        }
    }
    
    @IBAction func signupBtnTapped(_ sender: Any) {
        
        guard let emailText = emailTF.text,
              let phoneText = phoneNumberTF.text,
              let userNameText = userNameTF.text,
              let passText = passTF.text,
              let confirmPassText = passConfirmTF.text,
              let referralText = referralTF.text else { return }
        
        if emailText.isEmptyText() ||
            phoneText.isEmptyText() ||
            userNameText.isEmptyText() ||
            passText.isEmptyText() ||
            confirmPassText.isEmptyText() {
            
            showToast(message: "fill_all_fields".localized)
            
        } else {
            
            if passTF.text != passConfirmTF.text {
                showToast(message: "passwords_donot_match".localized)
            }else {
                
                let params = SignUpParams(name: userNameText,
                                          phone: phoneText,
                                          email: emailText,
                                          password: passText,
                                          passwordConfirmation: confirmPassText,
                                          referralID: referralText)
                
                viewmodel.signUp(params: params)
            }
        }
    }
    
    
}

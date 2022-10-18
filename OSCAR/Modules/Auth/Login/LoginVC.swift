//
//  LoginVC.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 20/06/2021.
//

import UIKit

class LoginVC: BaseViewController {

    @IBOutlet weak var emailTF: GeneralTextField!
    @IBOutlet weak var passTF: GeneralTextField!
    @IBOutlet weak var skipBtn: UIButton!
    
    private let viewmodel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        
    }
    func setup() {
//        skipBtn.semanticContentAttribute = .forceRightToLeft
        setupViewModel(viewModel: viewmodel)
        viewmodel.defaultcompletion = { [weak self] in
            self?.setTabbar()
        }
        viewmodel.forgetPassCompletion =  { [weak self] message in
            self?.showToast(message: message)
        }
    }
    @IBAction func loginBtnTapped(_ sender: Any) {
        if emailTF.text != "",
           passTF.text != "" {
            viewmodel.login(email: emailTF.text ?? "", password: passTF.text ?? "")
        }else {
            showToast(message: "fill_all_fields".localized)
        }
    }
    @IBAction func signupTapped(_ sender: Any) {
        push(PhoneVC())
    }
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        if emailTF.text != "" {
            viewmodel.forgetPass(email: emailTF.text ?? "")
        }else {
            showToast(message: "enter_email".localized)
        }
    }
    @IBAction func skipBtnTapped(_ sender: Any) {
        setTabbar()
    }
}

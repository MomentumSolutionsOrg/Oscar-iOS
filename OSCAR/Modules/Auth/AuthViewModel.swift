//
//  LoginViewModel.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 29/06/2021.
//

import FirebaseAuth

class AuthViewModel: BaseViewModel {
    var phoneNumber = ""
    var verificationId = ""
    
    var defaultcompletion:(()->())?
    var forgetPassCompletion:((String)->())?
    
    func login(email:String,password:String) {
        let params = LoginParams(email: email, password: password)
        startRequest(request: AuthApi.login(params),
                     mappingClass: LoginResponse.self) { [weak self] response in
            Utils.saveUserData(response: response)
            self?.defaultcompletion?()
        }
    }
    
    func signUp(params:SignUpParams) {
        startRequest(request: AuthApi.signUp(params),
                     mappingClass: LoginResponse.self) { [weak self] response in
            Utils.saveUserData(response: response)
            self?.defaultcompletion?()
        }
    }
    
    func forgetPass(email:String) {
        // need updates
        startRequest(request: AuthApi.forgetPass(email: email), mappingClass: MessageModel.self) { [weak self] response in
            self?.forgetPassCompletion?(response?.message ?? "Email Sent")
        }
    }
    
    func sendCode(completion: @escaping (Error?)->Void) {
        let phone = "+20" + phoneNumber
        PhoneAuthProvider.provider().verifyPhoneNumber(phone,
                                                       uiDelegate: nil) { [weak self] (verificationID, error) in
          if let error = error {
            completion(error)
          }else {
            self?.verificationId = verificationID ?? ""
            completion(nil)
          }
        }
    }
    
    func verifyCode(code:String,completion: @escaping (Error?)->Void) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: code)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                completion(error)
            }else{
                completion(nil)
            }
        }
    }
    
    func createPhoneVerificationVC()->VerificationCodeVC {
        let vc = VerificationCodeVC()
        vc.viewModel = self
        return vc
    }
    
    func createSignupVC()->SignUpVC {
        let vc = SignUpVC()
        vc.viewmodel = self
        return vc
    }
}

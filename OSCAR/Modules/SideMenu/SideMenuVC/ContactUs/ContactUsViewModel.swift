//
//  ContactUsViewModel.swift
//  OSCAR
//
//  Created by Mostafa Samir on 13/09/2021.
//

import Foundation

class ContactUsViewModel: BaseViewModel {
    
    var successCompletion: ((String)-> Void)?
    var errorCompletion: ((String) -> Void)?
    func sendRequest(with parameter: ContactUsParams) {
        if isValid(parameters: parameter) {
            startRequest(request: AuthApi.contactUs(parameter), mappingClass: MessageModel.self) { [weak self] response in
                self?.successCompletion?(response?.message ?? "contact_us_message".localized)
            }
        }
    }
    private func isValid(parameters: ContactUsParams) -> Bool {
        if parameters.email == "" ||
            parameters.firstName == "" ||
            parameters.lastName == "" ||
            parameters.message == "" ||
            parameters.message == "your_message".localized {
            errorCompletion?("fill_all_fields".localized)
            return false
        }else if !parameters.email.checkEmailRegex() {
            errorCompletion?("email_validation_message".localized)
            return false
        }
        return true
    }
}

//
//  ContactUsViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 07/09/2021.
//

import UIKit
import Alamofire

class ContactUsViewController: BaseViewController {
    @IBOutlet weak var firstParagraphLabel: UILabel!
    @IBOutlet weak var secondParagraphLabel: UILabel!
    @IBOutlet weak var firstNameTextField: GeneralTextField!
    @IBOutlet weak var lastNameTextField: GeneralTextField!
    @IBOutlet weak var emailTextField: GeneralTextField!
    @IBOutlet weak var messageTextView: CustomTextView!
    @IBOutlet weak var sendMessageButton: BackGroundButton!
    
    let viewModel = ContactUsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firstParagraphLabel.text = "contact_us_1".localized
        secondParagraphLabel.text = "contact_us_2".localized
        firstNameTextField.placeholder = "first_name".localized
        lastNameTextField.placeholder = "last_name".localized
        emailTextField.placeholder = "your_email".localized
        sendMessageButton.setTitle("send_message".localized.uppercased(), for: .normal)
        setupViewModel()
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
    @IBAction func sendButtonTapped(_ sender: Any) {
        let parameters = ContactUsParams(email: emailTextField.text ?? "",
                                         firstName: firstNameTextField.text ?? "",
                                         lastName: lastNameTextField.text ?? "",
                                         message: messageTextView.text)
        viewModel.sendRequest(with: parameters)
    }
    
}

private extension ContactUsViewController {
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        
        viewModel.successCompletion = { [weak self] message in
            self?.showAlert(message: message)
            self?.firstNameTextField.text?.removeAll()
            self?.lastNameTextField.text?.removeAll()
            self?.emailTextField.text?.removeAll()
            self?.messageTextView.text.removeAll()
            self?.messageTextView.endEditing(true)
        }
        
        viewModel.errorCompletion = { [weak self] message in
            self?.showAlert(message: message)
        }
    }
}

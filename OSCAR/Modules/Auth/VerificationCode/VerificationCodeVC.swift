//
//  VerificationCodeVC.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 20/06/2021.
//

import UIKit

class VerificationCodeVC: BaseViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var codeTF: GeneralTextField!
    @IBOutlet weak var resendButton: UnderlineButton!
    var count = 0
    var timer:Timer!
    var viewModel:AuthViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViewModel(viewModel: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    func resetTimer() {
        count = 120
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
      }
    @objc func updateTimeLabel() {
        if(count > 0){
            let minutes = String(count / 60)
            var seconds = String(count % 60)
            if seconds == "0" {
                seconds = "00"
            }
            timerLabel.text = minutes + ":" + seconds
            count -= 1
        } else {
          timer.invalidate()
            timerLabel.text = ""
            resendButton.isEnabled = true
        }
      }
    
    @IBAction func verifyBtnTapped(_ sender: Any) {
        
        if codeTF.text != "" {
            showLoadingView()
            viewModel.verifyCode(code: codeTF.text ?? "") { [weak self] error in
                guard let self = self else { return }
                self.dismissLoadingView()
                DispatchQueue.main.async {
                    if let error = error {
                        self.showAlert(message: error.localizedDescription)
                    }else {
                        self.push(self.viewModel.createSignupVC())
                    }
                }
            }
        }else {
            showToast(message: "enter_verfication_code".localized)
            
        }
        
    }
    @IBAction func resendCodeTapped(_ sender: Any) {
        self.showLoadingView()
        viewModel.sendCode { [weak self] error in
            guard let self = self else { return }
            self.dismissLoadingView()
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                }else {
                    self.resendButton.isEnabled = false
                    self.resetTimer()
                }
            }
        }
    }
    @IBAction func contactUsTapped(_ sender: Any)
    {
//        let messageStr = "Kindly contact us on".localized
//        let numString = "16991"
        
//        let redColor = UIColor.red
//        let attributes = [NSAttributedString.Key.foregroundColor: redColor]
//        let attributedQuote = NSAttributedString(string: numString, attributes: attributes)
        
//        showAlert(message: "\(messageStr) ")
        
        let cancelVC = CancelPopUpViewController()
        cancelVC.flag = 1
        cancelVC.modalPresentationStyle = .overCurrentContext
        present(cancelVC, animated: true)
    }
}

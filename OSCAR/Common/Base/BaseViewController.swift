//
//  BaseViewController.swift
//  ExhibitSmart
//
//  Created by Asmaa Tarek on 10/05/2021.
//

import UIKit
import NVActivityIndicatorView
import Toast_Swift
import SafariServices

class BaseViewController: UIViewController {
    
    var containerView:UIView!
    var shopNowView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupViewModel(viewModel: BaseViewModel) {
        
        viewModel.updateLoadingStatus = {[weak self] in
            guard let self = self else {return}
            self.dismissKeyBoard()
            switch viewModel.state {
            case .loading:
                self.showLoadingView()
            case .empty, .error,.populated:
                self.dismissLoadingView()
            }
        }
        
        viewModel.updateError = { [weak self] error in
            self?.dismissKeyBoard()
            self?.dismissLoadingView()
            self?.showAlert(message: error)
            if error.lowercased().contains("unauthenticated") {
                UserDefaultsManager.shared.removeLocalData()
                self?.setRootViewController(vc: LoginVC())
            }
        }
        
        viewModel.checkInternetConnection = {[weak self] in
            self?.dismissKeyBoard()
            self?.dismissLoadingView()
            self?.showToast(message: MyError.noInternet.message.localized)
        }
    }
    
    func showLoadingView(){
        if containerView == nil {
            view.isUserInteractionEnabled = false
            removeShopNow()
            containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(containerView)
            NSLayoutConstraint.activate([
                containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            containerView.backgroundColor = .clear
            
            let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballSpinFadeLoader, color: UIColor.blueColor, padding: 0)
            
            containerView.addSubview(activityIndicator)
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            activityIndicator.startAnimating()
            containerView.updateConstraints()
        }
    }
    
    func dismissLoadingView(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.isUserInteractionEnabled = true
            if let _ = self.containerView {
                self.containerView.removeFromSuperview()
                self.containerView = nil
            }
        }
    }
    
    func showAlertWithAttributed(message: String) {
        let color = UIColor.redColor
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.setValue(color, forKey: "attributedMessage")

        let action = UIAlertAction(title: "OK".localized, style: .default)
        alert.addAction(action)
        DispatchQueue.main.async {[weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK".localized, style: .default)
        alert.addAction(action)
        DispatchQueue.main.async {[weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    func showToast(message: String) {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else {return}
            self.view.makeToast(message, point: self.view.center, title: nil, image: nil, completion: nil)
        }
    }
    
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
    func openSafariView(url: String) {
        guard let url = URL(string: url) else {return}
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .popover
        present(safariVC, animated: true)
    }
    
    
    func showShopNowView(with message: String) {
        if shopNowView == nil {
            shopNowView = UIView(frame: self.view.bounds)
            shopNowView.backgroundColor = UIColor.lightBackground
            
            let messageLabel = UILabel()
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.text = message
            messageLabel.textColor = UIColor.buttonBackground
            messageLabel.textAlignment = .center
            messageLabel.font = .systemFont(ofSize: 12)
            messageLabel.numberOfLines = 0
            shopNowView.addSubview(messageLabel)
            
            let shopNowButton = BackGroundButton()
            //shopNowButton.backgroundColor = UIColor.blueColor
            shopNowButton.translatesAutoresizingMaskIntoConstraints = false
            shopNowButton.setTitle("shop_now".localized, for: .normal)
            shopNowButton.capitalize = false
            shopNowButton.fontSize = 14
            shopNowButton.addTarget(self, action: #selector(shopNowButtonTapped), for: .touchUpInside)
            shopNowView.addSubview(shopNowButton)
            
            NSLayoutConstraint.activate(
                [
                    messageLabel.centerXAnchor.constraint(equalTo: shopNowView.centerXAnchor),
                    messageLabel.centerYAnchor.constraint(equalTo: shopNowView.centerYAnchor),
                    messageLabel.trailingAnchor.constraint(equalTo: shopNowView.trailingAnchor, constant: -10),
                    messageLabel.leadingAnchor.constraint(equalTo: shopNowView.leadingAnchor, constant: 10),
                    
                    shopNowButton.centerXAnchor.constraint(equalTo: shopNowView.centerXAnchor),
                    shopNowButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
                    shopNowButton.heightAnchor.constraint(equalToConstant: 31),
                    shopNowButton.widthAnchor.constraint(equalToConstant: 111),
                ]
            )
            
            self.view.addSubview(shopNowView)
            self.view.bringSubviewToFront(shopNowView)
            self.view.layoutIfNeeded()
        }
    }
    
    func removeShopNow() {
        if let shopNowView = shopNowView {
            shopNowView.removeFromSuperview()
            self.shopNowView = nil
        }
    }
    
    @objc private func shopNowButtonTapped() {
        tabBarController?.selectedIndex = 0
    }
}

//
//  Checkout+NBE.swift
//  OSCAR
//
//  Created by Mostafa Samir on 15/09/2021.
//

//import UIKit
//import MPGSDK
//
//
//// MARK: - 1. Create Session
//extension CheckoutViewController {
//    /// This function creates a new session using the merchant service
//    func createSession() {
//        // update the UI
//        self.showLoadingView()
//        
//        merchantAPI.createSession { (result) in
//            DispatchQueue.main.async {
//                // stop the activity indictor
//                guard case .success(let response) = result,
//                      "SUCCESS" == response[at: "gatewayResponse.result"] as? String,
//                      let session = response[at: "gatewayResponse.session.id"] as? String,
//                      let apiVersion = response[at: "apiVersion"] as? String else {
//                    // if anything was missing, flag the step as having errored
//                    self.dismissLoadingView()
//                    self.showAlert(message: "Error Creating Session")
//                    return
//                }
//                // The session was created successfully
//                self.viewModel.transaction.session = GatewaySession(id: session, apiVersion: apiVersion)
//                self.collectCardInfo()
//            }
//        }
//    }
//}
//
//
//// MARK: - 2. Collect Card Info
//extension CheckoutViewController {
//    // Presents the card collection UI and waits for a response
//    func collectCardInfo() {
//        // update the UI
//        //collectCardActivityIndicator.startAnimating()
//        let cardVC = CollectCardInfoViewController()
//        cardVC.viewModel.transaction = viewModel.transaction
//        cardVC.completion = cardInfoCollected
//        cardVC.cancelled = cardInfoCancelled
//        push(cardVC)
//    }
//    
//    func cardInfoCollected(transaction: Transaction) {
//        // populate the card information
//        self.viewModel.transaction = transaction
//        // start the action to update the session with payer data
//        self.updateWithPayerData()
//    }
//    
//    func cardInfoCancelled() {
////        collectCardActivityIndicator.stopAnimating()
////        self.stepErrored(message: "Card Information Not Entered", stepStatusImageView: self.collectCardStatusImageView)
//        self.dismissLoadingView()
//    }
//}
//
//// MARK: - 3. Update Session With Payer Data
//extension CheckoutViewController {
//    // Updates the gateway session with payer data using the gateway.updateSession function
//    func updateWithPayerData() {
//        // update the UI
//    
//        guard let sessionId = viewModel.transaction.session?.id,
//              let apiVersion = viewModel.transaction.session?.apiVersion
//        else { return }
//        
//        // construct the Gateway Map with the desired parameters.
//        var request = GatewayMap()
//        request[at: "sourceOfFunds.provided.card.nameOnCard"] = viewModel.transaction.nameOnCard
//        request[at: "sourceOfFunds.provided.card.number"] = viewModel.transaction.cardNumber
//        request[at: "sourceOfFunds.provided.card.securityCode"] = viewModel.transaction.cvv
//        request[at: "sourceOfFunds.provided.card.expiry.month"] = viewModel.transaction.expiryMM
//        request[at: "sourceOfFunds.provided.card.expiry.year"] = viewModel.transaction.expiryYY
//        
//        // if the transaction has an Apple Pay Token, populate that into the map
//        if let tokenData = viewModel.transaction.applePayPayment?.token.paymentData, let token = String(data: tokenData, encoding: .utf8) {
//            request[at: "sourceOfFunds.provided.card.devicePayment.paymentToken"] = token
//        }
//        
//        // execute the update
//        gateway.updateSession(sessionId, apiVersion: apiVersion, payload: request, completion: updateSessionHandler(_:))
//    }
//    
//    // Call the gateway to update the session.
//    fileprivate func updateSessionHandler(_ result: GatewayResult<GatewayMap>) {
//        DispatchQueue.main.async {
//            
//            guard case .success(_) = result else {
//                self.dismissLoadingView()
//                self.showAlert(message: "Error Updating Session")
//                return
//            }
//            
//            // check for 3DS enrollment
//            self.check3dsEnrollment()
//        }
//    }
//}
//
//// MARK: - 4. Check 3DS Enrollment
//extension CheckoutViewController {
//    // uses the gateway (throught the merchant service) to check the card to see if it is enrolled in 3D Secure
//    func check3dsEnrollment() {
//        // if the transaction is an Apple Pay Transaction, 3DSecure is not supported.  Therfore, the app should skip this step and no longer provide a 3DSecureId
//        guard !viewModel.transaction.isApplePay else {
//            viewModel.transaction.threeDSecureId = nil
//            prepareForProcessPayment()
//            return
//        }
//        
//        // A redirect URL for 3D Secure that will redirect the browser back to a page on our merchant service after 3D Secure authentication
//        let redirectURL = merchantAPI.merchantServerURL.absoluteString.appending("/3DSecureResult.php?3DSecureId=\(viewModel.transaction.threeDSecureId!)")
//        // check enrollment
//        merchantAPI.check3DSEnrollment(transaction: viewModel.transaction, redirectURL: redirectURL , completion: check3DSEnrollmentHandler)
//    }
//    
//    func check3DSEnrollmentHandler(_ result: MPGSDKResult<GatewayMap>) {
//        DispatchQueue.main.async {
//            if Int(self.viewModel.transaction.session!.apiVersion)! <= 46 {
//                self.check3DSEnrollmentV46Handler(result)
//            } else {
//                self.check3DSEnrollmentV47Handler(result)
//            }
//        }
//    }
//    
//    func check3DSEnrollmentV46Handler(_ result: MPGSDKResult<GatewayMap>) {
//        guard case .success(let response) = result, let code = response[at: "gatewayResponse.3DSecure.summaryStatus"] as? String else {
//            self.dismissLoadingView()
//            self.showAlert(message: "Error checking 3DS Enrollment")
//            return
//        }
//        
//        // check to see if the card was enrolled, not enrolled or does not support 3D Secure
//        switch code {
//        case "CARD_ENROLLED":
//            // For enrolled cards, get the htmlBodyContent and present the Gateway3DSecureViewController
//            if let html = response[at: "gatewayResponse.3DSecure.authenticationRedirect.simple.htmlBodyContent"] as? String {
//                self.begin3DSAuth(simple: html)
//            }
//        case "CARD_DOES_NOT_SUPPORT_3DS":
//            // for cards that do not support 3DSecure, go straight to payment confirmation without a 3DSecureID
//            self.viewModel.transaction.threeDSecureId = nil
//            self.prepareForProcessPayment()
//        case "CARD_NOT_ENROLLED", "AUTHENTICATION_NOT_AVAILABLE":
//            // for cards that are not enrolled or if authentication is not available, go to payment confirmation but include the 3DSecureID
//            self.prepareForProcessPayment()
//        default:
//            self.dismissLoadingView()
//            self.showAlert(message: "Error checking 3DS Enrollment")
//        }
//    }
//    
//    func check3DSEnrollmentV47Handler(_ result: MPGSDKResult<GatewayMap>) {
//        guard case .success(let response) = result,
//              let recommendation = response[at: "gatewayResponse.response.gatewayRecommendation"] as? String else {
//            self.dismissLoadingView()
//            self.showAlert(message: "Error checking 3DS Enrollment")
//            return
//        }
//        
//        // if DO_NOT_PROCEED returned in recommendation, should stop transaction
//        if recommendation == "DO_NOT_PROCEED" {
//            self.dismissLoadingView()
//            self.showAlert(message: "Error checking 3DS Enrollment")
//        }
//        
//        // if PROCEED in recommendation, and we have HTML for 3DS, perform 3DS
//        if let html = response[at: "gatewayResponse.3DSecure.authenticationRedirect.simple.htmlBodyContent"] as? String {
//            self.begin3DSAuth(simple: html)
//        } else {
//            // if PROCEED in recommendation, but no HTML, finish the transaction without 3DS
//            self.prepareForProcessPayment()
//        }
//    }
//    
//    fileprivate func begin3DSAuth(simple: String) {
//        // instatniate the Gateway 3DSecureViewController and present it
//        let threeDSecureView = Gateway3DSecureViewController(nibName: nil, bundle: nil)
//        present(threeDSecureView, animated: true)
//        
//        // Optionally customize the presentation
//        threeDSecureView.title = "3-D Secure Auth"
//        //threeDSecureView.navBar.tintColor = brandColor
//        
//        // Start 3D Secure authentication by providing the view with the HTML content provided by the check enrollment step
//        threeDSecureView.authenticatePayer(htmlBodyContent: simple, handler: handle3DS(authView:result:))
//    }
//    
//    func handle3DS(authView: Gateway3DSecureViewController, result: Gateway3DSecureResult) {
//        // dismiss the 3DSecureViewController
//        authView.dismiss(animated: true, completion: {
//            switch result {
//            case .error(_):
//                self.dismissLoadingView()
//                self.showAlert(message: "3DS Authentication Failed")
//            case .completed(gatewayResult: let response):
//                // check for version 46 and earlier api authentication failures and then version 47+ failures
//                if Int(self.viewModel.transaction.session!.apiVersion)! <= 46, let status = response[at: "3DSecure.summaryStatus"] as? String , status == "AUTHENTICATION_FAILED" {
//                    self.dismissLoadingView()
//                    self.showAlert(message: "3DS Authentication Failed")
//                } else if let status = response[at: "response.gatewayRecommendation"] as? String, status == "DO_NOT_PROCEED"  {
//                    self.dismissLoadingView()
//                    self.showAlert(message: "3DS Authentication Failed")
//                } else {
//                    // if authentication succeeded, continue to proceess the payment
//                    self.prepareForProcessPayment()
//                }
//            default:
//                self.dismissLoadingView()
//                self.showAlert(message: "3DS Authentication Cancelled")
//            }
//        })
//    }
//    
//    func prepareForProcessPayment() {
//        processPayment()
//    }
//}
//
//// MARK: - 5. Process Payment
//extension CheckoutViewController {
//    /// Processes the payment by completing the session with the gateway.
//    func processPayment() {
//        // update the UI
//        
//        merchantAPI.completeSession(transaction: viewModel.transaction) { (result) in
//            DispatchQueue.main.async {
//                self.processPaymentHandler(result: result)
//            }
//        }
//    }
//    
//    func processPaymentHandler(result: MPGSDKResult<GatewayMap>) {
//        showLoadingView()
//        guard case .success(let response) = result, "SUCCESS" == response[at: "gatewayResponse.result"] as? String else {
//            self.dismissLoadingView()
//            showAlert(message: "Unable to complete Pay Operation")
//            return
//        }
//        viewModel.checkout()
//    }
//}

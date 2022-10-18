//
//  HomeVC+ BarcodeDelegates.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 05/07/2021.
//

import BarcodeScanner

extension HomeVC: BarcodeScannerCodeDelegate {
  func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
    print(code)
    controller.dismiss()
    viewModel.getProduct(for: code)
  }
}

extension HomeVC: BarcodeScannerErrorDelegate {
  func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
    print(error)
  }
}

extension HomeVC: BarcodeScannerDismissalDelegate {
  func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}

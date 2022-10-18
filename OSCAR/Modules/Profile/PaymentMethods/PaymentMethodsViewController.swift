//
//  PaymentMethodsViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 08/08/2021.
//

import UIKit

class PaymentMethodsViewController: BaseViewController {
    @IBOutlet weak var paymentTypesCollectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    var paymentTypes: [Constants.PaymentMethodTypes] = [.cardUponDelivery, .cashOnDelivery]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
    
    func setupCollectionView() {
        paymentTypesCollectionView.dataSource = self
        paymentTypesCollectionView.delegate = self
        paymentTypesCollectionView.registerCellNib(cellClass: PaymentMethodCollectionViewCell.self)
    }
}

extension PaymentMethodsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CurrentUser.shared.defaultPaymentType = paymentTypes[indexPath.row].rawValue
        collectionView.reloadData()
    }
}

extension PaymentMethodsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paymentTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as PaymentMethodCollectionViewCell
        cell.configureCell(with: paymentTypes[indexPath.row])
        return cell
    }
    
}

//
//  OrderDetailsViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 04/08/2021.
//

import UIKit

class OrderDetailsViewController: BaseViewController {
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderAddressLabel: UILabel!
    @IBOutlet weak var orderItemsTableView: SelfSizedTableView! {
        didSet {
            setupTableView()
        }
    }
    @IBOutlet weak var orderSubtotalLabel: UILabel!
    @IBOutlet weak var orderDeliveryFeesLabel: UILabel!
    @IBOutlet weak var orderTotalLabel: UILabel!
    @IBOutlet weak var bottomButton: BackGroundButton!
    
    var viewModel = MyOrdersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setData()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
    
    @IBAction func bottomButtonTapped(_ sender: Any) {
        switch viewModel.selectedOrderStatus {
        case .pending:// cancel
            showCancelAlert()
        case .assigned:// cancel
            showCancelAlert()
        case .onTheWay:// track
            let vc = TrackOrderViewController()
            vc.viewModel.order = self.viewModel.selectedOrder
            push(vc)
        case .preparing:// cancel
            showCancelAlert()
        case .completed:// reorder
            viewModel.reorderSelectedOrder()
        case .checkingStatus:// cancel
            showCancelAlert()
        }
    }
    
}

fileprivate extension OrderDetailsViewController {
    
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        viewModel.showSuccessMessage = {[weak self] message in
            self?.showToast(message: message)
        }
    }
    
    func setData() {
        guard let order = viewModel.selectedOrder else { return }
        
        orderIdLabel.text = "#" + (order.id?.description ?? "0")
        orderDateLabel.text = order.createdAt
        orderAddressLabel.text = order.customerAddress
        setOrderStatus()
        orderItemsTableView.reloadData()
        orderDeliveryFeesLabel.text = "EGP".localized + " " + (order.deliveryFees ?? "20")
        orderSubtotalLabel.text = "EGP".localized + " " + (viewModel.subtotal().description)
        orderTotalLabel.text = "EGP".localized + " " + (viewModel.total().description)
    }
    
    func setOrderStatus() {
        switch viewModel.selectedOrderStatus {
        case .assigned:
            orderStatusLabel.textColor = UIColor.buttonBackground
            orderStatusLabel.text = "assigned".localized
            bottomButton.setTitle("cancel".localized, for: .normal)
        case .preparing:
            orderStatusLabel.textColor = UIColor(hexString: "#FFC72E")
            orderStatusLabel.text = "preparing".localized
            bottomButton.setTitle("cancel".localized, for: .normal)
        case .onTheWay:
            orderStatusLabel.textColor = UIColor(hexString: "#01C6C6")
            orderStatusLabel.text = "on_the_way".localized
            bottomButton.setTitle("track".localized, for: .normal)
        case .completed:
            orderStatusLabel.textColor = UIColor(hexString: "#23B700")
            orderStatusLabel.text = "completed".localized
            bottomButton.setTitle("reorder".localized, for: .normal)
        case .pending:
            orderStatusLabel.textColor = UIColor.buttonBackground
            orderStatusLabel.text = "pending".localized
            bottomButton.setTitle("cancel".localized, for: .normal)
        case .checkingStatus:
            orderStatusLabel.textColor = UIColor.buttonBackground
            orderStatusLabel.text = "pending".localized
            bottomButton.setTitle("cancel".localized, for: .normal)
        }
    }
    
    func setupTableView() {
        orderItemsTableView.delegate = self
        orderItemsTableView.dataSource = self
        orderItemsTableView.registerCellNib(cellClass: OrderItemTableViewCell.self)
    }
    
    func showCancelAlert() {
        let cancelVC = CancelPopUpViewController()
        cancelVC.modalPresentationStyle = .overCurrentContext
        present(cancelVC, animated: true)
    }
}


extension OrderDetailsViewController: UITableViewDelegate {
    
}

extension OrderDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.selectedOrder?.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as OrderItemTableViewCell
        if let product = viewModel.selectedOrder?.products?[indexPath.row] {
            cell.configureCell(with: product)
        }
        return cell
    }
    
    
}


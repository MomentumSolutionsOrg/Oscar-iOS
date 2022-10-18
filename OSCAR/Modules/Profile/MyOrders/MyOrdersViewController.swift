//
//  MyOrdersViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 04/08/2021.
//

import UIKit

class MyOrdersViewController: BaseViewController {
    @IBOutlet weak var ordersTableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    
    private let viewModel = MyOrdersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViewModel()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
}

fileprivate extension MyOrdersViewController {
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        
        viewModel.fetchOrdersCompletion = { [weak self] in
            self?.ordersTableView.reloadData()
        }
        
        viewModel.fetchOrders()
    }
    func setupTableView() {
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.registerCellNib(cellClass: MyOrderTableViewCell.self)
    }
}


extension MyOrdersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as MyOrderTableViewCell
        cell.configureCell(with: viewModel.orders[indexPath.row])
        return cell
    }
}

extension MyOrdersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MyOrderTableViewCell {
            viewModel.selectedOrderStatus = cell.orderStatus
            
            if cell.orderStatus == .checkingStatus {
                showToast(message: "please_wait_check_status".localized)
            } else {
                viewModel.selectedOrder = viewModel.orders[indexPath.row]
                let vc = OrderDetailsViewController()
                vc.viewModel = viewModel
                push(vc)
            }
        }
    }
}

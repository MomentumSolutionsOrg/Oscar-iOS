//
//  VouchersViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 05/08/2021.
//

import UIKit

class VouchersViewController: BaseViewController {
    @IBOutlet weak var vouchersTableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    
    private let viewModel = VouchersViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
}

fileprivate extension VouchersViewController {
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        
        viewModel.successCompletion = { [weak self] in
            self?.vouchersTableView.reloadData()
        }
        
        viewModel.fetchVouchers()
    }
    
    func setupTableView() {
        vouchersTableView.dataSource = self
        vouchersTableView.delegate = self
        vouchersTableView.registerCellNib(cellClass: VoucherTableViewCell.self)
    }
}

extension VouchersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIPasteboard.general.string = viewModel.vouchers[indexPath.row].name
        showToast(message: "\(UIPasteboard.general.string ?? "nothing" ) " + "copied_to_clipboard".localized)
    }
}

extension VouchersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.vouchers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as VoucherTableViewCell
        cell.configureCell(with: viewModel.vouchers[indexPath.row])
        return cell
    }
}

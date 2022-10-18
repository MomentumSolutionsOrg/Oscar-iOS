//
//  MyAddressesViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//

import UIKit

class MyAddressesViewController: BaseViewController {
    @IBOutlet weak var myAddressesTableView: SelfSizedTableView! {
        didSet {
            setupTableView()
        }
    }
    @IBOutlet weak var addAddressButton: RoundedButton!
    @IBOutlet weak var addOnMapButton: RoundedButton!
    
    let viewModel = AddressesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewModel()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
    
    @IBAction func addAddressTapped(_ sender: Any) {
        let vc = AddressInformationViewController()
        vc.viewModel = viewModel
        push(vc)
    }
    
    @IBAction func addOnMapTapped(_ sender: Any) {
        let vc = ChooseOnMapViewController()
        vc.viewModel = viewModel
        push(vc)
    }
}

fileprivate extension MyAddressesViewController {
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        viewModel.addressType = .new
        viewModel.successCompletion = { [weak self] in
            self?.myAddressesTableView.reloadData()
        }
        
        viewModel.sendAddressCompletion = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToViewController(self, animated: true)
        }
        
        viewModel.selectedAddress = nil
        viewModel.fetchAddresses()
    }
    
    func setupTableView() {
        myAddressesTableView.dataSource = self
        myAddressesTableView.delegate = self
        myAddressesTableView.registerCellNib(cellClass: MyAddressTableViewCell.self)
    }
}

extension MyAddressesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(at: indexPath)
        let vc = AddressInformationViewController()
        vc.viewModel = viewModel
        push(vc)
    }
}

extension MyAddressesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.addresses.count
        if count == 0 {
            myAddressesTableView.setEmptyView(title: "", message: "no_saved_addresses".localized)
        }else {
            myAddressesTableView.restore()
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as MyAddressTableViewCell
        cell.configureCell(with: viewModel.address(at: indexPath), indexPath: indexPath)
        return cell
    }
}

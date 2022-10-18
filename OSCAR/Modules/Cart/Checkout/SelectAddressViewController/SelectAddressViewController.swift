//
//  SelectAddressViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 11/08/2021.
//

import UIKit

protocol SelectAddressDelegate: AnyObject {
    func didSelect(address: Address)
    func addAddressTapped()
    func addOnMapTapped()
}

class SelectAddressViewController: BaseViewController {
    @IBOutlet weak var addressesTableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    
    var addresses = [Address]()
    var selectedAddress: Address?
    weak var delegate: SelectAddressDelegate?
    
    
    func setupTableView() {
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
        addressesTableView.registerCellNib(cellClass: MyAddressTableViewCell.self)
    }
    @IBAction func tapGestureRecognized(_ sender: Any) {
        dismiss()
    }
    @IBAction func addAddressTapped(_ sender: Any) {
        delegate?.addAddressTapped()
    }
    @IBAction func addOnMapTapped(_ sender: Any) {
        delegate?.addOnMapTapped()
    }
}

extension SelectAddressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as MyAddressTableViewCell
        let selection = addresses[indexPath.row].id == selectedAddress?.id
        cell.configureCell(with: addresses[indexPath.row], selection: selection)
        return cell
    }
}

extension SelectAddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(address: addresses[indexPath.row])
    }
}


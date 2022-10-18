//
//  MyAddressTableViewCell.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//

import UIKit

class MyAddressTableViewCell: UITableViewCell {
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var addressPhoneLabel: UILabel!
    @IBOutlet weak var addressCityLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var containingView: BorderView!
    
    private var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(with address: Address, selection: Bool) {
        addressNameLabel.text = address.name
        addressPhoneLabel.text = address.phone
        addressCityLabel.text = address.city
        deleteButton.isHidden = true
        deleteButton.isEnabled = false
        containingView.showBorder = selection
        selectionImageView.image = selection ? #imageLiteral(resourceName: "checkImage") : #imageLiteral(resourceName: "emptyCheck")
        
    }
    
    func configureCell(with address: Address, indexPath: IndexPath) {
        self.index = indexPath.row
        addressNameLabel.text = address.name
        addressPhoneLabel.text = address.phone
        addressCityLabel.text = address.city
        checkDefault(for: address.isDefault ?? 0)
    }
    
    private func checkDefault(for id: Int) {
        let isDefault =  id == 1
        containingView.showBorder = isDefault
        selectionImageView.image = isDefault ? #imageLiteral(resourceName: "checkImage") : #imageLiteral(resourceName: "emptyCheck")
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let vc = viewContainingController() as? MyAddressesViewController {
            vc.viewModel.deleteAddress(at: index)
        }
    }
    
}

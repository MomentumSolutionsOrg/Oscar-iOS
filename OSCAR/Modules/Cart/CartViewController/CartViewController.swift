//
//  CartViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 09/08/2021.
//

import UIKit

class CartViewController: BaseViewController {
    @IBOutlet weak var cartCountLabel: UILabel!
    @IBOutlet weak var nextButton: BackGroundButton!
    @IBOutlet weak var cartItemsTableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    
    private let viewModel = CheckoutProcessViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideCartView()
        if CurrentUser.shared.cartCount == 0 {
            showShopNowView(with: "no_items_in_cart".localized)
        }else {
            removeShopNow()
        }
        setupViewModel()
        viewModel.fetchCart()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if !Date().isClosingTime() {
            showPopUpForClosingTime()
        } else {
            let checkout = CheckoutViewController()
            checkout.viewModel = viewModel
            push(checkout)
        }
      
    }
    
    func showPopUpForClosingTime() {
        let alert = UIAlertController(title: "", message: "closing_time".localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized, style: .cancel) 
        alert.addAction(okAction)
        present(alert)
    }
}

fileprivate extension CartViewController {
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        
        viewModel.getCartSuccessCompletion = { [weak self] in
            self?.cartCountLabel.text = "you_have".localized + "\(CurrentUser.shared.cartCount)" + "products_in_cart".localized
            if self?.viewModel.cartProducts.count == 0 {
                self?.hideCartView()
                self?.showShopNowView(with: "no_items_in_cart".localized)
            }else {
                self?.removeShopNow()
                self?.showCartView()
            }
            self?.cartItemsTableView.reloadData()
        }
        
        viewModel.createOrderCompletion = { [weak self] in
            let vc = CheckoutSuccessViewController()
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self?.present(vc)
        }
        
        viewModel.showThirtyItemPopUp = { [weak self] in
            self?.showAlert(message: "thirty_item_message".localized)
        }
        
    }
    
    func setupTableView() {
        cartItemsTableView.delegate = self
        cartItemsTableView.dataSource = self
        cartItemsTableView.registerCellNib(cellClass: CartItemTableViewCell.self)
    }
    
    func showCartView() {
        cartCountLabel.isHidden = false
        nextButton.isHidden = false
        cartItemsTableView.isHidden = false
    }
    
    func hideCartView() {
        cartCountLabel.isHidden = true
        nextButton.isHidden = true
        cartItemsTableView.isHidden = true
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action =  UIContextualAction(style: .normal, title: "", handler: { [weak self] (action, view, completionHandler ) in
            //do stuff
            self?.viewModel.updateItem(at: indexPath.row, with: 0)
            completionHandler(true)
        })
        action.image = #imageLiteral(resourceName: "delete-white")
        action.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
        }

}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as CartItemTableViewCell
        cell.configure(with: viewModel.cartProducts[indexPath.row], indexPath: indexPath)
        cell.delegate = viewModel
        return cell
    }
}


extension CartViewController: CheckoutSuccessDelegate {
    func myOrdersSelected() {
        dismiss()
        popToRoot()
        push(MyOrdersViewController())
    }
    
    func continueShoppingSelected() {
        dismiss()
        popToRoot()
        tabBarController?.selectedIndex = 0
    }
    
}

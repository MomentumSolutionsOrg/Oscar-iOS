//
//  OffersViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//

import UIKit

class OffersViewController: BaseViewController {
    
    @IBOutlet weak var offersTableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    
    let viewModel = OffersViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchOffers()
    }
    
    func seeAllProducts(for offer: String) {
        let offerCategoryViewController = OfferCategoryProductsViewController()
        offerCategoryViewController.offerName = offer
        push(offerCategoryViewController)
    }
    
    func getProduct(at index: Int ,for indexPathRow: Int ) {
        let id = viewModel.offers[indexPathRow].products?[index].id ?? "1"
        viewModel.getProduct(for: id)
    }
    
    func addToWishlist(id: String) {
        viewModel.addToWishList(id: id)
    }
    
    func addToCart(id: String) {
        viewModel.addToCart(for: id)
    }
    
    func removeFromWishList(id: String) {
        viewModel.removeFromWishList(id: id)
    }
}

fileprivate extension OffersViewController {
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        
        viewModel.successCompletion = { [weak self] in
            self?.offersTableView.reloadData()
        }
        
        viewModel.productCompletion = { [weak self] productVC in
            if let productVC = productVC {
                self?.push(productVC)
            }else {
                self?.showToast(message: "product_not_available".localized)
            }
        }
        
        viewModel.addToCartCompletion = { [weak self] message in
            self?.showAlert(message: message)
        }
    }
    
    func setupTableView() {
        offersTableView.delegate = self
        offersTableView.dataSource = self
        offersTableView.registerCellNib(cellClass: OffersTableViewCell.self)
    }
}


extension OffersViewController: UITableViewDelegate {
    
}

extension OffersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as OffersTableViewCell
        if !viewModel.offers.isEmpty {
            cell.configureCell(with: viewModel.offers[indexPath.row], indexPath: indexPath)
        }
        return cell
    }
    
}


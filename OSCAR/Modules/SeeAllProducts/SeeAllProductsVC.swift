//
//  SeeAllProductsVC.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 11/07/2021.
//

import UIKit

class SeeAllProductsVC: BaseViewController, ProductCellDelegate {

    @IBOutlet weak var productsCollectionView: UICollectionView!
    let viewModel = SeeAllProductsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewmodel()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProducts()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
}

fileprivate extension SeeAllProductsVC {
    func setupViewmodel() {
        setupViewModel(viewModel: viewModel)
        viewModel.completion = { [weak self] in
            self?.productsCollectionView.reloadData()
        }
        
        viewModel.productCompletion = { [weak self] productVC in
            if let productVC = productVC {
                self?.push(productVC)
            }else {
                self?.showToast(message: "product_not_available".localized)
            }
        }
        
        if viewModel.products.count == 0 {
            // get products from category
            viewModel.getProducts()
        }
    }
    
    func setupCollectionView() {
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.registerCellNib(cellClass: GridCollectionViewCell.self)
        productsCollectionView.registerCellNib(cellClass: ListCollectionViewCell.self)
        
    }
}

extension SeeAllProductsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.getProduct(for: viewModel.products[indexPath.row].id ?? "1")
    }
}

extension SeeAllProductsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as GridCollectionViewCell
        cell.configureCell(with: viewModel.products[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension SeeAllProductsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width/2, height: 260)
    }
}

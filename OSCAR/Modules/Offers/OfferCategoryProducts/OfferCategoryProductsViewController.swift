//
//  OfferCategoryProductsViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 10/08/2021.
//

import UIKit

class OfferCategoryProductsViewController: BaseViewController, ProductCellDelegate {
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    private lazy var viewModel = OfferCategoryViewModel(offer: offerName)
    var offerName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewmodel()
        setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchOfferProducts()
    }
    
    func fetchProducts() {
        viewModel.fetchOfferProducts()
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
}

fileprivate extension OfferCategoryProductsViewController {
    func setupViewmodel() {
        setupViewModel(viewModel: viewModel)
        viewModel.successCompletion = { [weak self] in
            self?.productsCollectionView.reloadData()
        }
        
        viewModel.productCompletion = { [weak self] productVC in
            if let productVC = productVC {
                self?.push(productVC)
            }else {
                self?.showToast(message: "product_not_available".localized)
            }
        }
        
//        fetchProducts()
    }
    
    func setupCollectionView() {
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.registerCellNib(cellClass: GridCollectionViewCell.self)
        productsCollectionView.registerCellNib(cellClass: LoadMoreCollectionViewCell.self)
    }
}

extension OfferCategoryProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.getProduct(for: viewModel.offerProducts[indexPath.row].id ?? "1")
    }
}

extension OfferCategoryProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.offerProducts.count
        return  viewModel.shouldPaginate ?  count + 1 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == viewModel.offerProducts.count {
            let cell = collectionView.dequeue(indexPath: indexPath) as LoadMoreCollectionViewCell
            return cell
        }else {
            let cell = collectionView.dequeue(indexPath: indexPath) as GridCollectionViewCell
            cell.delegate = self
            cell.configureCell(with: viewModel.offerProducts[indexPath.row])
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell is LoadMoreCollectionViewCell {
            fetchProducts()
        }
    }
}

extension OfferCategoryProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        if indexPath.row == viewModel.offerProducts.count {
            return CGSize(width: width , height: 50)
        }else {
            return CGSize(width: width/2, height: 260)
        }
        
        
    }
}

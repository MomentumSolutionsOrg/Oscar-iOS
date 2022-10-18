//
//  WishListViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 09/08/2021.
//

import UIKit

class WishListViewController: BaseViewController {
    @IBOutlet weak var wishListsCollectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    @IBOutlet weak var addSelectedButton: BackGroundButton!
    @IBOutlet weak var clearSelectedButton: BackGroundButton!
    @IBOutlet weak var selectAllButton: UIButton!
    private let viewModel = WishListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideWishlistView()
        viewModel.fetchWishList()
    }
    @IBAction func selectAllButtonTapped(_ sender: Any) {
        viewModel.selectedProducts = viewModel.products
        wishListsCollectionView.reloadData()
    }
    
    @IBAction func addSelectedButtonTapped(_ sender: Any) {
        if viewModel.selectedProducts.count > 0 {
            viewModel.addSelectedItemsToCart()
        }else {
            self.showToast(message: "nothing_to_add".localized)
        }
        
    }
    
    @IBAction func clearSelectedButtonTapped(_ sender: Any) {
        viewModel.selectedProducts.removeAll()
        wishListsCollectionView.reloadData()
    }
    
}


fileprivate extension WishListViewController {
    
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        
        viewModel.successCompletion = { [weak self] in
            self?.showWishlistView()
        }
        
        viewModel.addToCartCompletion = { [weak self] message in
            self?.showAlert(message: message)
        }
        
        viewModel.showSuccessMessage = {[weak self] message in
            self?.showAlert(message: message)
        }
    }
    
    func setupCollectionView() {
        wishListsCollectionView.delegate = self
        wishListsCollectionView.dataSource = self
        wishListsCollectionView.registerCellNib(cellClass: WishListCollectionViewCell.self)
    }
    
    func showWishlistView() {
        [addSelectedButton,clearSelectedButton,selectAllButton].forEach { button in
            button?.isHidden = false
        }
        wishListsCollectionView.isHidden = false
        wishListsCollectionView.reloadData()
    }
    
    func hideWishlistView() {
        [addSelectedButton,clearSelectedButton,selectAllButton].forEach { button in
            button?.isHidden = true
        }
        wishListsCollectionView.isHidden = true
    }
}


extension WishListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.products.count
        if count == 0 {
            showShopNowView(with: "no_items_in_favorite".localized)
        }else {
            removeShopNow()
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as WishListCollectionViewCell
        cell.configureCell(with: viewModel.products[indexPath.row], selected: viewModel.checkSelection(at: indexPath))
        cell.delegate = viewModel
        return cell
    }
    
    
}

extension WishListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.toggleSelection(at: indexPath)
        collectionView.reloadData()
    }
}


extension WishListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width/2, height: 250)
    }
}

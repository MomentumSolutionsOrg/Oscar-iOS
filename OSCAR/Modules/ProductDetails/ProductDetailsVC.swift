//
//  ProductDetailsVC.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 05/07/2021.
//

import UIKit

class ProductDetailsVC: BaseViewController {
    
    init(product: Product) {
        self.viewModel.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productImagesCollectionView: UICollectionView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToCartButton: BackGroundButton!
    @IBOutlet weak var sizesButton: BackGroundButton!
    @IBOutlet weak var relatedProductsCollectionView: UICollectionView!
    
    let viewModel = ProductDetailsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
        setupViewmodel()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //viewModel.getProductDetails()
        setupViewModelRefresh()
        //setupViewmodel()
        //setupView()
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        Utils.shareProduct(with: viewModel.product?.productID ?? "")
    }
    @IBAction func sizesButtonTapped(_ sender: Any) {
        let vc = SelectSizeViewController()
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc)
    }
    @IBAction func addToCartTapped(_ sender: Any) {
        if CurrentUser.shared.token != nil {
            viewModel.addToCart()
        }else {
            showToast(message: "login_first".localized)
        }
        
    }
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        if CurrentUser.shared.token != nil {
            viewModel.isWishListed.toggle()
            if viewModel.isWishListed {
                favouriteButton.setImage(#imageLiteral(resourceName: "icon-favorite_24px"), for: .normal)
            }else {
                favouriteButton.setImage(#imageLiteral(resourceName: "icon-action-favorite_24px"), for: .normal)
            }
            viewModel.updateWishList()
        }else {
            showToast(message: "login_first".localized)
        }
        
    }
    @IBAction func quantityChangeTapped(_ sender: UIButton) {
        switch sender {
        case plusButton:
            viewModel.quantity += 1
        case minusButton:
            if viewModel.quantity > 1 {
                viewModel.quantity -= 1
            }
        default:
            break
        }
        quantityLabel.text = viewModel.quantity.description
    }
    
}

fileprivate extension ProductDetailsVC {
    func setupCollectionView() {
        productImagesCollectionView.dataSource = self
        productImagesCollectionView.delegate = self
        productImagesCollectionView.registerCellNib(cellClass: ProductImageCollectionViewCell.self)
        
        relatedProductsCollectionView.dataSource = self
        relatedProductsCollectionView.delegate = self
        relatedProductsCollectionView.registerCellNib(cellClass: CategoryProductCollectionViewCell.self)
    }
    
    func setupView() {
        guard let product = viewModel.product else { return }
        productNameLabel.text = product.name
        scrollView.scrollTo(direction: .top, animated: true)
        if product.inStock == 1 {
            addToCartButton.isEnabled = true
            addToCartButton.setTitle("add_to_cart".localized.uppercased(), for: .normal)
            if !viewModel.hasSizes {
                sizesButton.isHidden = true
                sizesButton.isEnabled = false
            }else {
                sizesButton.isHidden = false
                sizesButton.isEnabled = true
            }
        }else {
            sizesButton.isHidden = true
            sizesButton.isEnabled = false
            addToCartButton.isEnabled = false
            addToCartButton.setTitle("out_of_stock".localized.uppercased(), for: .normal)
        }
        descriptionLabel.text = product.description
        quantityLabel.text = viewModel.quantity.description
        if viewModel.isWishListed {
            favouriteButton.setImage(#imageLiteral(resourceName: "icon-favorite_24px"), for: .normal)
        }else {
            favouriteButton.setImage(#imageLiteral(resourceName: "passion"), for: .normal)
        }
        let price = product.standard.price ?? 0.0
        let discountPrice = product.standard.discountPrice ?? 0
        
        if viewModel.product?.standard.onSale == 1 {
            priceLabel.isHidden = false
            priceLabel.attributedText =
            ("EGP".localized + " " + price.currency)
                .strikeThrough()
            currentPriceLabel.text = "EGP".localized + " " + discountPrice.currency
        }else {
            priceLabel.isHidden = true
            currentPriceLabel.text = "EGP".localized + " " + price.currency
        }
        pageController.numberOfPages = viewModel.product?.images().count ?? 0
        productImagesCollectionView.reloadData()
        relatedProductsCollectionView.reloadData()
    }
    
    func setupViewmodel() {
        setupViewModel(viewModel: viewModel)
        
        viewModel.addToCartCompletion = { [weak self] message in
            self?.showAlert(message: message)
        }
        
        viewModel.showRelatedProductCompletion = setupView
    }
    
    func setupViewModelRefresh() {
//        setupViewModel(viewModel: viewModel)
        
//        viewModel.addToCartCompletion = { [weak self] message in
//            self?.showAlert(message: message)
//        }
        viewModel.showProductCompletion = { [weak self]  in
            self?.setupView()
        }
        viewModel.getProductDetails()
    }
}


extension ProductDetailsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case productImagesCollectionView:
            return viewModel.product?.images().count ?? 0
        case relatedProductsCollectionView:
            return viewModel.relatedProducts.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case productImagesCollectionView:
            let cell = collectionView.dequeue(indexPath: indexPath) as ProductImageCollectionViewCell
            let images = viewModel.product?.images() ?? []
            cell.configureCell(with: images[indexPath.item])
            return cell
        case relatedProductsCollectionView:
            let cell = collectionView.dequeue(indexPath: indexPath) as CategoryProductCollectionViewCell
            cell.configure(with: viewModel.relatedProducts[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == productImagesCollectionView {
            pageController.currentPage = indexPath.row + 1
        }
        
    }
    
}

extension ProductDetailsVC: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productImagesCollectionView {
            return collectionView.frame.size
        }else {
            return CGSize(width: 124, height: 210)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == relatedProductsCollectionView {
            viewModel.fetchProduct(for: viewModel.relatedProducts[indexPath.row].productID ?? "0")
        }
    }
}

extension ProductDetailsVC: SizeSelectionDelegate {
    func didSelect(size: String, unit: String, weight: Int) {
        dismiss()
        sizesButton.setTitle(size + " " + unit, for: .normal)
        viewModel.size = weight.description
    }
}


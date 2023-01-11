//
//  SubCategoryBaseTableViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 11/07/2021.
//

import UIKit

class SubCategoryBaseTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var firstCollectionView: UICollectionView!
    @IBOutlet weak var categoryImageView: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondContainingView: UIView!
    @IBOutlet weak var secondCollectionView: UICollectionView!
    @IBOutlet weak var secondCollectionHeight: NSLayoutConstraint!
    private var category:ChildCategory? {
        didSet {
            hasChildren = (category?.categories?.count ?? 0) > 0
        }
    }
    private var selectedSubCategory:ChildCategory? {
        didSet {
            if let subCategory = selectedSubCategory {
                if subCategory.categories?.count ?? 0 > 0 {
                    secondCollectionView.isHidden = false
                    secondContainingView.isHidden = false
                    viewSecondAsProducts = false
                    secondCollectionView.reloadData()
                    if let vc = viewContainingController() as? SubCategoryVC {
                        vc.categoriesTableView.reloadData()
                    }
                    }else {
                        // view products
//                        if let vc = viewContainingController() as? SubCategoryVC,
//                           let id = selectedSubCategory?.id {
//                            vc.getProducts(for:id) { [weak self] products in
//                                self?.viewSecondAsProducts = true
//                                self?.subCategoryProducts = products
//                                self?.secondCollectionView.isHidden = false
//                                self?.secondContainingView.isHidden = false
//                                self?.secondCollectionView.reloadData()
//                                vc.categoriesTableView.reloadData()
//                            }
//                        }
                    }
            }else {
                secondCollectionView.isHidden = true
                secondContainingView.isHidden = true
                if let vc = viewContainingController() as? SubCategoryVC {
                    vc.categoriesTableView.reloadData()
                }
            }
            
            
        }
    }
    private var hasChildren = false
    private var subCategoryProducts = [Product]()
    private var viewSecondAsProducts = false {
        didSet {
            if viewSecondAsProducts {
                secondCollectionHeight.constant = 200
            }else {
                secondCollectionHeight.constant = 90
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        firstCollectionView.dataSource = self
        firstCollectionView.delegate = self
        firstCollectionView.registerCellNib(cellClass: CategoryCollectionViewCell.self)
        
        secondCollectionView.dataSource = self
        secondCollectionView.delegate = self
        secondCollectionView.registerCellNib(cellClass: CategoryCollectionViewCell.self)
        secondCollectionView.registerCellNib(cellClass: CategoryProductCollectionViewCell.self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gesturesRecognized))
        categoryView.addGestureRecognizer(tapGesture)
        categoryView.layer.cornerRadius = 15
        categoryView.clipsToBounds = true
    }
    
    @objc func gesturesRecognized() {
        if hasChildren {
            if firstCollectionView.isHidden {
                firstCollectionView.isHidden = false
                firstCollectionView.reloadData()
            }else {
                firstCollectionView.isHidden = true
                secondCollectionView.isHidden = true
                secondContainingView.isHidden = true
            }
            if let vc = viewContainingController() as? SubCategoryVC {
                vc.categoriesTableView.reloadData()
            }
        }else {
            let vc = SeeAllProductsVC()
            vc.viewModel.categoryId = category?.id ?? 0
            viewContainingController()?.push(vc)
        }
    }
    
    func configureCell(with category:ChildCategory) {
        self.category = category
        self.nameLabel.text = category.name
        self.categoryImageView.setImage(with: category.image)
    }
    @IBAction func seeAllBtnTapped(_ sender: Any) {
        if viewSecondAsProducts {
            let vc = SeeAllProductsVC()
            vc.viewModel.products = self.subCategoryProducts
            viewContainingController()?.push(vc)
        }else {
            // goto subcategories with selected subcategory
            let vc = SubCategoryVC()
            vc.viewmodel.category = selectedSubCategory
        }
        
    }
}

extension SubCategoryBaseTableViewCell: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case firstCollectionView:
            if let subCategory = category?.categories?[indexPath.row] {
                if subCategory.id == selectedSubCategory?.id {
                    selectedSubCategory = nil
                }else {
                    firstCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    selectedSubCategory = subCategory
                    
                }
            }
            
        case secondCollectionView:
            if viewSecondAsProducts {
                //open selected product details
                if let vc = viewContainingController() as? SubCategoryVC {
                    vc.goToPoductDetails(with: subCategoryProducts[indexPath.row])
                }
            }else {
                //open subcategory details vc
                let vc = SubCategoryVC()
                vc.viewmodel.category = selectedSubCategory
                viewContainingController()?.push(vc)
            }
            break
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        switch collectionView {
        case firstCollectionView:
            return CGSize(width: width / 3 * 2 + 8, height: collectionView.frame.height)
        case secondCollectionView:
            if viewSecondAsProducts {
                return CGSize(width: 124, height: collectionView.frame.height)
            }else {
                return CGSize(width: width / 3 * 2 + 8, height: collectionView.frame.height)
            }
            
        default:
            return .zero
        }
    }
}

extension SubCategoryBaseTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case firstCollectionView:
            return category?.categories?.count ?? 0
        case secondCollectionView:
            if viewSecondAsProducts {
                return 4
            }else {
                return selectedSubCategory?.categories?.count ?? 0
            }
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case firstCollectionView:
            let cell = collectionView.dequeue(indexPath: indexPath) as CategoryCollectionViewCell
            cell.configure(with: category?.categories?[indexPath.row])
            return cell
        case secondCollectionView:
            if viewSecondAsProducts {
                let cell = collectionView.dequeue(indexPath: indexPath) as CategoryProductCollectionViewCell
                cell.configure(with: subCategoryProducts[indexPath.row])
                return cell
            }else {
                let cell = collectionView.dequeue(indexPath: indexPath) as CategoryCollectionViewCell
                cell.configure(with: selectedSubCategory?.categories?[indexPath.row])
                return cell
            }
            
        default:
            return UICollectionViewCell()
        }
        
    }
}

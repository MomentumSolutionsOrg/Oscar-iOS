//
//  CategoryTableViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 28/06/2021.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var firstCollectionView: UICollectionView!
    @IBOutlet weak var categoryImageView: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondContainingView: UIView!
    @IBOutlet weak var secondCollectionView: UICollectionView!
    @IBOutlet weak var secondCollectionHeight: NSLayoutConstraint!
    private var cellIndexPath: IndexPath?
    private var selection = false {
        didSet {
            if selection {
                firstCollectionView.isHidden = false
            }else {
                firstCollectionView.isHidden = true
                secondContainingView.isHidden = true
                secondCollectionView.isHidden = true
                subCategoryProducts.removeAll()
            }
        }
    }
    private var category: MainCategory?
    private var selectedSubCategory: ChildCategory?
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
        selectedSubCategory = nil
        if firstCollectionView.isHidden {
            firstCollectionView.isHidden = false
            firstCollectionView.reloadData()
        }else {
            subCategoryProducts.removeAll()
            firstCollectionView.isHidden = true
            secondCollectionView.isHidden = true
            secondContainingView.isHidden = true
        }
        if let vc = viewContainingController() as? CategoriesVC {
            vc.selectRow(at: cellIndexPath ?? IndexPath(row: 0, section: 0))
        }
    }
    
    func configureCell(with category:MainCategory, selection: Bool, cellIndexPath: IndexPath, selectedSubCategory: ChildCategory?, selectedSubCategoryIndex: IndexPath?) {
        self.selection = selection
        self.category = category
        if selection {
            self.selectedSubCategory = selectedSubCategory
        }else {
            self.selectedSubCategory = nil
        }
        
        self.cellIndexPath = cellIndexPath
        self.nameLabel.text = category.name
        self.categoryImageView.setImage(with: category.image?.src ?? "")
        firstCollectionView.reloadData()
        if let selectedIndexPath = selectedSubCategoryIndex, selection {
            if #available(iOS 13.0 , *) {
                firstCollectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
            }else {
                firstCollectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: false)
            }
            
            print("currentIndex --> \(selectedIndexPath.row)")
        }else {
            if category.children?.count ?? 0 > 0 {
                firstCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
        updateSecondCollection()
    }
    
    private func updateSecondCollection() {
        if let subCategory = selectedSubCategory,
           selection == true {
            if subCategory.categories?.count ?? 0 > 0 {
                viewSecondAsProducts = false
                secondContainingView.isHidden = false
                secondCollectionView.isHidden = false
                self.selectedSubCategory = subCategory
                secondCollectionView.reloadData()
            }else {
                // view products
                viewSecondAsProducts = true
                secondContainingView.isHidden = false
                secondCollectionView.isHidden = false
                secondCollectionView.reloadData()
                if let vc = viewContainingController() as? CategoriesVC,
                   let id = selectedSubCategory?.id {
                    vc.getProducts(for:id) { [weak self] products in
                        guard let self = self else { return }
                        self.viewSecondAsProducts = true
                        self.subCategoryProducts = products
                        self.secondCollectionView.reloadData()
                    }
                }
            }
        }else {
            subCategoryProducts.removeAll()
            secondCollectionView.isHidden = true
            secondContainingView.isHidden = true
        }
    }
    @IBAction func seeAllButtonTapped(_ sender: Any) {
        if viewSecondAsProducts {
            let vc = SeeAllProductsVC()
            vc.viewModel.products = self.subCategoryProducts
            viewContainingController()?.push(vc)
        }else {
            // goto subcategories with selected subcategory
            if let subcategory = selectedSubCategory {
                let vc = SubCategoryVC()
                vc.viewmodel.category = subcategory
                viewContainingController()?.push(vc)
            }
        }
    }
}

extension CategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case firstCollectionView:
            var subCategoryIndex: IndexPath?
            if let subCategory = category?.children?[indexPath.row] {
                if subCategory.id == selectedSubCategory?.id, !secondCollectionView.isHidden {
                    selectedSubCategory = nil
                }else {
                    selectedSubCategory = subCategory
                    subCategoryIndex = indexPath
                }
                if let viewController = viewContainingController() as? CategoriesVC {
                    viewController.select(childrenCategory: self.selectedSubCategory, subCategoryIndex: subCategoryIndex)
                }
            }
            
        case secondCollectionView:
            if viewSecondAsProducts {
                //open selected product details
                if let vc = viewContainingController() as? CategoriesVC {
                    vc.goToProductDetails(with: subCategoryProducts[indexPath.row])
                }
            }else {
                //open subcategory details vc
                if let subcategory = selectedSubCategory?.categories?[indexPath.row] {
                    if (subcategory.categories?.count ?? 0) > 0 {
                        let vc = SubCategoryVC()
                        vc.viewmodel.category = subcategory
                        viewContainingController()?.push(vc)
                    }else {
                        let vc = SeeAllProductsVC()
                        vc.viewModel.categoryId = subcategory.id ?? 1
                        viewContainingController()?.push(vc)
                    }
                }
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
                return CGSize(width: 124, height: 200)
            }else {
                return CGSize(width: width / 3 * 2 + 8, height: 90)
            }
            
        default:
            return .zero
        }
    }
}

extension CategoryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case firstCollectionView:
            return category?.children?.count ?? 0
        case secondCollectionView:
            if viewSecondAsProducts {
                if subCategoryProducts.count > 4 {
                    return 4
                }else {
                    return subCategoryProducts.count
                }
                
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
            cell.configure(with: category?.children?[indexPath.row])
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



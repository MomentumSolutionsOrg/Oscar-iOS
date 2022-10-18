//
//  ExpandingSideMenuTableViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 27/06/2021.
//

import UIKit

protocol ExpandingCellDelegate: AnyObject {
    func didSelect(mainCategory: MainCategory)
    func didSelectSubCategory()
}

class ExpandingSideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var subCategoriesTableView: SelfSizedTableView! {
        didSet {
            subCategoriesTableView.delegate = self
            subCategoriesTableView.dataSource = self
            subCategoriesTableView.registerCellNib(cellClass: ExpandingSideMenuTableViewCell.self)
            //subCategoriesTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    @IBOutlet weak var subCategoryImageView: CircleImageView!
    @IBOutlet weak var subCategoryImageViewWidth: NSLayoutConstraint!
    
    weak var delegate: ExpandingCellDelegate?
    var isMainCategories = false
    var hasChildren = true
    var mainCategories = [MainCategory]()
    var selectedMainCategory: MainCategory?
    var selectedSubCategory: ChildCategory?
    var childrenCategories = [ChildCategory]()
    
    private func setupAsParent() {
        blueView.isHidden = true
        titleLabel.textColor = UIColor.blackTextColor
        plusLabel.textColor = UIColor.blackTextColor
        titleLabel.text = "Departments".localized.uppercased()
        subCategoryImageView.isHidden = true
        subCategoryImageViewWidth.constant = 0
    }
    
    
    func configureCell(with categories:[MainCategory],selectedMainCategory: MainCategory?, expand: Bool) {
        setupAsParent()
        isMainCategories = true
        hasChildren = mainCategories.count > 0
        mainCategories = categories
        self.selectedMainCategory = selectedMainCategory
        if expand {
            if subCategoriesTableView.isHidden {
                subCategoriesTableView.isHidden = false
                subCategoriesTableView.reloadData()
            }else {
                if #available(iOS 15, *) {
                    let indexPaths = categories.enumerated().map { IndexPath(row: $0.offset, section: 0) }
                    subCategoriesTableView.reconfigureRows(at: indexPaths)
                }else {
                    subCategoriesTableView.reloadData()
                }
            }
            plusLabel.text = "-"
        }else {
            subCategoriesTableView.isHidden = true
            plusLabel.text = "+"
            subCategoriesTableView.reloadData()
        }
        layoutIfNeeded()
    }
    
    func configureCell(with category:MainCategory, expand: Bool) {
        isMainCategories = false
        titleLabel.text = category.name?.uppercased()
        titleLabel.textColor = UIColor.blueColor
        plusLabel.textColor = UIColor.blueColor
        subCategoryImageView.isHidden = false
        subCategoryImageView.setImage(with: category.iconImage ?? "")
        configure(expand: expand, children: category.children ?? [])
    }
    
    func configureCell(with childCategory:ChildCategory, expand: Bool) {
        isMainCategories = false
        titleLabel.text = childCategory.name
        titleLabel.textColor = UIColor.blackTextColor
        plusLabel.textColor = UIColor.blackTextColor
        subCategoryImageView.isHidden = false
        subCategoryImageView.setImage(with: childCategory.iconImage ?? "")
        configure(expand: expand, children: childCategory.categories ?? [])
    }
    
    private func configure(expand: Bool, children: [ChildCategory]) {
        if children.count > 0 {
            hasChildren = true
            plusLabel.isHidden = false
        }else {
            hasChildren = false
            plusLabel.isHidden = true
        }
        if expand {
            childrenCategories = children
            if subCategoriesTableView.isHidden {
                subCategoriesTableView.isHidden = false
                subCategoriesTableView.reloadData()
            }else {
                if #available(iOS 15, *) {
                    let indexPaths = childrenCategories.enumerated().map { IndexPath(row: $0.offset, section: 0) }
                    subCategoriesTableView.reconfigureRows(at: indexPaths)
                }else {
                    subCategoriesTableView.reloadData()
                }
            }
            plusLabel.text = "-"
            subCategoriesTableView.isHidden = false
            plusLabel.text = "-"
        }else {
            childrenCategories = []
            subCategoriesTableView.isHidden = true
            selectedSubCategory = nil
            plusLabel.text = "+"
            subCategoriesTableView.reloadData()
        }
        layoutIfNeeded()
    }
}


extension ExpandingSideMenuTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMainCategories {
            return mainCategories.count
        }else {
            return childrenCategories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ExpandingSideMenuTableViewCell
        if isMainCategories {
            let expand = mainCategories[indexPath.row].id == selectedMainCategory?.id
            cell.configureCell(with: mainCategories[indexPath.row], expand: expand)
        }else {
            let expand = childrenCategories[indexPath.row].id == selectedSubCategory?.id
            cell.configureCell(with: childrenCategories[indexPath.row],expand: expand)
        }
        cell.delegate = delegate
        return cell
    }
    
}

extension ExpandingSideMenuTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("Tap Recognized inside cell")
        if let cell = tableView.cellForRow(at: indexPath) as? ExpandingSideMenuTableViewCell,
           cell.hasChildren {
            if isMainCategories {
                delegate?.didSelect(mainCategory: mainCategories[indexPath.row])
            }else {
                if selectedSubCategory?.id == childrenCategories[indexPath.row].id {
                    selectedSubCategory = nil
                }else {
                    selectedSubCategory = childrenCategories[indexPath.row]
                }
                if #available(iOS 15, *) {
                    //tableView.reconfigureRows(at: [indexPath])
                }else {
                    tableView.reloadData()
                    self.layoutIfNeeded()
                }
                delegate?.didSelectSubCategory()
                
            }
        }else {
            let vc = SeeAllProductsVC()
            // navigate to category products
            if isMainCategories {
                vc.viewModel.categoryId = mainCategories[indexPath.row].id ?? 1
            }else {
                vc.viewModel.categoryId = childrenCategories[indexPath.row].id ?? 1
            }
            viewContainingController()?.push(vc)
        }
    }
}

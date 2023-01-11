//
//  CategoriesVC.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 28/06/2021.
//

import BarcodeScanner

class CategoriesVC: BaseViewController {

    @IBOutlet weak var categoriesTableView: UITableView!
    private let viewModel = CategoriesViewmodel()
    private var selectedIndex: IndexPath?
    private var subCategoryIndex: IndexPath?
    private var childrenCategory: ChildCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedIndex = nil
        childrenCategory = nil
        categoriesTableView.reloadData()
        viewModel.getCategories()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !viewModel.mainCategories.isEmpty {
            categoriesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func getProducts(for id:Int,completion:@escaping ([Product])->()) {
        viewModel.getProducts(for: id, completion: completion)
    }
    
    func goToProductDetails(with product:Product) {
        let productDetails = ProductDetailsVC()
        productDetails.viewModel.product = product
        push(productDetails)
    }
    
    func selectRow(at indexPath:IndexPath) {
        if viewModel.mainCategories[indexPath.row].children?.isEmpty ?? true {
            let id = viewModel.mainCategories[indexPath.row].id
            let vc = SeeAllProductsVC()
            vc.viewModel.categoryId = id
            push(vc)
            return
        }
        if selectedIndex?.row == indexPath.row {
            selectedIndex = nil
        }else {
            selectedIndex = indexPath
        }
        childrenCategory = nil
        subCategoryIndex = nil
        categoriesTableView.reloadData()
        if categoriesTableView.cellForRow(at: indexPath) != nil {
            if indexPath.row == viewModel.mainCategories.count - 1 {
                categoriesTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }else {
                categoriesTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    
    func select(childrenCategory: ChildCategory?, subCategoryIndex: IndexPath?) {
        self.childrenCategory = childrenCategory
        self.subCategoryIndex = subCategoryIndex
        categoriesTableView.reloadData()
    }
    @IBAction func barcodeTapped(_ sender: Any) {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        present(viewController, animated: true, completion: nil)
    }
    @IBAction func searchTapped(_ sender: Any) {
        push(SearchVC())
    }
}

fileprivate extension CategoriesVC {
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        viewModel.updateTable = { [weak self] in
            DispatchQueue.main.async {
                self?.categoriesTableView.reloadData()
            }
        }
        
        viewModel.barcodeSearchCompletion = { [weak self] productVC in
            if let productVC = productVC {
                self?.push(productVC)
            }else {
                self?.showToast(message: "product_not_found".localized)
            }
        }
    }
    func setupTableView() {
        // Do any additional setup after loading the view.
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.registerCellNib(cellClass: CategoryTableViewCell.self)
    }
}

extension CategoriesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.mainCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as CategoryTableViewCell
        //cell.isSelected = viewModel.selectedCategoryIndex == indexPath.row
        cell.configureCell(with: viewModel.mainCategories[indexPath.row],
                           selection: selectedIndex?.row == indexPath.row,
                           cellIndexPath: indexPath,
                           selectedSubCategory: childrenCategory,
                           selectedSubCategoryIndex: subCategoryIndex)
        return cell
    }
    
    
}

extension CategoriesVC: UITableViewDelegate {
}



// MARK: - Barcode Delegates

extension CategoriesVC: BarcodeScannerCodeDelegate {
  func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
    print(code)
    controller.dismiss()
    viewModel.getProduct(for: code)
  }
}

extension CategoriesVC: BarcodeScannerErrorDelegate {
  func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
    print(error)
  }
}

extension CategoriesVC: BarcodeScannerDismissalDelegate {
  func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}


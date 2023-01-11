//
//  SubCategoryVC.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 11/07/2021.
//

import UIKit

class SubCategoryVC: BaseViewController {

    @IBOutlet weak var categoriesTableView: UITableView!
    
    let viewmodel = SubCategoryViewmodel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewModel()
    }
    
    
//    func getProducts(for id:Int,completion:@escaping ([Product])->()) {
//        viewmodel.getProducts(for: id, completion: completion)
//    }
    
    func goToPoductDetails(with product:Product) {
        let productDetails = ProductDetailsVC(product: product)
        push(productDetails)
    }
    @IBAction func backTapped(_ sender: Any) {
        pop()
    }
}

fileprivate extension SubCategoryVC {
    func setupViewModel() {
        setupViewModel(viewModel: viewmodel)
    }
    func setupTableView() {
        // Do any additional setup after loading the view.
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.registerCellNib(cellClass: SubCategoryBaseTableViewCell.self)
    }
}

extension SubCategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.category?.categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as SubCategoryBaseTableViewCell
        if let category = viewmodel.category?.categories?[indexPath.row] {
            cell.configureCell(with: category)
        }
        return cell
    }
    
    
}

extension SubCategoryVC: UITableViewDelegate {
    
}


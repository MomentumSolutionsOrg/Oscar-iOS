//
//  FilterVC.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 07/07/2021.
//

import UIKit

protocol FilterDelegate:AnyObject {
    func didSelectFilters(categories:[MainCategory])
    func didSelectPrice(min: String, max: String)
}

class FilterVC: BaseViewController {

    @IBOutlet weak var filterTableView: UITableView!
    
    weak var delegate:FilterSortDelegate?
    private let viewModel = FiltersViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewmodel()
        setupTableView()
    }
    @IBAction func clearFilterTapped(_ sender: Any) {
        delegate?.resetFilters()
        dismiss()
    }
    @IBAction func showResultTapped(_ sender: Any) {
        delegate?.applyFilters(with: viewModel.selectedCategories, minPrice: viewModel.minPrice, maxPrice: viewModel.maxPrice)
        dismiss()
    }
}

fileprivate extension FilterVC {
    func setupViewmodel() {
        setupViewModel(viewModel: viewModel)
        viewModel.updateTable = { [weak self] in
            self?.filterTableView.reloadData()
        }
        viewModel.getCategories()
    }
    
    func setupTableView() {
        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.registerCellNib(cellClass: BasicFilterTableViewCell.self)
        filterTableView.registerCellNib(cellClass: PriceFilterTableViewCell.self)
        filterTableView.tableFooterView = UIView(frame: .zero)
    }
}

extension FilterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? BasicFilterTableViewCell {
            cell.showHideTableView()
            tableView.reloadData()
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? PriceFilterTableViewCell {
            cell.showHidePriceRange()
            tableView.reloadData()
        }
    }
}

extension FilterVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.filterItems[indexPath.row] {
        case .category:
            let cell = tableView.dequeue() as BasicFilterTableViewCell
            cell.delegate = self
            cell.configureCell(with: viewModel.mainCategories)
            return cell
        case .priceRange:
            let cell = tableView.dequeue() as PriceFilterTableViewCell
            cell.delegate = self
            return cell
        }
    }
}


extension FilterVC: FilterSelectionDelegate {
    func didSelectPrice(min: String, max: String) {
            viewModel.minPrice = min
            viewModel.maxPrice = max
    }
    
    func didSelectFilters(_ selectedFilters: [MainCategory]) {
        viewModel.selectedCategories = selectedFilters
    }
}

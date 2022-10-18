//
//  SortVC.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 07/07/2021.
//

import UIKit

class SortVC: BaseViewController {
    
    @IBOutlet weak var sortTableView: SelfSizedTableView!
    weak var delegate:FilterSortDelegate?
    private let viewModel = SortViewModel()
    var previousSort = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        
    }
    
    func setupTableView() {
        sortTableView.delegate = self
        sortTableView.dataSource = self
        sortTableView.tableFooterView = UIView(frame: .zero)
        sortTableView.registerCellNib(cellClass: FilterSelectionTableViewCell.self)
        viewModel.selectedSort = previousSort
        sortTableView.reloadData()
    }
}


extension SortVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                viewModel.selectedSort = ""
            case 1:
                viewModel.selectedSort = "a_to_z"
            case 2:
                viewModel.selectedSort = "z_to_a"
            default:
                break
            }
            delegate?.sort(with: viewModel.selectedSort, sortPriceSelection: "")
        case 1:
            switch indexPath.row {
            case 0:
                viewModel.selectedSort = "low_to_high"
            case 1:
                viewModel.selectedSort = "high_to_low"
            default:
                break
            }
            delegate?.sort(with: "", sortPriceSelection: viewModel.selectedSort)
        default:
            break
        }
        
        dismiss()
        
    }
}

extension SortVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as FilterSelectionTableViewCell
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.isSelected = viewModel.selectedSort == ""
                cell.configureCell(with: "All")
            case 1:
                cell.isSelected = viewModel.selectedSort == "a_to_z"
                cell.configureCell(with: "Name: A - Z")
            case 2:
                cell.isSelected = viewModel.selectedSort == "z_to_a"
                cell.configureCell(with: "Name: Z - A")
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.isSelected = viewModel.selectedSort == "low_to_high"
                cell.configureCell(with: "Price: Low To High")
            case 1:
                cell.isSelected = viewModel.selectedSort == "high_to_low"
                cell.configureCell(with: "Price: High To Low")
            default:
                break
            }
        default:
            break
        }
        return cell
    }
    
    
}

//
//  BasicFilterTableViewCell.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 07/07/2021.
//

import UIKit

protocol FilterSelectionDelegate: AnyObject {
    func didSelectFilters(_ selectedFilters:[MainCategory])
    func didSelectPrice(min:String,max:String)
}

class BasicFilterTableViewCell: UITableViewCell {
    @IBOutlet weak var numberBackView: UIView!
    @IBOutlet weak var selectionNumberLabel: UILabel!
    @IBOutlet weak var filtersTableView: UITableView!
    @IBOutlet weak var filterTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterSectionNameLabel: UILabel!
    
    weak var delegate: FilterSelectionDelegate?
    private var categories = [MainCategory]()
    private(set) var selectedFilters = [MainCategory]() {
        didSet {
            numberBackView.isHidden = selectedFilters.count == 0
            selectionNumberLabel.text = selectedFilters.count.description
            delegate?.didSelectFilters(selectedFilters)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        filtersTableView.registerCellNib(cellClass: FilterSelectionTableViewCell.self)
        filtersTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func configureCell(with categories:[MainCategory]) {
        self.categories = categories
        filtersTableView.reloadData()
    }
    
    func showHideTableView() {
        filtersTableView.isHidden.toggle()
        if filtersTableView.isHidden {
            filterTableViewHeightConstraint.constant = 0
        }else {
            filterTableViewHeightConstraint.constant = 200
        }
        filtersTableView.reloadData()
    }
}

extension BasicFilterTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedFilters.contains(where: { category in
            category.id == categories[indexPath.row].id
        }) {
            selectedFilters.removeAll { $0.id == categories[indexPath.row].id }
        }else {
            selectedFilters.append(categories[indexPath.row])
        }
        tableView.reloadData()
    }
}

extension BasicFilterTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as FilterSelectionTableViewCell
        cell.isSelected = selectedFilters.contains(where: { category in
            category.id == categories[indexPath.row].id
        })
        cell.configureCell(with: categories[indexPath.row])
        return cell
    }
    
    
}


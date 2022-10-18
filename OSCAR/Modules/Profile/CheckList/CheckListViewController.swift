//
//  CheckListViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 08/08/2021.
//

import UIKit
import RealmSwift

class CheckListViewController: BaseViewController {
    @IBOutlet weak var checkListTableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    
    var checkLists: [CheckList] {
        return  RealmHelper.shared.getCheckLists().sorted { $0.isPinned && !$1.isPinned }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupTableView() {
        checkListTableView.dataSource = self
        checkListTableView.delegate = self
        checkListTableView.registerCellNib(cellClass: CheckListTableViewCell.self)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
}

extension CheckListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CheckListTableViewCell {
            cell.isEmpty = false
            tableView.reloadData()
        }
    }
}

extension CheckListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkLists.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as CheckListTableViewCell
        if indexPath.row == checkLists.count {
            cell.configureEmpty()
        }else {
            cell.configure(with: checkLists[indexPath.row])
        }
        return cell
    }
}

extension CheckListViewController: CheckListUpdateDelegate {
    func updateTableView() {
        print(checkLists.count)
        checkListTableView.reloadData()
    }
}

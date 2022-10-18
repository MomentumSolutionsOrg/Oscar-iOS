//
//  SideMenuVC.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 27/06/2021.
//

import UIKit
import SwiftUI

class SideMenuVC: BaseViewController {

    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    private let viewModel = SideMenuViewModel()
    private var showMain = false
    private var selectedMainCategory: MainCategory?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        setupViewmodel()
        if let appVersion = UIApplication.appVersion {
            appVersionLabel.text = "Version \(appVersion)"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        sideMenuTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


fileprivate extension SideMenuVC {
    func setupViewmodel() {
        setupViewModel(viewModel: viewModel)
        viewModel.updateTable = { [weak self] in
            self?.sideMenuTableView.reloadData()
        }
        viewModel.getCategories()
    }
    func setupTableView() {
        sideMenuTableView.dataSource = self
        sideMenuTableView.delegate = self
        sideMenuTableView.registerCellNib(cellClass: DefaultSideMenuTableViewCell.self)
        sideMenuTableView.registerCellNib(cellClass: ExpandingSideMenuTableViewCell.self)
    }
}
extension SideMenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("Tap Recognized from sidemenu vc")
        if let _ = tableView.cellForRow(at: indexPath) as? ExpandingSideMenuTableViewCell {
            showMain.toggle()
            tableView.reloadData()
        } else {
            switch indexPath.row {
            case 1:// About Us
                push(AboutUsViewController())
            case 2: // Contact Us
                push(ContactUsViewController())
            case 3: // How to use app
                pushWithTabBar(vc: HowToUseVideoVC(),isTabBarHidden: true)
                break
            case 4: // Terms and Conditions
                break
            default:
                break
            }
        }
    }
}

extension SideMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 0 {
            let cell = tableView.dequeue() as DefaultSideMenuTableViewCell
            cell.setup(with: indexPath)
            return cell
        }else {
            let cell = tableView.dequeue() as ExpandingSideMenuTableViewCell
            cell.configureCell(with: viewModel.mainCategories
                               ,selectedMainCategory: selectedMainCategory
                               ,expand: showMain)
            cell.delegate = self
            return cell
        }
        
    }
}

extension SideMenuVC: ExpandingCellDelegate {
    func didSelect(mainCategory: MainCategory) {
        if selectedMainCategory?.id == mainCategory.id {
            selectedMainCategory = nil
        }else {
            selectedMainCategory = mainCategory
        }
        if #available(iOS 15, *) {
            sideMenuTableView.reconfigureRows(at: [IndexPath(row: 0, section: 0)])
        }else {
            sideMenuTableView.reloadData()
        }
    }
    
    func didSelectSubCategory() {
//        if selectedChildCategory?.id == childCategory.id {
//            selectedChildCategory = nil
//        }else {
//            selectedChildCategory = childCategory
//        }
        
        if #available(iOS 15, *) {
            sideMenuTableView.reconfigureRows(at: [IndexPath(row: 0, section: 0)])
        }else {
            sideMenuTableView.reloadData()
        }
        //sideMenuTableView.reloadData()
    }
    
}

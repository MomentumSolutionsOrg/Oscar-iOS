//
//  SearchVC.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 27/06/2021.
//

import UIKit

protocol FilterSortDelegate: AnyObject {
    func applyFilters(with categories:[MainCategory],minPrice:String,maxPrice:String)
    func resetFilters()
    func sort(with sortNameSelection:String,sortPriceSelection:String)
}

class SearchVC: BaseViewController, ProductCellDelegate {

    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    @IBOutlet weak var resultNumberLabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var searchTF: GeneralTextField!
    
    private var showType:Constants.ShowType = .grid
    private let viewModel = SearchViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewButton.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        setupCollectionView()
        setupViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let name = searchTF.text,
           name != "" {
            //let search = name.replacingOccurrences(of:" ", with: "%20")
            viewModel.search(for: name)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
    @IBAction func searchButtonTapped(_ sender: Any) {
        if let name = searchTF.text,
           name != "" {
            //let search = name.replacingOccurrences(of:" ", with: "%20")
            viewModel.search(for: name)
        }
        searchTF.endEditing(true)
    }
    @IBAction func filterButtonTapped(_ sender: Any) {
        if viewModel.products.count > 0 {
            let filterVC = FilterVC()
            filterVC.delegate = self
            filterVC.modalPresentationStyle = .popover
            present(filterVC)
        }else {
            showToast(message: "nothing_to_filter".localized)
        }
        
    }
    @IBAction func sortButtonTapped(_ sender: Any) {
        if viewModel.products.count > 0 {
            let sortVC = SortVC()
            sortVC.delegate = self
            if viewModel.selectedSortName.isEmpty {
                sortVC.previousSort = viewModel.selectedSortPrice
            }else {
                sortVC.previousSort = viewModel.selectedSortName
            }
            sortVC.modalPresentationStyle = .popover
            present(sortVC)
        }else {
            showToast(message: "nothing_to_sort".localized)
        }
        
    }
    @IBAction func viewButtonTapped(_ sender: Any) {
        if showType == .grid {
            viewButton.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
            showType = .list
        }else {
            viewButton.setImage(#imageLiteral(resourceName: "list"), for: .normal)
            showType = .grid
        }
        
        searchResultsCollectionView.reloadData()
    }
    
}

fileprivate extension SearchVC {
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        viewModel.completion = { [weak self] in
            self?.searchResultsCollectionView.reloadData()
            self?.resultNumberLabel.text = (self?.viewModel.filteredProducts.count.description ?? "0") + " " + "results".localized
        }
        
        viewModel.productCompletion = { [weak self] productVC in
            if let productVC = productVC {
                self?.push(productVC)
            }else {
                self?.showToast(message: "product_not_available".localized)
            }
        }
    }
    
    func setupCollectionView() {
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.registerCellNib(cellClass: GridCollectionViewCell.self)
        searchResultsCollectionView.registerCellNib(cellClass: ListCollectionViewCell.self)
        
    }
}


extension SearchVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.getProduct(for: viewModel.filteredProducts[indexPath.row].productID ?? "1")
    }
}

extension SearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch showType {
        case .grid:
            let cell = collectionView.dequeue(indexPath: indexPath) as GridCollectionViewCell
            cell.delegate = self
            cell.configureCell(with: viewModel.filteredProducts[indexPath.row])
            return cell
        case .list:
            let cell = collectionView.dequeue(indexPath: indexPath) as ListCollectionViewCell
            cell.delegate = self
            cell.configureCell(with: viewModel.filteredProducts[indexPath.row])
            return cell
        }
    }
}

extension SearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        switch showType {
        case .grid:
            return CGSize(width: width/2, height: 260)
        case .list:
            return CGSize(width: width, height: 82)
        }
    }
}

extension SearchVC: FilterSortDelegate {
    func applyFilters(with categories: [MainCategory], minPrice: String, maxPrice: String) {
        viewModel.selectedCategories = categories
        viewModel.minPrice = minPrice
        viewModel.maxPrice = maxPrice
        viewModel.filterSort()
    }
    
    func resetFilters() {
        viewModel.resetFilters()
    }
    
    func sort(with sortNameSelection: String, sortPriceSelection: String) {
        viewModel.selectedSortName = sortNameSelection
        viewModel.selectedSortPrice = sortPriceSelection
        viewModel.filterSort()
    }
    
}

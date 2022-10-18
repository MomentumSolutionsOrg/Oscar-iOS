//
//  PlacesVC.swift
//  OSCAR
//
//  Created by Mostafa Samir on 12/22/20.
//  Copyright © 2020 Mostafa Samir. All rights reserved.
//

import UIKit
import MapKit

class PlacesVC: BaseViewController {
    @IBOutlet weak var placesTableView: UITableView!
    
    weak var delegate:PlaceSelectionDelegate?
    weak var mapView: MKMapView?
    var matchingItems:[MKMapItem] = []
    let searchController = UISearchController(searchResultsController: nil)
    var search: MKLocalSearch?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupSearchController()
    }
    
    func setupTable() {
        placesTableView.dataSource = self
        placesTableView.delegate = self
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: placesTableView.frame.width, height: 1))
        footerView.backgroundColor = .clear
        placesTableView.tableFooterView = footerView
        placesTableView.tableHeaderView = searchController.searchBar
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.delegate = self
    }
}

extension PlacesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if matchingItems.count == 0 {
            placesTableView.setEmptyView(title: "", message: "no_search_result".localized)
        }else {
            placesTableView.restore()
        }
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = matchingItems[indexPath.row].placemark.name
        return cell
    }
    
    
}

extension PlacesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(place: matchingItems[indexPath.row].placemark)
    }
}

extension PlacesVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        if searchBarText == "" {
            search?.cancel()
            matchingItems.removeAll()
            placesTableView.reloadData()
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        if let mapView = mapView {
            request.region = mapView.region
        }else {
            let location = CLLocation(latitude: 26.820553, longitude: 30.802498)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            request.region = region
        }
        
        if search?.isSearching ?? true {
            search?.cancel()
        }
        search = MKLocalSearch(request: request)
        search?.start { [weak self] response, error in
            self?.dismissLoadingView()
            if let error = error {
                print(error)
                return
            }
            guard let response = response else {
                return
            }
            self?.matchingItems = response.mapItems
                .filter { $0.placemark.countryCode?.lowercased() == "eg" }
            self?.placesTableView.reloadData()
        }
    }
}
extension PlacesVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
}

extension PlacesVC: MKMapViewDelegate {
    
}

protocol PlaceSelectionDelegate: AnyObject {
    func didSelect(place:MKPlacemark)
}


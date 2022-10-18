//
//  ChooseOnMapViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//

import MapKit

class ChooseOnMapViewController: BaseViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchTextField: GeneralTextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    var viewModel: AddressesViewModel?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation? {
        didSet {
            viewModel?.mapCoordinates = "\(currentLocation?.coordinate.latitude.description ?? ""),\(currentLocation?.coordinate.longitude.description ?? "")"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupMapView()
    }
    
    func setupMapView() {
        mapView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(gestureRecognized(gestureRecognizer:)) )
        mapView.addGestureRecognizer(tapGesture)
        locationManager.delegate = self
        showLoadingView()
        locationManager.requestWhenInUseAuthorization()
    }
    @objc func gestureRecognized(gestureRecognizer:UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        addAnnotation(for: newCoordinates)
        
    }
    
    func addAnnotation(for coordinate: CLLocationCoordinate2D) {
        viewModel?.mapCoordinates = "\(coordinate.latitude),\(coordinate.longitude)"
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
    
    @IBAction func setCurrentLocationTapped(_ sender: Any) {
        let vc = AddressInformationViewController()
        vc.viewModel = viewModel
        push(vc)
        
    }
}

extension ChooseOnMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .denied {
            locationManager.requestLocation()
        }else {
            dismissLoadingView()
            showSettingsAlert(title: "", message: "access_location_message".localized)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        dismissLoadingView()
        if let location = locations.first {
            currentLocation = location
            mapView.centerToLocation(location)
        }
    }
}

extension ChooseOnMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotationView.image = #imageLiteral(resourceName: "annotation")
        return annotationView
    }
}

extension MKMapView {
  func centerToLocation(
    _ location: CLLocation
  ) {
    let coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    setRegion(coordinateRegion, animated: true)
  }
}

extension ChooseOnMapViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let vc = PlacesVC()
        vc.delegate = self
        vc.mapView = mapView
        present(vc)
        return false
    }
}

extension ChooseOnMapViewController: PlaceSelectionDelegate {
    func didSelect(place: MKPlacemark) {
        self.dismiss()
        if let location = place.location {
            mapView.centerToLocation(location)
        }
        addAnnotation(for: place.coordinate)
    }
    
}

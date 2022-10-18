//
//  TrackOrderViewController.swift
//  OSCAR
//
//  Created by Mostafa Samir on 08/08/2021.
//

import MapKit
import CoreLocation

class TrackOrderViewController: BaseViewController {
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var shippingAddressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    var locationManager = CLLocationManager()
    let viewModel = TrackOrderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func observeLogistaDriver() {
        viewModel.trackOrder { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            }else {
                self.addRouting()
            }
        }
    }
    
    func addRouting(for location: CLLocation) {
        let deliveryPlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: viewModel.shippingLatitude, longitude: viewModel.shippingLongitude))
        let deliveryItem = MKMapItem(placemark: deliveryPlaceMark)
        
        
        let driverPlaceMark = MKPlacemark(coordinate: location.coordinate)
        let driverItem = MKMapItem(placemark: driverPlaceMark)
        
        
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = driverItem
        directionsRequest.destination = deliveryItem
        directionsRequest.transportType = .automobile
        directionsRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else {
                if let error = error  {
                    self.showAlert(message: error.localizedDescription)
                }
                return
            }
            if let route = response.routes.first {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
            }
        }
        mapView.removeAnnotations(mapView.annotations)
        let driverAnnotation = MKPointAnnotation()
        driverAnnotation.coordinate = location.coordinate
        mapView.addAnnotation(driverAnnotation)
        
        let shippingAnnotation = MKPointAnnotation()
        shippingAnnotation.coordinate = deliveryPlaceMark.coordinate
        mapView.addAnnotation(shippingAnnotation)
        
    }
    
    func addRouting() {
        let deliveryPlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: viewModel.shippingLatitude, longitude: viewModel.shippingLongitude))
        let deliveryItem = MKMapItem(placemark: deliveryPlaceMark)
        
        
        let driverPlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: viewModel.driverLatitude, longitude: viewModel.driverLongitude))
        let driverItem = MKMapItem(placemark: driverPlaceMark)
        
        
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = driverItem
        directionsRequest.destination = deliveryItem
        directionsRequest.transportType = .automobile
        directionsRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response else {
                if let error = error  {
                    self.showAlert(message: error.localizedDescription)
                }
                return
            }
            if let route = response.routes.first {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        
        mapView.removeAnnotations(mapView.annotations)
        let driverAnnotation = MKPointAnnotation()
        driverAnnotation.coordinate = driverAnnotation.coordinate
        mapView.addAnnotation(driverAnnotation)
        
        let shippingAnnotation = MKPointAnnotation()
        shippingAnnotation.coordinate = deliveryPlaceMark.coordinate
        mapView.addAnnotation(shippingAnnotation)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        pop()
    }
}

extension TrackOrderViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {
            return nil
        }

        switch annotation.coordinate.latitude {
        case locationManager.location?.coordinate.latitude: // add annotation for driver
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.image = #imageLiteral(resourceName: "Group 679")
            return annotationView
        case viewModel.shippingLatitude: // add annotation for shipping address
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.image = #imageLiteral(resourceName: "annotation")
            return annotationView
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? MKPolyline else { return MKOverlayRenderer() }
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor(hexString: "#4A9DFF")
        return render
    }
}


extension TrackOrderViewController: CLLocationManagerDelegate {
    
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
            //mapView.centerToLocation(location)
            addRouting(for: location)
        }
    }
}

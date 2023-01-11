//
//  HomeViewmodel.swift
//  OSCAR
//
//  Created by Momentum Solutions Co. on 04/07/2021.
//

import MapKit

class HomeViewModel:BaseViewModel {
    
    //MARK: - Location
    private var locationManager = CLLocationManager()
    private(set) var branches = [Branch]() {
        didSet {
            selectedBranch = branches.first { $0.storeID == CurrentUser.shared.store }
        }
    }
    var selectedBranch:Branch? {
        didSet {
            let coordinates = "\(selectedBranch?.latitude ?? ""),\(selectedBranch?.longitude ?? "")"
            UserDefaultsManager.shared.saveInUserDefault(key: .currentStoreCoordinates, data: coordinates)
            print(coordinates, "🥷🏻🥷🏻🥷🏻🥷🏻🥷🏻")
            CurrentUser.shared.store = selectedBranch?.storeID ?? "01"
            Utils.checkCart()
            getDeliverFeesForClosingTime(stringCoordinates: coordinates)
          
        
        }
    }
    var deliveryLocation = ""
    var openSettingCompletion:(()->())?
    var branchesCompletion:(()->())?
    
    //MARK: - Product
    var barcodeSearchCompletion: ((ProductDetailsVC?)->())?
    
    //MARK: - Images
    var updateTableViewCompletion:(()->())?
    private(set) var sliders = [Slider]() {
        didSet {
            hasSliders = sliders.count > 0
        }
    }
    private(set) var banners = [Slider]() {
        didSet {
            hasBanners = banners.count > 0
        }
    }
    
    private(set) var pinterest = [Slider]()
    var deliveryFees = [DeliveryFees]()

    private(set) var hasSliders = false
    private(set) var hasBanners = false
    
    var productCompletion: ((ProductDetailsVC?)->())?
    var allProductsCompletion: ((SeeAllProductsVC?)->())?
    var reloadApp: (() -> ())?
    var pushContactUs: (() -> ())?
    var pushDepartments: (() -> ())?
    var pushAboutUS: (() -> ())?
    var closingTimeCompletion: (() -> ())?

    //MARK: - Images APis
    func fetchImages() {
        startRequest(request: HomeApi.banners, mappingClass: BaseModel<BannersResponse>.self) { [weak self] response in
            guard let self = self else { return }
            self.sliders = response?.data?.imageSlider?
                .filter { $0.image != nil && $0.image != "" } ?? []
            self.banners = response?.data?.banners?
                .filter { $0.image != nil && $0.image != "" } ?? []
            self.updateTableViewCompletion?()
        }
    }
    
    func fetchPinterestImages() {
        startRequest(request: HomeApi.pinterest, mappingClass: BaseModel<[Slider]>.self) { [weak self] response in
            self?.pinterest = response?.data ?? []
            self?.updateTableViewCompletion?()
        }
    }
    
    
    //MARK: - Location APis
    func requestLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
//    private func getDeliveryLocation(from location:CLLocation) {
//        let geoCoder = CLGeocoder()
//        var address = ""
//        geoCoder.reverseGeocodeLocation(location, completionHandler: { [weak self] (placeMarks, error) -> Void in
//            guard let self = self else { return }
//            if error != nil {
//                return
//            }
//            // Place details
//            var placeMark: CLPlacemark!
//            placeMark = placeMarks?[0]
//
//            if let region = placeMark.subLocality {
//                address += ", \(region)"
//            }
//
//            if let city = placeMark.administrativeArea {
//                address += ", \(city)"
//            }
//            self.deliveryLocation = address.trimmingCharacters(in: .punctuationCharacters)
//        })
//    }
    
    func createAddressFromCoordinates(coordinate: CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { [weak self] (placeMarks, error) -> Void in
            guard let self = self else { return }
            if error != nil {
                return
            }
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeMarks?[0]
            self.deliveryLocation = placeMark.thoroughfare ?? ""
        })
    }
    
    func getBranches(with location:CLLocation) {
        let longitude = Double(location.coordinate.longitude)
        let latitude = Double(location.coordinate.latitude)
        startRequest(request: HomeApi.branches(long: longitude, lat: latitude), mappingClass: BaseModel<[Branch]>.self) { [weak self] response in
            self?.branches = response?.data ?? []
            self?.branchesCompletion?()
        }
    }
    
    func getBranches(with location: String) {
        let locations = location.split(separator: ",").compactMap { Double($0) }
        let latitude = locations.first ?? 0.0
        var longitude = 0.0
        if locations.count > 1 {
            longitude = locations[1]
        }
        startRequest(request: HomeApi.branches(long: longitude, lat: latitude), mappingClass: BaseModel<[Branch]>.self) { [weak self] response in
            self?.branches = response?.data ?? []
            self?.branchesCompletion?()
        }
    }
    
    func getBranches() {
        startRequest(request: HomeApi.branchesWithoutLocation,
                     mappingClass: BaseModel<[Branch]>.self, successCompletion: { [weak self] response in
            self?.branches = response?.data ?? []
            self?.branchesCompletion?()
        },showLoading: false)
    }
    
    func getDeliverFeesForClosingTime(stringCoordinates: String?){
        let coordinates = stringCoordinates ?? Utils.defaultCoordinate()
        print(coordinates, "🥲🥲🥲🥲🥲🥲")
        startRequest(request:CheckoutProcessApi.getDeliveryFees(coordinates: coordinates),
                     mappingClass: BaseModel<[DeliveryFees]>.self) { [weak self] response in
          
            self?.deliveryFees = response?.data ?? []
            self?.closingTimeCompletion?()
        }
    }
    
    
    func getAddresses() {
        if let token = CurrentUser.shared.token,
           token != "" {
            startRequest(request: AddressApi.getAddresses, mappingClass: BaseModel<[Address]>.self, successCompletion: { [weak self] response in
                if let addresses = response?.data, addresses.isEmpty {
                    print("🤯🤯🤯")
                    self?.requestLocation()
                } else {
            
                    if let defaultAddress = response?.data?.first(where: { $0.isDefault == 1 }) {
                        self?.deliveryLocation = ((defaultAddress.area ?? "") + ", \(defaultAddress.city ?? "")").trimmingCharacters(in: .punctuationCharacters)
                        if let coordinates = defaultAddress.coordinates,
                           coordinates != "" {
                            self?.getBranches(with: coordinates)
                        }else {
                            self?.getBranches()
                        }
                    } else {
                        print("🤯🤯🤯🤯🤯🤯🤯🤯🤯")
                        self?.requestLocation()
                    }
                    
                }
          
            },showLoading: false)
        }
    }
    
    //MARK: - Product APis
    func getProduct(for barcode:String) {
        print(barcode, "🤯")
        startRequest(request: ProductApi.barcode(barcode: barcode), mappingClass: BarcodeResponse.self) { [weak self] response in
            if let product = response?.data {
                let productVC = ProductDetailsVC()
                productVC.viewModel.product = product
                productVC.viewModel.relatedProducts = response?.relatedProducts ?? []
                self?.barcodeSearchCompletion?(productVC)
            }else {
                self?.barcodeSearchCompletion?(nil)
            }
        }
    }
    
    // MARK: - Sliders And Banners DeepLinking
    
    func parse(link: String) {
        guard let url = URL(string: link) else { return }
        let components = url.pathComponents
        
        if components.contains("aboutus") ||
            components.contains("aboutust"){
            pushAboutUS?()
            return
        }else if components.contains("contact") {
            pushContactUs?()
            return
        }else if components.contains("department") {
            pushDepartments?()
            return
        }else if components.contains(Constants.DeepLinkingPaths.allProducts.rawValue) {
            if let categoryId = Int(components.last ?? "0"),
               categoryId != 0 {
                fetchCategoryProducts(for: categoryId)
            }
        }else if components.contains(Constants.DeepLinkingPaths.showProduct.rawValue) {
            if let productId = components.last,
               productId != "",
               productId != Constants.DeepLinkingPaths.showProduct.rawValue {
                fetchProduct(for: productId)
            }
        }
    }

    func openExternal(link: String) {
        guard let url = URL(string: link) else { return }
        UIApplication.shared.open(url)
    }
    
    private func fetchProduct(for id:String) {
        startRequest(request: ProductApi.showProduct(id: id), mappingClass: PaginationModel<Product>.self) { [weak self] response in
            if let product = response?.data?.data {
                let productVC = ProductDetailsVC()
                productVC.viewModel.product = product
//                productVC.viewModel.relatedProducts = response?.relatedProducts ?? []
                self?.productCompletion?(productVC)
            }else {
                self?.productCompletion?(nil)
            }
        }
    }
    
    func fetchCategoryProducts(for id:Int) {
        startRequest(request: CategoriesApi.getProducts(categoryId: id), mappingClass: PaginationModel<[Product]>.self) { [weak self] response in
            if let products = response?.data?.data,
               !products.isEmpty {
                let vc = SeeAllProductsVC()
                vc.viewModel.products = products
                self?.allProductsCompletion?(vc)
            }else {
                self?.allProductsCompletion?(nil)
            }
            
        }
    }
}

//MARK: - Location Extension
extension HomeViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        getBranches()
///If the location service is unable to retrieve a location right away, it reports a kCLErrorLocationUnknown error and keeps trying. In such a situation, you can simply ignore the error and wait for a new event.
        if error._code == 1 {
            
            openSettingCompletion?()
        }
     
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status != .denied || status == .restricted) {
            locationManager.requestLocation()
            
        }else {
            
            getBranches()
            openSettingCompletion?()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {
            getBranches(with: location)
            createAddressFromCoordinates(coordinate: .init(latitude: location.coordinate.latitude,
                                                           longitude: location.coordinate.longitude))
           
        }else {
            getBranches()
   
        }
    }
    
    func changeLanguage() {
       let language = LanguageManager.shared.isArabicLanguage() ? "en" : "ar"
        if LanguageManager.shared.changeLanguage(language: language) {
            reloadApp?()
        }
    }
}

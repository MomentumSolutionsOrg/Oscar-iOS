//
//  AddressesViewModel.swift
//  OSCAR
//
//  Created by Mostafa Samir on 02/08/2021.
//

import MapKit

enum AddressType {
    case new
    case edit
}

class AddressesViewModel: BaseViewModel {
    private(set) var addresses = [Address]() {
        didSet {
            successCompletion?()
        }
    }
    var selectedAddress: Address?
    var mapCoordinates: String? {
        didSet {
            addressType = .new
            createAddressFromCoordinates()
        }
    }
    var addressType: AddressType = .new
    var successCompletion: (() -> Void)?
    var sendAddressCompletion: (() -> Void)?
    
    func fetchAddresses() {
        startRequest(request: AddressApi.getAddresses, mappingClass: BaseModel<[Address]>.self) { [weak self] response in
            self?.addresses = response?.data ?? []
        }
    }
    
    func address(at indexPath: IndexPath) -> Address {
        return addresses[indexPath.row]
    }
    
    func select(at indexPath: IndexPath) {
        addressType = .edit
        self.selectedAddress = addresses[indexPath.row]
    }
    
    func sendAddress(with parameters:AddressParameters) {
        var newParameters = parameters
        switch addressType {
        case .new:
            if !(mapCoordinates?.isEmpty ?? true) {
                newParameters.coordinates = mapCoordinates ?? ""
            }
            addAddress(parameters: newParameters)
        case .edit:
            newParameters.coordinates = selectedAddress?.coordinates ?? ""
            updateAddress(parameters: newParameters)
        }
    }
    
    private func addAddress(parameters: AddressParameters) {
        startRequest(request: AddressApi.addAddress(parameters: parameters), mappingClass: MessageModel.self) { [weak self] response in
            self?.sendAddressCompletion?()
        }
    }
    
    private func updateAddress(parameters: AddressParameters) {
        startRequest(request: AddressApi.updateAddress(addressId: selectedAddress?.id ?? 0, parameters: parameters), mappingClass: MessageModel.self) { [weak self] response in
            self?.sendAddressCompletion?()
        }
    }
    
    func deleteAddress(at index: Int) {
        startRequest(request: AddressApi.deleteAddress(addressId: addresses[index].id ?? 0), mappingClass: MessageModel.self) { [weak self] response in
            self?.fetchAddresses()
        }
    }
    
    private func createAddressFromCoordinates() {
        let coordinates = mapCoordinates?.split(separator: ",").compactMap { Double($0.description) }
        let geoCoder = CLGeocoder()
        let longitude = coordinates?.last ?? 0.0
        let latitude = coordinates?.first ?? 0.0
        //self.lat  = position.latitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { [weak self] (placeMarks, error) -> Void in
            guard let self = self else { return }
            if error != nil {
                return
            }
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeMarks?[0]
            self.selectedAddress = Address(id: nil,
                                           name: nil,
                                           address: placeMark.thoroughfare,
                                           area: placeMark.subLocality,
                                           city: placeMark.administrativeArea,
                                           phone: nil,
                                           isDefault: 0,
                                           customerID: nil,
                                           createdAt: nil,
                                           updatedAt: nil,
                                           coordinates: self.mapCoordinates,
                                           buildingNumber: nil,
                                           floorNumber: nil,
                                           apartmentNumber: nil)
        })
    }
}

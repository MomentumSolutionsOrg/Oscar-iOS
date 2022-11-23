//
//  CheckoutProcessViewModel.swift
//  OSCAR
//
//  Created by Mostafa Samir on 09/08/2021.
//

import Foundation

class CheckoutProcessViewModel: BaseViewModel {
    //MARK: - Cart
    private(set) var cartProducts = [Product]() {
        didSet {
            if cartProducts.count >= 30,
               shouldShowThirtyItemPopUp {
                showThirtyItemPopUp?()
                shouldShowThirtyItemPopUp = false
            }else {
                shouldShowThirtyItemPopUp = true
            }
        }
    }
    private(set) var shouldShowThirtyItemPopUp = true
    var getCartSuccessCompletion: (() -> Void)?
    var showThirtyItemPopUp: (() -> Void)?
    var subtotal = 0.0
    var subtotalAfterDiscount = 0.0
    
    
    func fetchCart() {
        startRequest(request: CheckoutProcessApi.getCart, mappingClass: BaseModel<[Product]>.self) { [weak self] response in
            self?.cartProducts = response?.data ?? []
            self?.getCartSuccessCompletion?()
            self?.updateSubtotal()
        }
    }
    
    func updateSubtotal() {
        subtotal = cartProducts
            .compactMap { $0.total }
            .reduce(0.0) { $0 + $1 }
        subtotalAfterDiscount = subtotal
        CurrentUser.shared.cartCount = cartProducts.count
        CurrentUser.shared.cartTotal = subtotal
    }
    
    //MARK: - Checkout
    var getAddressesCompletion: (() -> Void)?
    private(set) var addresses = [Address]()
    var selectedAddress: Address? {
        didSet {
            fetchDeliveryFees()
        }
    }
    
    var getDeliveryFeesCompletion: (() -> Void)?
    var deliveryFees = [DeliveryFees]()
    var selectedDelivery: DeliveryFees? {
        didSet {
            if selectedDelivery?.flag?.contains(Constants.DeliveryTypes.schedule.rawValue) ?? false {
                selectedDeliveryType = .schedule
            }else {
                selectedDeliveryType = .sameDay
            }
        }
    }
    var scheduleDate: Date?
    private var sameDayDate: String  = {
        return Date().convertDateToString(format: Constants.Format.fullDate)
    }()
    
    var selectedPaymentType: Constants.PaymentMethodTypes =  .cashOnDelivery
    var selectedDeliveryType: Constants.DeliveryTypes = .sameDay
    
    var voucher: Voucher?
    var voucherCompletion: (() -> Void)?
    
    var createOrderCompletion: (() -> Void)?
    
    var transaction =  Transaction()
    
    func fetchAddresses() {
        startRequest(request: AddressApi.getAddresses, mappingClass: BaseModel<[Address]>.self) { [weak self] response in
            self?.addresses = response?.data ?? []
            self?.selectedAddress = response?.data?.first { $0.isDefault == 1 }
            self?.getAddressesCompletion?()
        }
    }
    
    
    
    func fetchDeliveryFees() {
        guard var coordinates = selectedAddress?.coordinates else { return }
        if coordinates.trim().isEmpty {
            coordinates = Utils.defaultCoordinate()
        }
        state = .loading
        Api().fireRequestWithSingleResponse(urlConvertible: CheckoutProcessApi.getDeliveryFees(coordinates: coordinates), mappingClass: BaseModel<[DeliveryFees]>.self).get { [weak self] response in
            //            guard let deliveryFees = response?.data else {
            //                self?.deliveryFees.removeAll()
            //                self?.getDeliveryFeesCompletion?()
            //                return
            //            }
            self?.state = .populated
            self?.deliveryFees = response.data ?? []
            self?.selectedDelivery = response.data?.first { $0.flag?.contains(self?.selectedDeliveryType.rawValue ?? "") ?? false }
            self?.getDeliveryFeesCompletion?()
            
        }.catch { [weak self] error in
            self?.deliveryFees.removeAll()
            self?.getDeliveryFeesCompletion?()
            self?.state = .error
            self?.updateError?((error as? MyError)?.message.localized ?? error.localizedDescription.description)
        }
    }
    
    
    func isSelectedFee(at indexPath: IndexPath) -> Bool {
        return selectedDelivery?.flag == deliveryFees[indexPath.row].flag
    }
    
    
    func validateVoucher(for name: String) {
        startRequest(request: CheckoutProcessApi.validateVoucher(name: name), mappingClass: BaseModel<Voucher>.self) { [weak self] response in
            self?.voucher = response?.data
            self?.voucherCompletion?()
        }
    }
    
    func calculateVoucherDiscount() -> Double {
        guard let voucher = voucher else { return 0.0 }
        let discount: Double = {
            switch voucher.voucherType?.lowercased() {
            case "egp":
                return Double(voucher.discountNumber ?? 0)
            case "%":
                let percentage = Double(voucher.discountNumber ?? 0) / 100.0
                return percentage * subtotal
            default:
                return 0.0
            }
        }()
        if discount > subtotal {
            subtotalAfterDiscount = 0.0
        }else {
            subtotalAfterDiscount = subtotal - discount
        }
        return round(discount * 100 ) / 100
    }
    
    func total() -> Double {
     
        let deliveryFees = Double(selectedDelivery?.cost ?? "20") ?? 20.0
        return round((subtotalAfterDiscount + deliveryFees) * 100 ) / 100
    }
    
    func isReadyToCheckout() -> Bool {
        return selectedDelivery != nil && selectedAddress != nil
    }
    
    func checkout() {
        guard let selectedAddress = selectedAddress,
              let selectedDelivery = selectedDelivery else { return }
        let paymentMethod: String = {
            switch selectedPaymentType {
            case .cashOnDelivery:
                return "cash"
            case .cardUponDelivery:
                return "card"
            case .visa:
                return "visa"
            }
        }()
        
        let deliveryDate: String? = {
            switch selectedDeliveryType {
            case .sameDay:
                return nil
            case .schedule:
                return scheduleDate?.convertDateToString(format: Constants.Format.fullDate) ?? sameDayDate
            }
        }()
        let parameters = OrderParameters(address: selectedAddress,
                                         paymentMethod: paymentMethod,
                                         cartItems: cartProducts,
                                         deliveryFee: selectedDelivery,
                                         deliveryDate: deliveryDate)
        startRequest(request: OrdersApi.createOrder(orderParameters: parameters), mappingClass: MessageModel.self) { [weak self] response in
            self?.createOrderCompletion?()
        }
    }
}

extension CheckoutProcessViewModel: CartCellDelegate {
    func updateItem(at index: Int, with quantity: Int) {
        let product = cartProducts[index]
        let addToCartParams = AddToCartParameters(productId: product.id ?? "1",
                                                  quantity: quantity,
                                                  weight: product.weight ?? "1")
        startRequest(request: CheckoutProcessApi.addToCart(parameters: addToCartParams), mappingClass: MessageModel.self) { [weak self] _ in
            self?.fetchCart()
        }
    }
}
